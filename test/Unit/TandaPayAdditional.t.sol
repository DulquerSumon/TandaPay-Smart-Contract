// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

import {TandaPay, Secretary, Context, ReentrancyGuard, TandaPayEvents} from "../../src/TandaPay.sol";
import {Token, IERC20} from "../../src/Token.sol";

contract AdditionalContext is Context {
    function msgSender() public view virtual returns (address) {
        return _msgSender();
    }

    function msgData() public view virtual returns (bytes calldata) {
        return _msgData();
    }
}

contract AdditionalSecretary is Secretary {
    constructor(address newSecretary) Secretary(newSecretary) {}

    function transferSecretary(address _new) public onlySecretary {
        _transferSecretary(_new);
    }
}

contract AdditionalReentrancyGuard is ReentrancyGuard {
    function reentrancyGuardEntered() public view returns (bool) {
        return _reentrancyGuardEntered();
    }
}

contract AdditionalToken is Token {
    constructor() Token(msg.sender) {}
    function burn(address account, uint256 value) public {
        _burn(account, value);
    }
}

contract TandaPayAdditionalTest is Test {
    AdditionalContext public additionalContext;
    AdditionalSecretary public secretary;
    AdditionalReentrancyGuard public reentrancyGuard;

    Token public paymentToken;
    address public initialSecretary = address(this);
    address public member1 = address(1);
    address public member2 = address(2);
    function setUp() public {
        additionalContext = new AdditionalContext();
        secretary = new AdditionalSecretary(initialSecretary);
        reentrancyGuard = new AdditionalReentrancyGuard();
        paymentToken = new Token(address(this));
    }

    function testIf_msgSenderFunctionWorksProperly() public {
        address messageSender = member1;
        vm.startPrank(messageSender);
        address sender = additionalContext.msgSender();
        vm.stopPrank();
        assertEq(sender, messageSender);
    }

    function testIf_msgDataFunctionWorksProperly() public view {
        bytes memory data = additionalContext.msgData();
        assertTrue(data.length > 0);
    }

    function testConstructorOfSecretary() public {
        address initialSecretary2 = member1;
        vm.startPrank(initialSecretary2);
        AdditionalSecretary secretaryContract = new AdditionalSecretary(
            initialSecretary2
        );
        vm.stopPrank();
        assertEq(secretaryContract.secretary(), initialSecretary2);
    }

    function testIftransferSecretaryFunctionWorksProperly() public {
        address newMember = member2;
        address oldSecretary = secretary.secretary();
        vm.expectEmit(address(secretary));
        emit Secretary.SecretaryTransferred(oldSecretary, newMember);
        secretary.transferSecretary(newMember);
        address newSecretary = secretary.secretary();
        assertEq(newSecretary, newMember);
    }

    function testIf_reentrancyGuardEnteredFunctionWorksProperly() public view {
        bool entered = reentrancyGuard.reentrancyGuardEntered();
        assertEq(entered, false);
    }

    function testConstructorOfReentrancyGuard() public {
        AdditionalReentrancyGuard reentrancyContract = new AdditionalReentrancyGuard();
        bool entered = reentrancyContract.reentrancyGuardEntered();
        assertEq(entered, false);
    }

    function testConstructorOfPaymentToken() public {
        address initialRecipient = member1;
        uint256 expectedTotalSupply = 10000000000000000000 * 10 ** 18;
        string memory expectedname = "LUSD";
        string memory expectedsymbol = "LUSD";
        vm.startPrank(initialRecipient);
        Token tokenContract = new Token(initialRecipient);
        vm.stopPrank();
        string memory name = tokenContract.name();
        assertEq(expectedname, name);
        string memory symbol = tokenContract.symbol();
        assertEq(expectedsymbol, symbol);
        uint256 totalSupply = tokenContract.totalSupply();
        assertEq(expectedTotalSupply, totalSupply);
        uint256 balanceOfInitalRecipient = tokenContract.balanceOf(
            initialRecipient
        );
        assertEq(balanceOfInitalRecipient, expectedTotalSupply);
    }

    function testIfdecimalsFunctionWorksProperly() public view {
        uint8 decimals = paymentToken.decimals();
        assertEq(decimals, 18);
    }

    function testIfallowanceFunctionWorksProperly() public view {
        uint256 allowance = paymentToken.allowance(member1, address(this));
        assertEq(allowance, 0);
    }

    function testIfincreaseAllowanceFunctionWorksProperly() public {
        uint256 amount = 10000 * 10 ** 18;
        uint256 allowance = paymentToken.allowance(member1, address(this));
        assertEq(allowance, 0);
        vm.startPrank(member1);
        paymentToken.increaseAllowance(address(this), amount);
        vm.stopPrank();
        uint256 allowanceAfter = paymentToken.allowance(member1, address(this));
        assertEq(allowanceAfter, amount);
    }
    function testIfdecreaseAllowanceFunctionWorksProperly() public {
        uint256 amount = 10000 * 10 ** 18;
        uint256 allowance = paymentToken.allowance(member1, address(this));
        assertEq(allowance, 0);
        vm.startPrank(member1);
        paymentToken.increaseAllowance(address(this), amount);
        uint256 allowanceAfter = paymentToken.allowance(member1, address(this));
        assertEq(allowanceAfter, amount);

        uint256 decreaseAmount = 10e18;
        paymentToken.decreaseAllowance(address(this), decreaseAmount);
        uint256 allowanceAfter2 = paymentToken.allowance(
            member1,
            address(this)
        );
        assertEq(allowanceAfter2, amount - decreaseAmount);
        vm.stopPrank();
    }

    function testIfTokenCanBeBurn() public {
        uint256 amount = 10000 * 10 ** 18;
        AdditionalToken tokenContract = new AdditionalToken();
        tokenContract.burn(address(this), amount);
    }
}

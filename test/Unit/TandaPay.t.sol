// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {TandaPay, Ownable} from "../../src/TandaPay.sol";
import {Token} from "../../src/Token.sol";

contract TandaPayTest is Test {
    TandaPay public tandaPay;
    Token public paymentToken;
    address public member1 = address(1);
    address public member2 = address(2);
    address public member3 = address(3);
    address public member4 = address(4);
    address public member5 = address(5);
    address public member6 = address(6);
    address public member7 = address(7);
    address public member8 = address(8);
    address public member9 = address(9);
    address public member10 = address(10);
    address public member11 = address(11);
    address public member12 = address(12);
    address public member13 = address(13);
    address public member14 = address(14);
    address public member15 = address(15);
    address public member16 = address(16);
    address public member17 = address(17);
    address public member18 = address(18);
    address public member19 = address(19);
    address public member20 = address(20);
    address public member21 = address(21);
    address public member22 = address(22);
    address public member23 = address(23);
    address public member24 = address(24);
    address public member25 = address(25);
    address public member26 = address(26);
    address public member27 = address(27);
    address public member28 = address(28);
    address public member29 = address(29);
    address public member30 = address(30);
    address public member31 = address(31);
    address public member32 = address(32);
    address public member33 = address(33);
    address public member34 = address(34);
    address public member35 = address(35);
    address public member36 = address(36);
    address public NotMember = address(99);
    address[] public addss;
    function setUp() public {
        paymentToken = new Token(address(this));
        tandaPay = new TandaPay(address(paymentToken));
    }

    function testIfRevertIfThePersonAddingMemberIsNotTheSecretary() public {
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedSecretary.selector,
                member1
            )
        );
        tandaPay.addToCommunity(member1);
        vm.stopPrank();
    }

    function testIfSecretaryCanAddMember() public {
        tandaPay.addToCommunity(member1);
    }

    function testIfRevertIfThePersonAssigningMemberToSubGroupIsNotTheSecretary()
        public
    {
        tandaPay.addToCommunity(member1);
        tandaPay.createSubGroup();
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedSecretary.selector,
                member1
            )
        );
        tandaPay.assignToSubGroup(member1, 1, false);
        vm.stopPrank();
    }

    function testRevertIfTheMemberWhichISAssigningToSubGroupIsNotAMember()
        public
    {
        tandaPay.createSubGroup();
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.InvalidMember.selector)
        );
        tandaPay.assignToSubGroup(member1, 1, false);
    }

    function testIfSecretaryCanAssignMemberToSugGroup() public {
        tandaPay.addToCommunity(member1);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(member1, 1, false);
    }

    function testIfRevertIfTheWalletApprovingTheSubGroupAssignmentIsNotTheMember()
        public
    {
        tandaPay.addToCommunity(member1);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(member1, 1, false);
        vm.startPrank(member2);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotAssignedYet.selector)
        );
        tandaPay.approveSubGroupAssignment(true);
        vm.stopPrank();
    }

    function testIfMemberCanApproveSubGroupAssignment() public {
        tandaPay.addToCommunity(member1);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(member1, 1, false);
        vm.startPrank(member1);
        tandaPay.approveSubGroupAssignment(true);
        vm.stopPrank();
    }

    function testIfRevertIfMemberIsNotReorging() public {
        tandaPay.addToCommunity(member1);
        tandaPay.addToCommunity(member2);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(member1, 1, false);
        vm.startPrank(member1);
        tandaPay.approveSubGroupAssignment(true);
        vm.stopPrank();
        vm.startPrank(member2);
        vm.expectRevert(abi.encodeWithSelector(TandaPay.NotReorged.selector));
        tandaPay.approveNewSubgroupMember(1, 1, true);
        vm.stopPrank();
    }

    // function testRevertIfTheApproverIsNotAValidGroupMember() public {
    //     paymentToken.transfer(member1, 10e18);
    //     tandaPay.addToCommunity(member1);
    //     tandaPay.createSubGroup();
    //     tandaPay.assignToSubGroup(1, 1, false);
    //     vm.startPrank(member1);
    //     tandaPay.approveSubGroupAssignment(true);
    //     vm.stopPrank();
    //     tandaPay.setInitialCoverage(1e18);
    //     vm.startPrank(member1);
    //     paymentToken.approve(address(tandaPay), 10e18);
    //     tandaPay.payPremium();
    //     vm.stopPrank();
    //     tandaPay.initializePeriod(0);
    //     skip(27 days);
    //     tandaPay.payPremium();
    //     tandaPay.initializePeriod(0);
    //     tandaPay.createSubGroup();
    //     tandaPay.assignToSubGroup(1, 2, true);
    //     vm.startPrank(member2);
    //     tandaPay.approveNewSubgroupMember(1, 1, true);
    //     vm.stopPrank();
    // }

    function testRevertIfCallerIsNotAMemberWhileDefecting() public {
        tandaPay.createSubGroup();
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotValidMember.selector)
        );
        tandaPay.defects();
        vm.stopPrank();
    }

    function testRevertIfMemberDefectingAtNoDefectWindow() public {
        tandaPay.addToCommunity(member1);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(member1, 1, false);
        vm.startPrank(member1);
        tandaPay.approveSubGroupAssignment(true);
        skip(4 days);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotDefectWindow.selector)
        );
        tandaPay.defects();

        vm.stopPrank();
    }

    // function testRevertIfNoClaimOccured() public {
    //     tandaPay.addToCommunity(member1);
    //     tandaPay.createSubGroup();
    //     tandaPay.assignToSubGroup(member1, 1, false);
    //     vm.startPrank(member1);
    //     tandaPay.approveSubGroupAssignment(true);
    //     vm.expectRevert(
    //         abi.encodeWithSelector(TandaPay.ClaimNoOccured.selector)
    //     );
    //     tandaPay.defects();
    //     vm.stopPrank();
    // }

    function helperAddition(address _member, uint256 _gId) public {
        tandaPay.addToCommunity(_member);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(_member, _gId, false);
        vm.startPrank(_member);
        tandaPay.approveSubGroupAssignment(true);
        vm.stopPrank();
    }

    function testRevertIfSuccessorIsLessThan2WhileMemberIsBetween12To35()
        public
    {
        helperAddition(member1, 1);
        helperAddition(member2, 2);
        helperAddition(member3, 3);
        helperAddition(member4, 4);
        helperAddition(member5, 5);
        helperAddition(member6, 6);
        helperAddition(member7, 7);
        helperAddition(member8, 8);
        helperAddition(member9, 9);
        helperAddition(member10, 10);
        helperAddition(member11, 11);
        helperAddition(member12, 12);
        helperAddition(member13, 13);
        helperAddition(member14, 14);
        helperAddition(member15, 15);
        helperAddition(member16, 16);
        helperAddition(member17, 17);
        helperAddition(member18, 18);
        helperAddition(member19, 19);
        helperAddition(member20, 20);

        for (uint256 j = 0; j < 1; j++) {
            addss.push(member1);
        }
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NeedMoreSuccessor.selector)
        );
        tandaPay.defineSecretarySuccessor(addss);
    }
    function testRevertIfSuccessorIsLessThan2WhileMemberIsMoreThan35() public {
        helperAddition(member1, 1);
        helperAddition(member2, 2);
        helperAddition(member3, 3);
        helperAddition(member4, 4);
        helperAddition(member5, 5);
        helperAddition(member6, 6);
        helperAddition(member7, 7);
        helperAddition(member8, 8);
        helperAddition(member9, 9);
        helperAddition(member10, 10);
        helperAddition(member11, 11);
        helperAddition(member12, 12);
        helperAddition(member13, 13);
        helperAddition(member14, 14);
        helperAddition(member15, 15);
        helperAddition(member16, 16);
        helperAddition(member17, 17);
        helperAddition(member18, 18);
        helperAddition(member19, 19);
        helperAddition(member20, 20);
        helperAddition(member21, 21);
        helperAddition(member22, 22);
        helperAddition(member23, 23);
        helperAddition(member24, 24);
        helperAddition(member25, 25);
        helperAddition(member26, 26);
        helperAddition(member27, 27);
        helperAddition(member28, 28);
        helperAddition(member29, 29);
        helperAddition(member30, 30);
        helperAddition(member31, 31);
        helperAddition(member32, 32);
        helperAddition(member33, 33);
        helperAddition(member34, 34);
        helperAddition(member35, 35);
        helperAddition(member36, 36);
        // helperAddition(member37, 37);

        for (uint256 j = 0; j < 4; j++) {
            addss.push(member1);
        }
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NeedMoreSuccessor.selector)
        );
        tandaPay.defineSecretarySuccessor(addss);
    }

    function testRevertIfTheSuccessorIsNotAMember() public {
        helperAddition(member1, 1);
        helperAddition(member2, 2);
        helperAddition(member3, 3);
        helperAddition(member4, 4);
        helperAddition(member5, 5);
        helperAddition(member6, 6);
        helperAddition(member7, 7);
        helperAddition(member8, 8);
        helperAddition(member9, 9);
        helperAddition(member10, 10);
        helperAddition(member11, 11);
        helperAddition(member12, 12);
        helperAddition(member13, 13);
        helperAddition(member14, 14);
        helperAddition(member15, 15);
        helperAddition(member16, 16);
        helperAddition(member17, 17);
        helperAddition(member18, 18);
        helperAddition(member19, 19);
        helperAddition(member20, 20);

        for (uint256 j = 0; j < 2; j++) {
            addss.push(NotMember);
        }
        vm.expectRevert(abi.encodeWithSelector(TandaPay.NotIncluded.selector));
        tandaPay.defineSecretarySuccessor(addss);
    }

    function testRevertIfHandoverSecretaryIsNotInSecretarySuccessorsList()
        public
    {
        vm.expectRevert(abi.encodeWithSelector(TandaPay.NotIncluded.selector));
        tandaPay.handoverSecretary(member1);
    }

    function testRevertIfNotHandingOverWhileSecretaryAcceptance() public {
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotHandingOver.selector)
        );
        tandaPay.secretaryAcceptance();
    }

    function testIfRevertIfSenderIsNotAMemberWhileAcceptingSecretary() public {
        tandaPay.addToCommunity(member1);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(member1, 1, false);
        vm.startPrank(member1);
        tandaPay.approveSubGroupAssignment(true);
        vm.stopPrank();
        for (uint256 o = 0; o < 2; o++) {
            addss.push(member1);
        }
        tandaPay.defineSecretarySuccessor(addss);
        tandaPay.handoverSecretary(member1);
        vm.startPrank(member2);
        vm.expectRevert(abi.encodeWithSelector(TandaPay.NotIncluded.selector));
        tandaPay.secretaryAcceptance();
        vm.stopPrank();
    }

    function testIfRevertIfNotInInjectWindowWhileInjectingFunds() public {
        skip(5 days);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInInjectionWindow.selector)
        );
        tandaPay.injectFunds();
    }

    function testRevertIfNoClaimOccurWhileInjectingFunds() public {
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NoClaimOccured.selector)
        );
        tandaPay.injectFunds();
    }
    function testIfRevertIfNoClaimOccureWhileDividingShortfall() public {
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NoClaimOccured.selector)
        );
        tandaPay.divideShortFall();
    }
    function testIfRevertIfNotInInjectionWindowWhileDividingShortfall() public {
        skip(5 days);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInInjectionWindow.selector)
        );
        tandaPay.divideShortFall();
    }

    function testIfCanAddAddtionalDayBySecretary() public {
        tandaPay.addAdditionalDay();
    }

    function testIfRevertIfSenderIsNotSecretaryWhileCallingAddAdditionalDay()
        public
    {
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedSecretary.selector,
                member1
            )
        );
        tandaPay.addAdditionalDay();
        vm.stopPrank();
    }

    function testIfCanManuallyCollapseBySecretary() public {
        tandaPay.manualCollapsBySecretary();
    }

    function testIfRevertIfSenderIsNotTheSecretaryWhileManualCollpase() public {
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedSecretary.selector,
                member1
            )
        );
        tandaPay.manualCollapsBySecretary();
        vm.stopPrank();
    }

    function testIfRevertIfNotInManualCollapseWhileCallingCancelManualCollapse()
        public
    {
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInManualCollaps.selector)
        );

        tandaPay.cancelManualCollapsBySecretary();
    }

    function testIfCanCancelManualCollapse() public {
        tandaPay.manualCollapsBySecretary();
        tandaPay.cancelManualCollapsBySecretary();
    }
}

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
        tandaPay.assignToSubGroup(1, 1, false);
        vm.stopPrank();
    }

    function testRevertIfTheMemberWhichISAssigningToSubGroupIsNotAMember()
        public
    {
        tandaPay.createSubGroup();
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.InvalidMember.selector)
        );
        tandaPay.assignToSubGroup(1, 1, false);
    }

    function testIfSecretaryCanAssignMemberToSugGroup() public {
        tandaPay.addToCommunity(member1);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(1, 1, false);
    }

    function testIfRevertIfTheWalletApprovingTheSubGroupAssignmentIsNotTheMember()
        public
    {
        tandaPay.addToCommunity(member1);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(1, 1, false);
        vm.startPrank(member2);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.InvalidMember.selector)
        );
        tandaPay.approveSubGroupAssignment(true);
        vm.stopPrank();
    }

    function testIfMemberCanApproveSubGroupAssignment() public {
        tandaPay.addToCommunity(member1);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(1, 1, false);
        vm.startPrank(member1);
        tandaPay.approveSubGroupAssignment(true);
        vm.stopPrank();
    }

    function testIfRevertIfMemberIsNotReorging() public {
        tandaPay.addToCommunity(member1);
        tandaPay.addToCommunity(member2);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(1, 1, false);
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
        tandaPay.defects(1);
        vm.stopPrank();
    }

    function testRevertIfMemberDefectingAtNoDefectWindow() public {
        tandaPay.addToCommunity(member1);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(1, 1, false);
        vm.startPrank(member1);
        tandaPay.approveSubGroupAssignment(true);
        skip(4 days);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotDefectWindow.selector)
        );
        tandaPay.defects(1);
        vm.stopPrank();
    }

    function testRevertIfNoClaimOccured() public {
        tandaPay.addToCommunity(member1);
        tandaPay.createSubGroup();
        tandaPay.assignToSubGroup(1, 1, false);
        vm.startPrank(member1);
        tandaPay.approveSubGroupAssignment(true);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.ClaimNoOccured.selector)
        );
        tandaPay.defects(1);
        vm.stopPrank();
    }

    function testRevertIfSuccessorIsLessThan2WhileMemberIsBetween12To35()
        public
    {
        for (uint256 i = 1; i < 19; i++) {
            tandaPay.addToCommunity(member1);
            tandaPay.createSubGroup();
            tandaPay.assignToSubGroup(i, i, false);
            vm.startPrank(member1);
            tandaPay.approveSubGroupAssignment(true);
            vm.stopPrank();
        }

        for (uint256 j = 0; j < 1; j++) {
            addss.push(member1);
        }
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NeedMoreSuccessor.selector)
        );
        tandaPay.defineSecretarySuccessor(addss);
    }
    function testRevertIfSuccessorIsLessThan2WhileMemberIsMoreThan35() public {
        for (uint256 i = 1; i < 37; i++) {
            tandaPay.addToCommunity(member1);
            tandaPay.createSubGroup();
            tandaPay.assignToSubGroup(i, i, false);
            vm.startPrank(member1);
            tandaPay.approveSubGroupAssignment(true);
            vm.stopPrank();
        }

        for (uint256 j = 0; j < 4; j++) {
            addss.push(member1);
        }
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NeedMoreSuccessor.selector)
        );
        tandaPay.defineSecretarySuccessor(addss);
    }

    function testRevertIfTheSuccessorIsNotAMember() public {
        for (uint256 i = 1; i < 19; i++) {
            tandaPay.addToCommunity(member1);
            tandaPay.createSubGroup();
            tandaPay.assignToSubGroup(i, i, false);
            vm.startPrank(member1);
            tandaPay.approveSubGroupAssignment(true);
            vm.stopPrank();
        }

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
        tandaPay.assignToSubGroup(1, 1, false);
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
        tandaPay.injectFunds(1e18);
    }

    function testRevertIfNoClaimOccurWhileInjectingFunds() public {
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NoClaimOccured.selector)
        );
        tandaPay.injectFunds(1e18);
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

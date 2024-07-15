// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {TandaPay, Secretary, TandaPayEvents} from "../../src/TandaPay.sol";
import {Token, IERC20} from "../../src/Token.sol";

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
    address[] public successors;
    uint256 public basePremium;
    function setUp() public {
        paymentToken = new Token(address(this));
        tandaPay = new TandaPay(address(paymentToken));
        paymentToken.approve(address(tandaPay), 100000000000e18);
        paymentToken.transfer(member1, 1000e18);
        paymentToken.transfer(member2, 1000e18);
        paymentToken.transfer(member2, 1000e18);
        paymentToken.transfer(member3, 1000e18);
        paymentToken.transfer(member4, 1000e18);
        paymentToken.transfer(member5, 1000e18);
        paymentToken.transfer(member6, 1000e18);
        paymentToken.transfer(member7, 1000e18);
        paymentToken.transfer(member8, 1000e18);
        paymentToken.transfer(member9, 1000e18);
        paymentToken.transfer(member10, 1000e18);
        paymentToken.transfer(member11, 1000e18);
        paymentToken.transfer(member12, 1000e18);
        paymentToken.transfer(member13, 1000e18);
        paymentToken.transfer(member14, 1000e18);
        paymentToken.transfer(member15, 1000e18);
        paymentToken.transfer(member16, 1000e18);
        paymentToken.transfer(member17, 1000e18);
        paymentToken.transfer(member18, 1000e18);
        paymentToken.transfer(member19, 1000e18);
        paymentToken.transfer(member20, 1000e18);
        paymentToken.transfer(member21, 1000e18);
        paymentToken.transfer(member22, 1000e18);
        paymentToken.transfer(member23, 1000e18);
        paymentToken.transfer(member24, 1000e18);
        paymentToken.transfer(member25, 1000e18);
        paymentToken.transfer(member26, 1000e18);
        paymentToken.transfer(member27, 1000e18);
        paymentToken.transfer(member28, 1000e18);
        paymentToken.transfer(member29, 1000e18);
        paymentToken.transfer(member30, 1000e18);
        paymentToken.transfer(member31, 1000e18);
        paymentToken.transfer(member32, 1000e18);
        paymentToken.transfer(member33, 1000e18);
        paymentToken.transfer(member34, 1000e18);
        paymentToken.transfer(member35, 1000e18);
        paymentToken.transfer(member36, 1000e18);
    }

    function addToCommunity(address _member) public {
        uint256 mIdBefore = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(_member, mIdBefore + 1);
        tandaPay.addToCommunity(_member);
        uint256 mIdAfter = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore + 1, mIdAfter);
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            _member,
            0
        );
        assertEq(mInfo.associatedGroupId, 0);

        assertEq(mInfo.member, _member);
        assertEq(mInfo.memberId, mIdAfter);
        assertEq(
            uint8(mInfo.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
    }

    function createASubGroup() public returns (uint256) {
        uint256 gIdBefore = tandaPay.getCurrentSubGroupId();
        vm.expectEmit();
        emit TandaPayEvents.SubGroupCreated(gIdBefore + 1);
        tandaPay.createSubGroup();
        uint256 gIdAfter = tandaPay.getCurrentSubGroupId();
        assertEq(gIdBefore + 1, gIdAfter);
        TandaPay.SubGroupInfo memory sInfo = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter);
        assertEq(sInfo.id, gIdAfter);
        return gIdAfter;
    }

    function assignToSubGroup(
        address _member,
        uint256 _gId,
        uint256 _expectedMember
    ) public {
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(_member, _gId, false);
        tandaPay.assignToSubGroup(_member, _gId, false);
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            _member,
            0
        );
        assertEq(mInfo.associatedGroupId, _gId);
        TandaPay.SubGroupInfo memory sInfo = tandaPay
            .getSubGroupIdToSubGroupInfo(_gId);
        assertEq(sInfo.id, _gId);
        bool isIn;
        for (uint256 i = 0; i < sInfo.members.length; i++) {
            if (sInfo.members[i] == _member) {
                isIn = true;
            }
        }
        assertTrue(isIn);
        assertEq(sInfo.members.length, _expectedMember);
        if (sInfo.members.length >= 4) {
            assertTrue(sInfo.isValid);
        } else {
            assertFalse(sInfo.isValid);
        }
    }

    function joinToCommunity(address _member, uint256 joinFee) public {
        vm.startPrank(_member);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m1BalanceBefore = paymentToken.balanceOf(_member);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(_member, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m1BalanceAfter = paymentToken.balanceOf(_member);
        assertEq(m1BalanceBefore, m1BalanceAfter + joinFee);
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            _member,
            0
        );
        assertEq(joinFee, mInfo.ISEscorwAmount);
        assertEq(uint8(mInfo.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
    }

    function approveSubGroupAssignment(
        address _member,
        bool shouldJoin
    ) public {
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            _member,
            0
        );
        vm.startPrank(_member);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ApprovedGroupAssignment(
            _member,
            mInfo.associatedGroupId,
            shouldJoin
        );
        tandaPay.approveSubGroupAssignment(shouldJoin);
        mInfo = tandaPay.getMemberToMemberInfo(_member, 0);
        assertEq(
            uint8(mInfo.assignment),
            uint8(TandaPay.AssignmentStatus.AssignmentSuccessfull)
        );
        vm.stopPrank();
    }

    function payPremium(
        address _member,
        uint256 pFee,
        uint256 nPId,
        bool _fromATW
    ) public {
        vm.startPrank(_member);
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            _member,
            nPId + 1
        );
        vm.expectEmit(address(tandaPay));
        // emit IERC20.Transfer(
        //     _member,
        //     address(tandaPay),
        //     _fromATW
        //         ? (mInfo.availableToWithdraw -
        //             (basePremium + (pFee - mInfo.ISEscorwAmount)))
        //         : basePremium + (pFee - mInfo.ISEscorwAmount)
        // );
        emit TandaPayEvents.PremiumPaid(
            _member,
            nPId,
            _fromATW
                ? mInfo.availableToWithdraw >
                    basePremium + (pFee - mInfo.ISEscorwAmount)
                    ? (mInfo.availableToWithdraw -
                        (basePremium + (pFee - mInfo.ISEscorwAmount)))
                    : basePremium +
                        (pFee - mInfo.ISEscorwAmount) -
                        mInfo.availableToWithdraw
                : basePremium + (pFee - mInfo.ISEscorwAmount),
            _fromATW
        );
        tandaPay.payPremium(_fromATW);
        mInfo = tandaPay.getMemberToMemberInfo(_member, nPId + 1);
        assertTrue(mInfo.eligibleForCoverageInPeriod);
        assertTrue(mInfo.isPremiumPaid);
        assertEq(mInfo.cEscrowAmount, basePremium);
        assertEq(mInfo.ISEscorwAmount, pFee);
        vm.stopPrank();
    }

    function testIfRevertIfThePersonAddingMemberIsNotTheSecretary() public {
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Secretary.SecretaryUnauthorizedSecretary.selector,
                member1
            )
        );
        tandaPay.addToCommunity(member1);
        uint256 mId = tandaPay.getCurrentMemberId();
        assertEq(mId, uint256(0));
        vm.stopPrank();
    }

    function testIfRevertIfStatesIsNotInInitializationOrDefault() public {
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ManualCollapsedHappenend();
        tandaPay.manualCollapsBySecretary();
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.COLLAPSED));
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInIniOrDef.selector)
        );
        tandaPay.addToCommunity(member1);
        uint256 mId = tandaPay.getCurrentMemberId();
        assertEq(mId, uint256(0));
    }

    function testIfRevertIfAlreadyAddedMember() public {
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member1, 1);
        tandaPay.addToCommunity(member1);
        uint256 mId = tandaPay.getCurrentMemberId();
        assertEq(mId, uint256(1));
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo.associatedGroupId, 0);
        assertEq(mInfo.member, member1);
        assertEq(mInfo.memberId, mId);
        vm.expectRevert(abi.encodeWithSelector(TandaPay.AlreadyAdded.selector));
        tandaPay.addToCommunity(member1);
    }

    function testIfSecretaryCanAddMember() public {
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member1, 1);
        tandaPay.addToCommunity(member1);
        uint256 mId = tandaPay.getCurrentMemberId();
        assertEq(mId, uint256(1));
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo.associatedGroupId, 0);
        assertEq(mInfo.member, member1);
        assertEq(mInfo.memberId, mId);
        assertEq(
            uint8(mInfo.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
    }

    function testIfSecretaryCanCreateASubGroup() public {
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SubGroupCreated(1);
        tandaPay.createSubGroup();
        uint256 gId = tandaPay.getCurrentSubGroupId();
        assertEq(gId, uint256(1));
        TandaPay.SubGroupInfo memory sInfo = tandaPay
            .getSubGroupIdToSubGroupInfo(gId);
        assertEq(sInfo.id, gId);
    }

    function testIfRevertIfThePersonCreatingSubGroupIsNotTheSecretary() public {
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Secretary.SecretaryUnauthorizedSecretary.selector,
                member1
            )
        );
        tandaPay.createSubGroup();
        vm.stopPrank();
    }

    function testIfRevertIfThePersonAssigningMemberToSubGroupIsNotTheSecretary()
        public
    {
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member1, 1);
        tandaPay.addToCommunity(member1);
        uint256 mId = tandaPay.getCurrentMemberId();
        assertEq(mId, uint256(1));
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo.associatedGroupId, 0);
        assertEq(mInfo.member, member1);
        assertEq(mInfo.memberId, mId);
        assertEq(
            uint8(mInfo.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SubGroupCreated(1);
        tandaPay.createSubGroup();
        uint256 gId = tandaPay.getCurrentSubGroupId();
        assertEq(gId, uint256(1));
        TandaPay.SubGroupInfo memory sInfo = tandaPay
            .getSubGroupIdToSubGroupInfo(gId);
        assertEq(sInfo.id, gId);

        vm.startPrank(member2);
        vm.expectRevert(
            abi.encodeWithSelector(
                Secretary.SecretaryUnauthorizedSecretary.selector,
                member2
            )
        );
        tandaPay.assignToSubGroup(member1, 1, false);
        vm.stopPrank();
    }

    function testRevertIfTheMemberWhichISAssigningToSubGroupIsNotAMember()
        public
    {
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SubGroupCreated(1);
        tandaPay.createSubGroup();
        uint256 gId = tandaPay.getCurrentSubGroupId();
        assertEq(gId, uint256(1));
        TandaPay.SubGroupInfo memory sInfo = tandaPay
            .getSubGroupIdToSubGroupInfo(gId);
        assertEq(sInfo.id, gId);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.InvalidMember.selector)
        );
        tandaPay.assignToSubGroup(member1, gId, false);
    }

    function testIfRevertIfTheMemberAssigningToTheSubGroupIsNotValidSubGroup()
        public
    {
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member1, 1);
        tandaPay.addToCommunity(member1);
        uint256 mId = tandaPay.getCurrentMemberId();
        assertEq(mId, uint256(1));
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo.associatedGroupId, 0);
        assertEq(mInfo.member, member1);
        assertEq(mInfo.memberId, mId);
        assertEq(
            uint8(mInfo.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 gIdBefore = tandaPay.getCurrentSubGroupId();
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.InvalidSubGroup.selector)
        );
        tandaPay.assignToSubGroup(member1, 1, false);
        uint256 gIdAfter = tandaPay.getCurrentSubGroupId();
        assertEq(gIdBefore, gIdAfter);
    }

    function testIfSecretaryCanAssignMemberToSugGroup() public {
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member1, 1);
        tandaPay.addToCommunity(member1);
        uint256 mId = tandaPay.getCurrentMemberId();
        assertEq(mId, uint256(1));
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo.associatedGroupId, 0);
        assertEq(mInfo.member, member1);
        assertEq(mInfo.memberId, mId);
        assertEq(
            uint8(mInfo.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SubGroupCreated(1);
        tandaPay.createSubGroup();
        uint256 gId = tandaPay.getCurrentSubGroupId();
        assertEq(gId, uint256(1));
        TandaPay.SubGroupInfo memory sInfo = tandaPay
            .getSubGroupIdToSubGroupInfo(gId);
        assertEq(sInfo.id, gId);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member1, gId, false);
        tandaPay.assignToSubGroup(member1, gId, false);
        sInfo = tandaPay.getSubGroupIdToSubGroupInfo(gId);
        assertEq(sInfo.id, gId);
        mInfo = tandaPay.getMemberToMemberInfo(member1, 0);
        assertEq(mId, uint256(1));
        assertEq(mInfo.associatedGroupId, gId);
        assertEq(sInfo.members[0], member1);
    }

    function testIfStatusIsValidOfTheSubGroupIfMemberCountIsMoreThan4AndLessThanOrEqualTo7()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);

        uint256 gIdAfter = createASubGroup();

        assignToSubGroup(member1, gIdAfter, 1);

        assignToSubGroup(member2, gIdAfter, 2);
        assignToSubGroup(member3, gIdAfter, 3);
        assignToSubGroup(member4, gIdAfter, 4);
        assignToSubGroup(member5, gIdAfter, 5);
        assignToSubGroup(member6, gIdAfter, 6);
        assignToSubGroup(member7, gIdAfter, 7);
    }

    function testIfRevertWhileJoiningIfStateIsNotInDefault() public {
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInInDefault.selector)
        );
        tandaPay.joinToCommunity();
        vm.stopPrank();
        TandaPay.CommunityStates states0 = tandaPay.getCommunityState();
        assertEq(
            uint8(states0),
            uint8(TandaPay.CommunityStates.INITIALIZATION)
        );
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ManualCollapsedHappenend();
        tandaPay.manualCollapsBySecretary();
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.COLLAPSED));
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInInDefault.selector)
        );
        tandaPay.joinToCommunity();
        vm.stopPrank();
    }

    function testIfRevertIfTheMemberTryingToJoinisNotAssignToTheGroupYet()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);

        uint256 coverage = 10e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        paymentToken.transfer(member13, 1000e18);
        vm.startPrank(member13);
        paymentToken.approve(address(tandaPay), 1000e18);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInAssigned.selector)
        );
        tandaPay.joinToCommunity();
        vm.stopPrank();
    }

    function testIfUserCanJoinCommunity() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);

        uint256 coverage = 10e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        paymentToken.transfer(member12, 1000e18);
        vm.startPrank(member12);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 bPAmount = tandaPay.getBasePremium();

        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
        joinToCommunity(member12, joinFee);
    }

    function testIfRevertIfStateIsNotInInitializationWhileInitiatingDefaultState()
        public
    {
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ManualCollapsedHappenend();
        tandaPay.manualCollapsBySecretary();
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.COLLAPSED));
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInInitilization.selector)
        );
        tandaPay.initiatDefaultStateAndSetCoverage(10e18);
        vm.stopPrank();
    }

    function testIfRevertIfMemberIsLessThan12WhileInitiatingDefaultState()
        public
    {
        uint256 gIdBefore1 = tandaPay.getCurrentSubGroupId();
        vm.expectEmit();
        emit TandaPayEvents.SubGroupCreated(gIdBefore1 + 1);
        tandaPay.createSubGroup();
        uint256 gIdAfter1 = tandaPay.getCurrentSubGroupId();
        assertEq(gIdBefore1 + 1, gIdAfter1);
        TandaPay.SubGroupInfo memory sInfo1 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        uint256 gIdBefore2 = tandaPay.getCurrentSubGroupId();
        vm.expectEmit();
        emit TandaPayEvents.SubGroupCreated(gIdBefore2 + 1);
        tandaPay.createSubGroup();
        uint256 gIdAfter2 = tandaPay.getCurrentSubGroupId();
        assertEq(gIdBefore2 + 1, gIdAfter2);
        TandaPay.SubGroupInfo memory sInfo2 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);

        uint256 gIdBefore3 = tandaPay.getCurrentSubGroupId();
        vm.expectEmit();
        emit TandaPayEvents.SubGroupCreated(gIdBefore3 + 1);
        tandaPay.createSubGroup();
        uint256 gIdAfter3 = tandaPay.getCurrentSubGroupId();
        assertEq(gIdBefore3 + 1, gIdAfter3);
        TandaPay.SubGroupInfo memory sInfo3 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        vm.expectRevert(abi.encodeWithSelector(TandaPay.DFNotMet.selector));
        tandaPay.initiatDefaultStateAndSetCoverage(10e18);
    }

    function testIfRevertIfSubGroupIsLessThan3WhileInitiatingDefaultState()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        vm.expectRevert(abi.encodeWithSelector(TandaPay.DFNotMet.selector));
        tandaPay.initiatDefaultStateAndSetCoverage(10e18);
    }

    function testIfRevertIfAnyOfTheSubGroupHasLessThan4memberWhileInitiatingTheDefaultState()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdBefore1 = tandaPay.getCurrentSubGroupId();
        vm.expectEmit();
        emit TandaPayEvents.SubGroupCreated(gIdBefore1 + 1);
        tandaPay.createSubGroup();
        uint256 gIdAfter1 = tandaPay.getCurrentSubGroupId();
        assertEq(gIdBefore1 + 1, gIdAfter1);
        TandaPay.SubGroupInfo memory sInfo1 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        uint256 gIdBefore2 = tandaPay.getCurrentSubGroupId();
        vm.expectEmit();
        emit TandaPayEvents.SubGroupCreated(gIdBefore2 + 1);
        tandaPay.createSubGroup();
        uint256 gIdAfter2 = tandaPay.getCurrentSubGroupId();
        assertEq(gIdBefore2 + 1, gIdAfter2);
        TandaPay.SubGroupInfo memory sInfo2 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);

        uint256 gIdBefore3 = tandaPay.getCurrentSubGroupId();
        vm.expectEmit();
        emit TandaPayEvents.SubGroupCreated(gIdBefore3 + 1);
        tandaPay.createSubGroup();
        uint256 gIdAfter3 = tandaPay.getCurrentSubGroupId();
        assertEq(gIdBefore3 + 1, gIdAfter3);
        TandaPay.SubGroupInfo memory sInfo3 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);

        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.SGMNotFullfilled.selector)
        );
        tandaPay.initiatDefaultStateAndSetCoverage(100e18);
    }
    function testIfSecretaryCanInitiateTheDefaultState() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);

        uint256 coverage = 10e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
    }

    function testIfRevertIfTheWalletApprovingTheSubGroupAssignmentIsNotTheMember()
        public
    {
        uint256 mIdBefore1 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member1, mIdBefore1 + 1);
        tandaPay.addToCommunity(member1);
        uint256 mIdAfter1 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore1 + 1, mIdAfter1);
        TandaPay.DemoMemberInfo memory mInfo1 = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo1.associatedGroupId, 0);

        assertEq(mInfo1.member, member1);
        assertEq(mInfo1.memberId, mIdAfter1);
        assertEq(
            uint8(mInfo1.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo1.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore2 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member2, mIdBefore2 + 1);
        tandaPay.addToCommunity(member2);
        uint256 mIdAfter2 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore2 + 1, mIdAfter2);
        TandaPay.DemoMemberInfo memory mInfo2 = tandaPay.getMemberToMemberInfo(
            member2,
            0
        );
        assertEq(mInfo2.associatedGroupId, 0);

        assertEq(mInfo2.member, member2);
        assertEq(mInfo2.memberId, mIdAfter2);
        assertEq(
            uint8(mInfo2.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo2.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 gIdBefore1 = tandaPay.getCurrentSubGroupId();
        vm.expectEmit();
        emit TandaPayEvents.SubGroupCreated(gIdBefore1 + 1);
        tandaPay.createSubGroup();
        uint256 gIdAfter1 = tandaPay.getCurrentSubGroupId();
        assertEq(gIdBefore1 + 1, gIdAfter1);
        TandaPay.SubGroupInfo memory sInfo1 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member1, gIdAfter1, false);
        tandaPay.assignToSubGroup(member1, gIdAfter1, false);
        mInfo1 = tandaPay.getMemberToMemberInfo(member1, 0);
        assertEq(mInfo1.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn1;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member1) {
                isIn1 = true;
            }
        }
        assertTrue(isIn1);
        assertEq(sInfo1.members.length, 1);
        assertTrue(!sInfo1.isValid);

        vm.startPrank(member2);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotAssignedYet.selector)
        );
        tandaPay.approveSubGroupAssignment(true);
        vm.stopPrank();
    }

    function testIfMemberCanApproveSubGroupAssignment() public {
        uint256 mIdBefore = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member1, mIdBefore + 1);
        tandaPay.addToCommunity(member1);
        uint256 mIdAfter = tandaPay.getCurrentMemberId();
        assertEq(mIdAfter, mIdBefore + 1);
        tandaPay.createSubGroup();
        uint256 gId = tandaPay.getCurrentSubGroupId();
        assertEq(gId, uint256(1));
        tandaPay.assignToSubGroup(member1, gId, false);
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo.associatedGroupId, gId);
        assertEq(mInfo.member, member1);
        TandaPay.AssignmentStatus AStatus1Before = mInfo.assignment;
        TandaPay.AssignmentStatus AStatus2Before = TandaPay
            .AssignmentStatus
            .AssignedToGroup;
        assertEq(uint8(AStatus1Before), uint8(AStatus2Before));
        vm.startPrank(member1);
        tandaPay.approveSubGroupAssignment(true);
        vm.stopPrank();

        TandaPay.DemoMemberInfo memory mInfo2 = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo2.associatedGroupId, gId);
        assertEq(mInfo2.member, member1);
        TandaPay.AssignmentStatus AStatus1After = mInfo2.assignment;
        TandaPay.AssignmentStatus AStatus2After = TandaPay
            .AssignmentStatus
            .AssignmentSuccessfull;
        assertEq(uint8(AStatus1After), uint8(AStatus2After));
    }

    function testIfRevertIfMemberIsNotReorgingWhileGroupMemberApprovingNewMember()
        public
    {
        uint256 mIdBefore = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member1, mIdBefore + 1);
        tandaPay.addToCommunity(member1);
        uint256 mIdAfter = tandaPay.getCurrentMemberId();
        assertEq(mIdAfter, mIdBefore + 1);
        tandaPay.createSubGroup();
        uint256 gId = tandaPay.getCurrentSubGroupId();
        assertEq(gId, uint256(1));
        tandaPay.assignToSubGroup(member1, gId, false);
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo.associatedGroupId, gId);
        assertEq(mInfo.member, member1);
        TandaPay.AssignmentStatus AStatus1Before = mInfo.assignment;
        TandaPay.AssignmentStatus AStatus2Before = TandaPay
            .AssignmentStatus
            .AssignedToGroup;
        assertEq(uint8(AStatus1Before), uint8(AStatus2Before));
        vm.startPrank(member1);
        tandaPay.approveSubGroupAssignment(true);
        vm.stopPrank();

        TandaPay.DemoMemberInfo memory mInfo1 = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo1.associatedGroupId, gId);
        assertEq(mInfo1.member, member1);
        TandaPay.AssignmentStatus AStatus1After = mInfo1.assignment;
        TandaPay.AssignmentStatus AStatus2After = TandaPay
            .AssignmentStatus
            .AssignmentSuccessfull;
        assertEq(uint8(AStatus1After), uint8(AStatus2After));
        uint256 mIdBefore2 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member2, mIdBefore2 + 1);
        tandaPay.addToCommunity(member2);
        uint256 mIdAfter2 = tandaPay.getCurrentMemberId();
        assertEq(mIdAfter2, mIdBefore2 + 1);
        tandaPay.assignToSubGroup(member2, gId, false);
        TandaPay.DemoMemberInfo memory mInfo2 = tandaPay.getMemberToMemberInfo(
            member2,
            0
        );
        assertEq(mInfo2.associatedGroupId, gId);
        assertEq(mInfo2.member, member2);
        TandaPay.AssignmentStatus AStatus1Before2 = mInfo.assignment;
        TandaPay.AssignmentStatus AStatus2Before2 = TandaPay
            .AssignmentStatus
            .AssignedToGroup;
        assertEq(uint8(AStatus1Before2), uint8(AStatus2Before2));
        vm.startPrank(member2);
        tandaPay.approveSubGroupAssignment(true);
        vm.stopPrank();
        vm.startPrank(member1);
        vm.expectRevert(abi.encodePacked(TandaPay.NotReorged.selector));
        tandaPay.approveNewSubgroupMember(gId, mIdAfter2, true);
        vm.stopPrank();
    }

    function testIfRevertIfTheApproverIsNotAMemberWhileApprovingNewSubGroupMember()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);
        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);
        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        // uint256 currentCoverage = tandaPay.getTotalCoverage();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);
        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;
        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);
        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);
        TandaPay.PeriodInfo memory pInfo2 = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter2
        );
        assertEq(pInfo2.startedAt + 30 days, pInfo2.willEndAt);
        vm.startPrank(member1);
        tandaPay.exitSubGroup();
        TandaPay.DemoMemberInfo memory mInfo1 = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo1.associatedGroupId, 0);
        assertEq(
            uint8(mInfo1.status),
            uint8(TandaPayEvents.MemberStatus.PAID_INVALID)
        );
        vm.stopPrank();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member1, gIdAfter3, true);
        tandaPay.assignToSubGroup(member1, gIdAfter3, true);
        mInfo1 = tandaPay.getMemberToMemberInfo(member1, 0);
        assertEq(mInfo1.associatedGroupId, gIdAfter3);
        assertEq(
            uint8(mInfo1.status),
            uint8(TandaPayEvents.MemberStatus.REORGED)
        );
        TandaPay.SubGroupInfo memory sInfo3 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn1Again;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member1) {
                isIn1Again = true;
            }
        }
        assertTrue(isIn1Again);
        assertEq(sInfo3.members.length, 5);
        assertTrue(sInfo3.isValid);
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ApprovedGroupAssignment(
            member1,
            mInfo1.associatedGroupId,
            shouldJoin
        );
        tandaPay.approveSubGroupAssignment(shouldJoin);
        mInfo1 = tandaPay.getMemberToMemberInfo(member1, 0);
        assertEq(
            uint8(mInfo1.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.stopPrank();
        vm.startPrank(member13);
        uint256 nMemberId = tandaPay.getMemberToMemberId(member1);
        vm.expectRevert(abi.encodeWithSelector(TandaPay.NotIncluded.selector));
        tandaPay.approveNewSubgroupMember(gIdAfter3, nMemberId, true);
        vm.stopPrank();
    }

    function testIfExistingMemberCanApproveNewSubGroupMember() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);
        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);
        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);
        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;
        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);
        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);
        TandaPay.PeriodInfo memory pInfo2 = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter2
        );
        assertEq(pInfo2.startedAt + 30 days, pInfo2.willEndAt);
        vm.startPrank(member1);
        tandaPay.exitSubGroup();
        TandaPay.DemoMemberInfo memory mInfo1 = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo1.associatedGroupId, 0);
        assertEq(
            uint8(mInfo1.status),
            uint8(TandaPayEvents.MemberStatus.PAID_INVALID)
        );
        vm.stopPrank();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member1, gIdAfter3, true);
        tandaPay.assignToSubGroup(member1, gIdAfter3, true);
        mInfo1 = tandaPay.getMemberToMemberInfo(member1, 0);
        assertEq(mInfo1.associatedGroupId, gIdAfter3);
        assertEq(
            uint8(mInfo1.status),
            uint8(TandaPayEvents.MemberStatus.REORGED)
        );
        TandaPay.SubGroupInfo memory sInfo3 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn1Again;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member1) {
                isIn1Again = true;
            }
        }
        assertTrue(isIn1Again);
        assertEq(sInfo3.members.length, 5);
        assertTrue(sInfo3.isValid);
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ApprovedGroupAssignment(
            member1,
            mInfo1.associatedGroupId,
            shouldJoin
        );
        tandaPay.approveSubGroupAssignment(shouldJoin);
        mInfo1 = tandaPay.getMemberToMemberInfo(member1, 0);
        assertEq(
            uint8(mInfo1.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.stopPrank();
        vm.startPrank(member12);
        uint256 nMemberId = tandaPay.getMemberToMemberId(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ApproveNewGroupMember(
            member1,
            member12,
            mInfo1.associatedGroupId,
            true
        );
        tandaPay.approveNewSubgroupMember(gIdAfter3, nMemberId, true);
        mInfo1 = tandaPay.getMemberToMemberInfo(member1, 0);
        assertEq(
            uint8(mInfo1.assignment),
            uint8(TandaPay.AssignmentStatus.AssignmentSuccessfull)
        );
        vm.stopPrank();
    }

    function testIfRevertIfCallerIsNotSubGroupMemberWhileExitingSubGroup()
        public
    {
        uint256 mIdBefore = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member1, mIdBefore + 1);
        tandaPay.addToCommunity(member1);
        uint256 mIdAfter = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore + 1, mIdAfter);
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo.associatedGroupId, 0);
        assertEq(mInfo.member, member1);
        assertEq(mInfo.memberId, mIdAfter);
        assertEq(
            uint8(mInfo.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotAssignedYet.selector)
        );
        tandaPay.exitSubGroup();
        vm.stopPrank();
    }

    function testIfSubGroupMemberCanExitSubGroup() public {
        uint256 mIdBefore = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member1, mIdBefore + 1);
        tandaPay.addToCommunity(member1);
        uint256 mIdAfter = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore + 1, mIdAfter);
        TandaPay.DemoMemberInfo memory mInfo = tandaPay.getMemberToMemberInfo(
            member1,
            0
        );
        assertEq(mInfo.associatedGroupId, 0);
        assertEq(mInfo.member, member1);
        assertEq(mInfo.memberId, mIdAfter);
        assertEq(
            uint8(mInfo.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 gIdBefore = tandaPay.getCurrentSubGroupId();
        vm.expectEmit();
        emit TandaPayEvents.SubGroupCreated(gIdBefore + 1);
        tandaPay.createSubGroup();
        uint256 gIdAfter = tandaPay.getCurrentSubGroupId();
        assertEq(gIdBefore + 1, gIdAfter);
        TandaPay.SubGroupInfo memory sInfo = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter);
        assertEq(sInfo.id, gIdAfter);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member1, gIdAfter, false);
        tandaPay.assignToSubGroup(member1, gIdAfter, false);
        mInfo = tandaPay.getMemberToMemberInfo(member1, 0);
        assertEq(mInfo.associatedGroupId, gIdAfter);
        sInfo = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter);
        assertEq(sInfo.id, gIdAfter);
        bool isIn;
        for (uint256 i = 0; i < sInfo.members.length; i++) {
            if (sInfo.members[i] == member1) {
                isIn = true;
            }
        }
        assertTrue(isIn);
        assertEq(sInfo.members.length, 1);
        assertTrue(!sInfo.isValid);
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ExitedFromSubGroup(member1, gIdAfter);
        tandaPay.exitSubGroup();
        vm.stopPrank();
    }

    function testIfRevertSecretaryIsNotCallingWhiteListCalimFunction() public {
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Secretary.SecretaryUnauthorizedSecretary.selector,
                member1
            )
        );
        tandaPay.whitelistClaim(1);
        vm.stopPrank();
    }

    function testIfRevertIfNotInDefaultOrFracturedStateWhileCallingWhileListClaim()
        public
    {
        TandaPay.CommunityStates statesBefore = tandaPay.getCommunityState();
        uint256 demoCId = 1;
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInDefOrFra.selector)
        );
        tandaPay.whitelistClaim(demoCId);
        TandaPay.CommunityStates statesAfter = tandaPay.getCommunityState();
        assertEq(uint8(statesBefore), uint8(statesAfter));
    }

    function testIfRevertIfNotInWhiteListWindowWhileWhiteListingClaim() public {
        {
            addToCommunity(member1);
            addToCommunity(member2);
            addToCommunity(member3);
            addToCommunity(member4);
            addToCommunity(member5);
            addToCommunity(member6);
            addToCommunity(member7);
            addToCommunity(member8);
            addToCommunity(member9);
            addToCommunity(member10);
            addToCommunity(member11);
            addToCommunity(member12);
            uint256 sgId1 = createASubGroup();
            uint256 sgId2 = createASubGroup();
            uint256 sgId3 = createASubGroup();

            assignToSubGroup(member1, sgId1, 1);
            assignToSubGroup(member2, sgId1, 2);
            assignToSubGroup(member3, sgId1, 3);
            assignToSubGroup(member4, sgId1, 4);
            assignToSubGroup(member5, sgId2, 1);
            assignToSubGroup(member6, sgId2, 2);
            assignToSubGroup(member7, sgId2, 3);
            assignToSubGroup(member8, sgId2, 4);
            assignToSubGroup(member9, sgId3, 1);
            assignToSubGroup(member10, sgId3, 2);
            assignToSubGroup(member11, sgId3, 3);
            assignToSubGroup(member12, sgId3, 4);

            uint256 coverage = 12e18;
            vm.expectEmit(address(tandaPay));
            emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
            tandaPay.initiatDefaultStateAndSetCoverage(coverage);
            TandaPay.CommunityStates states = tandaPay.getCommunityState();
            assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
            uint256 currentCoverage = tandaPay.getTotalCoverage();
            assertEq(currentCoverage, coverage);
            uint256 currentMemberId = tandaPay.getCurrentMemberId();
            basePremium = tandaPay.getBasePremium();
            assertEq(basePremium, currentCoverage / currentMemberId);
            uint256 bPAmount = tandaPay.getBasePremium();
            uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
            joinToCommunity(member1, joinFee);
            joinToCommunity(member2, joinFee);
            joinToCommunity(member3, joinFee);
            joinToCommunity(member4, joinFee);
            joinToCommunity(member5, joinFee);
            joinToCommunity(member6, joinFee);
            joinToCommunity(member7, joinFee);
            joinToCommunity(member8, joinFee);
            joinToCommunity(member9, joinFee);
            joinToCommunity(member10, joinFee);
            joinToCommunity(member11, joinFee);
            joinToCommunity(member12, joinFee);

            uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
            // uint256 currentCoverage = tandaPay.getTotalCoverage();
            vm.expectEmit(address(tandaPay));
            emit TandaPayEvents.NextPeriodInitiated(
                currentPeriodIdBefore + 1,
                currentCoverage,
                basePremium
            );
            tandaPay.AdvanceToTheNextPeriod();
            uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
            assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
            TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
                currentPeriodIdAfter
            );
            assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
            skip(27 days);
            basePremium = tandaPay.getBasePremium();
            uint256 pFee = basePremium + ((basePremium * 20) / 100);
            bool shouldJoin = true;
            approveSubGroupAssignment(member1, shouldJoin);
            payPremium(member1, pFee, currentPeriodIdAfter, false);
            approveSubGroupAssignment(member2, shouldJoin);
            payPremium(member2, pFee, currentPeriodIdAfter, false);
            approveSubGroupAssignment(member3, shouldJoin);
            payPremium(member3, pFee, currentPeriodIdAfter, false);
            approveSubGroupAssignment(member4, shouldJoin);
            payPremium(member4, pFee, currentPeriodIdAfter, false);
            approveSubGroupAssignment(member5, shouldJoin);
            payPremium(member5, pFee, currentPeriodIdAfter, false);

            approveSubGroupAssignment(member6, shouldJoin);
            payPremium(member6, pFee, currentPeriodIdAfter, false);
            approveSubGroupAssignment(member7, shouldJoin);
            payPremium(member7, pFee, currentPeriodIdAfter, false);
            approveSubGroupAssignment(member8, shouldJoin);
            payPremium(member8, pFee, currentPeriodIdAfter, false);
            approveSubGroupAssignment(member9, shouldJoin);
            payPremium(member9, pFee, currentPeriodIdAfter, false);
            approveSubGroupAssignment(member10, shouldJoin);
            payPremium(member10, pFee, currentPeriodIdAfter, false);
            approveSubGroupAssignment(member11, shouldJoin);
            payPremium(member11, pFee, currentPeriodIdAfter, false);
            approveSubGroupAssignment(member12, shouldJoin);
            payPremium(member12, pFee, currentPeriodIdAfter, false);

            skip(3 days);
            uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
            vm.expectEmit(address(tandaPay));
            emit TandaPayEvents.NextPeriodInitiated(
                currentPeriodIdBefore2 + 1,
                currentCoverage,
                basePremium
            );
            tandaPay.AdvanceToTheNextPeriod();
            uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
            assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);
            uint256 cIdBefore = tandaPay.getCurrentClaimId();
            vm.startPrank(member1);
            vm.expectEmit(address(tandaPay));
            emit TandaPayEvents.ClaimSubmitted(member1, cIdBefore + 1);
            tandaPay.submitClaim();
            vm.stopPrank();
            uint256 cIdAfter = tandaPay.getCurrentClaimId();
            assertEq(cIdBefore + 1, cIdAfter);
            skip(16 days);
            vm.expectRevert(
                abi.encodeWithSelector(TandaPay.NotWhitelistWindow.selector)
            );
            tandaPay.whitelistClaim(cIdAfter);
        }
    }

    function testIfRevertInTheClaimIdIsInvalidWhileWhiteListingClaim() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);
        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        // uint256 currentCoverage = tandaPay.getTotalCoverage();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);
        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;
        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);

        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);

        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);
        uint256 cIdBefore = tandaPay.getCurrentClaimId();
        vm.expectRevert(abi.encodeWithSelector(TandaPay.InValidClaim.selector));
        tandaPay.whitelistClaim(1);
        uint256 cIdAfter = tandaPay.getCurrentClaimId();
        assertEq(cIdBefore, cIdAfter);
    }

    function testIfRevertIfClaimantIsNotValidMemberWhileWhiteListingClaim()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);
        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();

        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        // uint256 currentCoverage = tandaPay.getTotalCoverage();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);

        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;
        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);

        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);

        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);

        vm.startPrank(member1);
        uint256 cIdBefore = tandaPay.getCurrentClaimId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ClaimSubmitted(member1, cIdBefore + 1);
        tandaPay.submitClaim();
        uint256 cIdAfter = tandaPay.getCurrentClaimId();
        assertEq(cIdBefore + 1, cIdAfter);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ExitedFromSubGroup(member1, sgId1);
        tandaPay.exitSubGroup();
        vm.stopPrank();
        console.log(uint8(tandaPay.getMemberToMemberInfo(member1, 0).status));
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.ClaimantNotValidMember.selector)
        );
        tandaPay.whitelistClaim(cIdAfter);
    }

    function testIfSecretaryCanWhiteListclaim() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);
        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();

        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        // uint256 currentCoverage = tandaPay.getTotalCoverage();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);

        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;
        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);

        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);

        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);

        vm.startPrank(member1);
        uint256 cIdBefore = tandaPay.getCurrentClaimId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ClaimSubmitted(member1, cIdBefore + 1);
        tandaPay.submitClaim();
        uint256 cIdAfter = tandaPay.getCurrentClaimId();
        assertEq(cIdBefore + 1, cIdAfter);
        vm.stopPrank();

        TandaPay.ClaimInfo memory cInfo = tandaPay
            .getPeriodIdToClaimIdToClaimInfo(currentPeriodIdAfter2, cIdAfter);
        assertEq(cInfo.claimant, member1);
        assertFalse(cInfo.isWhitelistd);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ClaimWhiteListed(cIdAfter);
        tandaPay.whitelistClaim(cIdAfter);
        cInfo = tandaPay.getPeriodIdToClaimIdToClaimInfo(
            currentPeriodIdAfter2,
            cIdAfter
        );
        assertTrue(cInfo.isWhitelistd);
    }

    function testIfRevertIfMemberIsNotValidWhileDefecting() public {
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotValidMember.selector)
        );
        tandaPay.defects();
        vm.stopPrank();
    }

    function testIfRevertIfNotInDefectWindowWhileDefecting() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);
        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();

        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(15 days);
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotDefectWindow.selector)
        );
        tandaPay.defects();
        vm.stopPrank();
    }

    function testIfRevertIfNoClaimOccuredWhileDefecting() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);
        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);
        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);
        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();

        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        // uint256 currentCoverage = tandaPay.getTotalCoverage();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);

        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;
        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);

        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);

        vm.startPrank(member1);
        uint256 cIdBefore = tandaPay.getCurrentClaimId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ClaimSubmitted(member1, cIdBefore + 1);
        tandaPay.submitClaim();
        uint256 cIdAfter = tandaPay.getCurrentClaimId();
        assertEq(cIdBefore + 1, cIdAfter);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.ClaimNoOccured.selector)
        );
        tandaPay.defects();
        vm.stopPrank();
    }

    function testIfMemberCanSuccessfullyDefect() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);
        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();

        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();

        // uint256 currentCoverage = tandaPay.getTotalCoverage();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);

        skip(27 days);

        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;

        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);

        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);

        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        console.log(currentPeriodIdAfter2);
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);
        skip(4 days);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.RefundIssued();
        tandaPay.issueRefund(false);
        vm.startPrank(member1);
        uint256 cIdBefore = tandaPay.getCurrentClaimId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ClaimSubmitted(member1, cIdBefore + 1);
        tandaPay.submitClaim();
        uint256 cIdAfter = tandaPay.getCurrentClaimId();
        assertEq(cIdBefore + 1, cIdAfter);
        vm.stopPrank();

        TandaPay.ClaimInfo memory cInfo = tandaPay
            .getPeriodIdToClaimIdToClaimInfo(currentPeriodIdAfter2, cIdAfter);
        assertEq(cInfo.claimant, member1);
        assertFalse(cInfo.isWhitelistd);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ClaimWhiteListed(cIdAfter);
        tandaPay.whitelistClaim(cIdAfter);
        cInfo = tandaPay.getPeriodIdToClaimIdToClaimInfo(
            currentPeriodIdAfter,
            cIdAfter
        );
        cInfo = tandaPay.getPeriodIdToClaimIdToClaimInfo(
            currentPeriodIdAfter2,
            cIdAfter
        );
        assertTrue(cInfo.isWhitelistd);
        skip(23 days);
        payPremium(member1, pFee, currentPeriodIdAfter2, true);
        payPremium(member2, pFee, currentPeriodIdAfter2, true);
        payPremium(member3, pFee, currentPeriodIdAfter2, true);
        payPremium(member4, pFee, currentPeriodIdAfter2, true);
        payPremium(member5, pFee, currentPeriodIdAfter2, true);
        payPremium(member6, pFee, currentPeriodIdAfter2, true);
        payPremium(member7, pFee, currentPeriodIdAfter2, true);
        payPremium(member8, pFee, currentPeriodIdAfter2, true);
        payPremium(member9, pFee, currentPeriodIdAfter2, true);
        payPremium(member10, pFee, currentPeriodIdAfter2, true);
        payPremium(member11, pFee, currentPeriodIdAfter2, true);
        payPremium(member12, pFee, currentPeriodIdAfter2, true);
        skip(3 days);
        uint256 currentPeriodIdBefore3 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore3 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter3 = tandaPay.getPeriodId();
        console.log(currentPeriodIdAfter3);
        assertEq(currentPeriodIdBefore3 + 1, currentPeriodIdAfter3);

        vm.startPrank(member1);
        tandaPay.defects();
        vm.stopPrank();
    }

    function testIfRevertIfCommunityStatesIsInInitializationStatedWhilePayingPremium()
        public
    {
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInDefOrFra.selector)
        );
        tandaPay.payPremium(false);
        vm.stopPrank();
    }

    function testIfRevertIfCommnunityStateIsInCollapseStatedWhilePayingPremium()
        public
    {
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ManualCollapsedHappenend();
        tandaPay.manualCollapsBySecretary();
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.COLLAPSED));
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInDefOrFra.selector)
        );
        tandaPay.payPremium(false);
        vm.stopPrank();
    }

    function testIfRevertIfNotInPaymentWindowWhilePayingPremimum() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);
        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();

        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        vm.startPrank(member1);
        vm.expectRevert(abi.encodeWithSelector(TandaPay.NotPayWindow.selector));
        tandaPay.payPremium(false);
        vm.stopPrank();
    }

    function testIfRevertIfMemberIsNotValidWhilePayingPremimum() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);

        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);

        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();

        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);
        vm.startPrank(member13);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotValidMember.selector)
        );
        tandaPay.payPremium(false);
        vm.stopPrank();
    }

    function testIfRevertIfMembersSubGroupAssignmentIsNotSuccessfulWhilePayingPremium()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);
        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();

        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);

        vm.startPrank(member12);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInAssignmentSuccessfull.selector)
        );
        tandaPay.payPremium(false);
        vm.stopPrank();
    }

    function testIfRevertIfDefectedUserIsPayingPremium() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);
        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();

        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);

        skip(27 days);

        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;

        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);

        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);

        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        console.log(currentPeriodIdAfter2);
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);
        skip(4 days);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.RefundIssued();
        tandaPay.issueRefund(false);
        vm.startPrank(member1);
        uint256 cIdBefore = tandaPay.getCurrentClaimId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ClaimSubmitted(member1, cIdBefore + 1);
        tandaPay.submitClaim();
        uint256 cIdAfter = tandaPay.getCurrentClaimId();
        assertEq(cIdBefore + 1, cIdAfter);
        vm.stopPrank();

        TandaPay.ClaimInfo memory cInfo = tandaPay
            .getPeriodIdToClaimIdToClaimInfo(currentPeriodIdAfter2, cIdAfter);
        assertEq(cInfo.claimant, member1);
        assertFalse(cInfo.isWhitelistd);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ClaimWhiteListed(cIdAfter);
        tandaPay.whitelistClaim(cIdAfter);
        cInfo = tandaPay.getPeriodIdToClaimIdToClaimInfo(
            currentPeriodIdAfter,
            cIdAfter
        );

        cInfo = tandaPay.getPeriodIdToClaimIdToClaimInfo(
            currentPeriodIdAfter2,
            cIdAfter
        );
        assertTrue(cInfo.isWhitelistd);

        skip(23 days);
        payPremium(member1, pFee, currentPeriodIdAfter2, true);
        payPremium(member2, pFee, currentPeriodIdAfter2, true);
        payPremium(member3, pFee, currentPeriodIdAfter2, true);
        payPremium(member4, pFee, currentPeriodIdAfter2, true);
        payPremium(member5, pFee, currentPeriodIdAfter2, true);
        payPremium(member6, pFee, currentPeriodIdAfter2, true);
        payPremium(member7, pFee, currentPeriodIdAfter2, true);
        payPremium(member8, pFee, currentPeriodIdAfter2, true);
        payPremium(member9, pFee, currentPeriodIdAfter2, true);
        payPremium(member10, pFee, currentPeriodIdAfter2, true);
        payPremium(member11, pFee, currentPeriodIdAfter2, true);
        payPremium(member12, pFee, currentPeriodIdAfter2, true);
        skip(3 days);
        uint256 currentPeriodIdBefore3 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore3 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter3 = tandaPay.getPeriodId();
        console.log(currentPeriodIdAfter3);
        assertEq(currentPeriodIdBefore3 + 1, currentPeriodIdAfter3);
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.MemberDefected(member1, currentPeriodIdAfter3);
        tandaPay.defects();
        skip(27 days);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.OutOfTheCommunity.selector)
        );
        tandaPay.payPremium(false);
        vm.stopPrank();
    }

    function testIfRevertIfAlreadyQuitedUserIsPayingPremium() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);
        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();

        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);

        skip(27 days);

        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;

        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);

        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);

        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        console.log(currentPeriodIdAfter2);
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);
        skip(4 days);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.RefundIssued();
        tandaPay.issueRefund(false);

        vm.startPrank(member1);
        uint256 cIdBefore = tandaPay.getCurrentClaimId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ClaimSubmitted(member1, cIdBefore + 1);
        tandaPay.submitClaim();
        uint256 cIdAfter = tandaPay.getCurrentClaimId();
        assertEq(cIdBefore + 1, cIdAfter);
        vm.stopPrank();

        TandaPay.ClaimInfo memory cInfo = tandaPay
            .getPeriodIdToClaimIdToClaimInfo(currentPeriodIdAfter2, cIdAfter);
        assertEq(cInfo.claimant, member1);
        assertFalse(cInfo.isWhitelistd);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ClaimWhiteListed(cIdAfter);
        tandaPay.whitelistClaim(cIdAfter);
        cInfo = tandaPay.getPeriodIdToClaimIdToClaimInfo(
            currentPeriodIdAfter,
            cIdAfter
        );
        cInfo = tandaPay.getPeriodIdToClaimIdToClaimInfo(
            currentPeriodIdAfter2,
            cIdAfter
        );
        assertTrue(cInfo.isWhitelistd);
        skip(23 days);
        payPremium(member2, pFee, currentPeriodIdAfter2, true);
        payPremium(member3, pFee, currentPeriodIdAfter2, true);
        payPremium(member4, pFee, currentPeriodIdAfter2, true);
        payPremium(member5, pFee, currentPeriodIdAfter2, true);
        payPremium(member6, pFee, currentPeriodIdAfter2, true);
        payPremium(member7, pFee, currentPeriodIdAfter2, true);
        payPremium(member8, pFee, currentPeriodIdAfter2, true);
        payPremium(member9, pFee, currentPeriodIdAfter2, true);
        payPremium(member10, pFee, currentPeriodIdAfter2, true);
        payPremium(member11, pFee, currentPeriodIdAfter2, true);
        payPremium(member12, pFee, currentPeriodIdAfter2, true);
        skip(3 days);
        uint256 currentPeriodIdBefore3 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.MemberStatusUpdated(
            member1,
            TandaPayEvents.MemberStatus.UNPAID_INVALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member2,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member3,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member4,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member5,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member6,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member7,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member8,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member9,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member10,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member11,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member12,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore3 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter3 = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore3 + 1, currentPeriodIdAfter3);
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.MemberDefected(member1, currentPeriodIdAfter3);
        tandaPay.defects();
        skip(27 days);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.OutOfTheCommunity.selector)
        );
        tandaPay.payPremium(false);
        vm.stopPrank();
    }

    function testIfUserCanSuccessfullyPayPremium() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);
        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();

        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);

        skip(27 days);

        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;

        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
    }

    function testIfRevertIfCallerIsNotTheSecretaryWhileUpdatingCoverageAmount()
        public
    {
        vm.startPrank(member1);
        uint256 demoCoverage = 10e18;
        vm.expectRevert(
            abi.encodeWithSelector(
                Secretary.SecretaryUnauthorizedSecretary.selector,
                member1
            )
        );
        tandaPay.updateCoverageAmount(demoCoverage);
        vm.stopPrank();
    }

    function testIfRevertIfNotInTheInitilizationOrDefaultStateWhileUpdatingCoverageAmount()
        public
    {
        uint256 demoCoverage = 10e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ManualCollapsedHappenend();
        tandaPay.manualCollapsBySecretary();
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.COLLAPSED));
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInIniOrDef.selector)
        );
        tandaPay.updateCoverageAmount(demoCoverage);
    }

    function testIfSecretaryCanSuccessfullyUpdateCoverageAmount() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 sgId1 = createASubGroup();
        uint256 sgId2 = createASubGroup();
        uint256 sgId3 = createASubGroup();

        assignToSubGroup(member1, sgId1, 1);
        assignToSubGroup(member2, sgId1, 2);
        assignToSubGroup(member3, sgId1, 3);
        assignToSubGroup(member4, sgId1, 4);
        assignToSubGroup(member5, sgId2, 1);
        assignToSubGroup(member6, sgId2, 2);
        assignToSubGroup(member7, sgId2, 3);
        assignToSubGroup(member8, sgId2, 4);
        assignToSubGroup(member9, sgId3, 1);
        assignToSubGroup(member10, sgId3, 2);
        assignToSubGroup(member11, sgId3, 3);
        assignToSubGroup(member12, sgId3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();

        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);

        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);

        skip(27 days);

        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;

        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);

        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);

        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        console.log(currentPeriodIdAfter2);
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);
        uint256 demoCoverage = 10e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.MemberStatusUpdated(
            member1,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member2,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member3,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member4,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member5,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member6,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member7,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member8,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member9,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member10,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member11,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member12,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.CoverageUpdated(demoCoverage, basePremium);
        tandaPay.updateCoverageAmount(demoCoverage);
    }

    function testIfRevertIfCallerIsNotSecretaryWhileCallingDefineSecretarySuccessor()
        public
    {
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Secretary.SecretaryUnauthorizedSecretary.selector,
                member1
            )
        );

        successors.push(member2);
        successors.push(member3);

        tandaPay.defineSecretarySuccessor(successors);
        vm.stopPrank();
    }

    function testIfRevertIfSuccessorIsLessThan2WhileMemberIs12To35WhileDefiningSecretary()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);
        addToCommunity(member13);
        addToCommunity(member14);
        successors.push(member13);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NeedMoreSuccessor.selector)
        );
        tandaPay.defineSecretarySuccessor(successors);
    }

    function testIfRevertIfSuccessorIsLessThan6WhileMemberIsMoreThan35WhileDefiningSecretary()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);
        addToCommunity(member13);
        addToCommunity(member14);
        addToCommunity(member15);
        addToCommunity(member16);
        addToCommunity(member17);
        addToCommunity(member18);
        addToCommunity(member19);
        addToCommunity(member20);
        addToCommunity(member21);
        addToCommunity(member22);
        addToCommunity(member23);
        addToCommunity(member24);
        addToCommunity(member25);
        addToCommunity(member26);
        addToCommunity(member27);
        addToCommunity(member28);
        addToCommunity(member29);
        addToCommunity(member30);
        addToCommunity(member31);
        addToCommunity(member32);
        addToCommunity(member33);
        addToCommunity(member34);
        addToCommunity(member35);
        addToCommunity(member36);
        successors.push(member1);
        successors.push(member2);
        successors.push(member3);
        successors.push(member4);
        successors.push(member5);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NeedMoreSuccessor.selector)
        );
        tandaPay.defineSecretarySuccessor(successors);
    }

    function testIfRevertIfMemberWhichIsBeingAddedToTheSuccessorsListIsNotAValidMemberOfTheCommunity()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        successors.push(member1);
        successors.push(member14);
        vm.expectRevert(abi.encodeWithSelector(TandaPay.NotIncluded.selector));
        tandaPay.defineSecretarySuccessor(successors);
    }

    function testIfSecretaryCanSuccessfullyDefineTwoSuccessorsWhileMemberIsMoreThan6()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        successors.push(member1);
        successors.push(member2);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory _successors = tandaPay.getSecretarySuccessors();
        assertEq(successors[0], _successors[0]);
        assertEq(successors[1], _successors[1]);
        assertEq(_successors[0], member1);
        assertEq(_successors[1], member2);
    }

    function testIfSecretaryCanSuccessfullyDefine6SuccessorsWhileMemberIsMoreThan35()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);
        addToCommunity(member13);
        addToCommunity(member14);
        addToCommunity(member15);
        addToCommunity(member16);
        addToCommunity(member17);
        addToCommunity(member18);
        addToCommunity(member19);
        addToCommunity(member20);
        addToCommunity(member21);
        addToCommunity(member22);
        addToCommunity(member23);
        addToCommunity(member24);
        addToCommunity(member25);
        addToCommunity(member26);
        addToCommunity(member27);
        addToCommunity(member28);
        addToCommunity(member29);
        addToCommunity(member30);
        addToCommunity(member31);
        addToCommunity(member32);
        addToCommunity(member33);
        addToCommunity(member34);
        addToCommunity(member35);
        addToCommunity(member36);

        successors.push(member1);
        successors.push(member2);
        successors.push(member3);
        successors.push(member4);
        successors.push(member5);
        successors.push(member6);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory _successors = tandaPay.getSecretarySuccessors();
        assertEq(successors[0], _successors[0]);
        assertEq(successors[1], _successors[1]);
        assertEq(successors[2], _successors[2]);
        assertEq(successors[3], _successors[3]);
        assertEq(successors[4], _successors[4]);
        assertEq(successors[5], _successors[5]);
        assertEq(_successors[0], member1);
        assertEq(_successors[1], member2);
        assertEq(_successors[2], member3);
        assertEq(_successors[3], member4);
        assertEq(_successors[4], member5);
        assertEq(_successors[5], member6);
    }

    function testIfSecretaryCanSuccessfullyDefineSecretarySuccessor() public {
        addToCommunity(member1);
        addToCommunity(member2);
        successors.push(member1);
        successors.push(member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory _successors = tandaPay.getSecretarySuccessors();
        assertEq(successors[0], _successors[0]);
        assertEq(successors[1], _successors[1]);
        assertEq(_successors[0], member1);
        assertEq(_successors[1], member2);
    }

    function testIfRevertIfSecretaryIsNotCallingHandoverSecretaryFunction()
        public
    {
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Secretary.SecretaryUnauthorizedSecretary.selector,
                member1
            )
        );
        tandaPay.handoverSecretary(address(0));
        vm.stopPrank();
    }

    function testIfRevertIfPrefferedSuccessorIsNotAValidMemberWhileHandingOverSecretary()
        public
    {
        vm.expectRevert(abi.encodeWithSelector(TandaPay.NotIncluded.selector));
        tandaPay.handoverSecretary(member1);
    }

    function testIfSecretaryCanSuccessfullyEnableSecretaryHandover() public {
        addToCommunity(member1);
        addToCommunity(member2);
        successors.push(member1);
        successors.push(member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory _successors = tandaPay.getSecretarySuccessors();
        assertEq(successors[0], _successors[0]);
        assertEq(successors[1], _successors[1]);
        assertEq(_successors[0], member1);
        assertEq(_successors[1], member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretaryHandOverEnabled(member1);
        tandaPay.handoverSecretary(member1);
        address upcomingSuccessor = tandaPay.getUpcomingSecretary();
        assertEq(upcomingSuccessor, member1);
        bool isHandoverEnabled = tandaPay.getIsHandingOver();
        assertEq(isHandoverEnabled, true);
    }

    function testIfRevertIfNotHandingOverWhileUpcomingSecretaryIsTryingToAcceptSecretary()
        public
    {
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotHandingOver.selector)
        );
        tandaPay.secretaryAcceptance();
    }

    function testIfRevertIfTheAcceptorIsNotIncludedInTheSecretarySuccessorsList()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        successors.push(member1);
        successors.push(member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory _successors = tandaPay.getSecretarySuccessors();
        assertEq(successors[0], _successors[0]);
        assertEq(successors[1], _successors[1]);
        assertEq(_successors[0], member1);
        assertEq(_successors[1], member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretaryHandOverEnabled(member1);
        tandaPay.handoverSecretary(member1);
        address upcomingSuccessor = tandaPay.getUpcomingSecretary();
        assertEq(upcomingSuccessor, member1);
        bool isHandoverEnabled = tandaPay.getIsHandingOver();
        assertEq(isHandoverEnabled, true);
        vm.startPrank(member3);
        vm.expectRevert(abi.encodeWithSelector(TandaPay.NotIncluded.selector));
        tandaPay.secretaryAcceptance();
        vm.stopPrank();
    }

    function testIfRevertIf24HoursNotPassedWhileTheFirstMemberInTheSuccessorListIsTryingToAcceptSecretaryWhilePreferredSuccessorIsNotDefinedOrDidNotAcceptedYet()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member4);
        successors.push(member1);
        successors.push(member2);
        successors.push(member4);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory _successors = tandaPay.getSecretarySuccessors();
        assertEq(successors[0], _successors[0]);
        assertEq(successors[1], _successors[1]);
        assertEq(_successors[0], member1);
        assertEq(_successors[1], member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretaryHandOverEnabled(member1);
        tandaPay.handoverSecretary(member1);
        address upcomingSuccessor = tandaPay.getUpcomingSecretary();
        assertEq(upcomingSuccessor, member1);
        bool isHandoverEnabled = tandaPay.getIsHandingOver();
        assertEq(isHandoverEnabled, true);
        vm.startPrank(member4);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.TimeNotPassed.selector)
        );
        tandaPay.secretaryAcceptance();
        vm.stopPrank();
    }

    function testIfRevertIfTheMemberAcceptingIsNotTheFirstInTheSuccessorListWhileNoPrefferedSuccessorIsDefined()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member4);
        successors.push(member1);
        successors.push(member2);
        successors.push(member4);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory _successors = tandaPay.getSecretarySuccessors();
        assertEq(successors[0], _successors[0]);
        assertEq(successors[1], _successors[1]);
        assertEq(_successors[0], member1);
        assertEq(_successors[1], member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretaryHandOverEnabled(member1);
        tandaPay.handoverSecretary(member1);
        address upcomingSuccessor = tandaPay.getUpcomingSecretary();
        assertEq(upcomingSuccessor, member1);
        bool isHandoverEnabled = tandaPay.getIsHandingOver();
        assertEq(isHandoverEnabled, true);
        skip(2 days);
        vm.startPrank(member4);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotFirstSuccessor.selector)
        );
        tandaPay.secretaryAcceptance();
        vm.stopPrank();
    }

    function testIfPreferredSuccessorCanSuccessfullyAcceptTheSecretary()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        successors.push(member1);
        successors.push(member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory _successors = tandaPay.getSecretarySuccessors();
        assertEq(successors[0], _successors[0]);
        assertEq(successors[1], _successors[1]);
        assertEq(_successors[0], member1);
        assertEq(_successors[1], member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretaryHandOverEnabled(member1);
        tandaPay.handoverSecretary(member1);
        address upcomingSuccessor = tandaPay.getUpcomingSecretary();
        assertEq(upcomingSuccessor, member1);
        bool isHandoverEnabled = tandaPay.getIsHandingOver();
        assertEq(isHandoverEnabled, true);
        vm.startPrank(member1);
        _successors = tandaPay.getSecretarySuccessors();
        uint256 successorsLengthBefore = _successors.length;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretaryAccepted(member1);
        tandaPay.secretaryAcceptance();
        vm.stopPrank();
        address currentSecretary = tandaPay.secretary();
        assertEq(currentSecretary, member1);
        _successors = tandaPay.getSecretarySuccessors();
        uint256 successorsLengthAfter = _successors.length;
        assertEq(successorsLengthAfter, successorsLengthBefore - 1);
        bool isIn;
        for (uint256 i = 0; i < successorsLengthAfter; i++) {
            isIn = _successors[i] == member1;
        }
        assertFalse(isIn);
    }

    function testIfMemberFromTheSuccessorListCanAcceptTheSecretaryIfPrefferedSuccessorIsNotDefined()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        successors.push(member1);
        successors.push(member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory _successors = tandaPay.getSecretarySuccessors();
        assertEq(successors[0], _successors[0]);
        assertEq(successors[1], _successors[1]);
        assertEq(_successors[0], member1);
        assertEq(_successors[1], member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretaryHandOverEnabled(address(0));
        tandaPay.handoverSecretary(address(0));
        address upcomingSuccessor = tandaPay.getUpcomingSecretary();
        assertEq(upcomingSuccessor, address(0));
        bool isHandoverEnabled = tandaPay.getIsHandingOver();
        assertEq(isHandoverEnabled, true);
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretaryAccepted(member1);
        tandaPay.secretaryAcceptance();
        vm.stopPrank();
        address currentSecretary = tandaPay.secretary();
        assertEq(currentSecretary, member1);
        uint256 successorsLengthBefore2 = _successors.length;
        _successors = tandaPay.getSecretarySuccessors();
        uint256 successorsLengthAfter2 = _successors.length;
        assertEq(successorsLengthAfter2, successorsLengthBefore2 - 1);
        bool isIn;
        for (uint256 i = 0; i < successorsLengthAfter2; i++) {
            isIn = _successors[i] == member1;
        }
        assertFalse(isIn);
    }

    function testIfRevertIfTheWalletTryingToCallTheFunctionIsNotAMemberOfTheCommunityWhileEmergencyHandingOverSecretary()
        public
    {
        vm.startPrank(member1);
        vm.expectRevert(abi.encodeWithSelector(TandaPay.NotIncluded.selector));
        tandaPay.emergencyHandOverSecretary(member2);
        vm.stopPrank();
    }

    function testIfRevertIfTheWalletTryingToCallTheFunctionIsNotAValidMemberWhileEmergencyHandingOverMember()
        public
    {
        addToCommunity(member1);
        vm.startPrank(member1);
        vm.expectRevert(abi.encodeWithSelector(TandaPay.NotIncluded.selector));
        tandaPay.emergencyHandOverSecretary(member2);
        vm.stopPrank();
    }

    function testIfRevertIfExpectedSecretaryIsNotInTheSuccessorListWhileEmergencyHandingOverSecretary()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);
        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);
        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        // uint256 currentCoverage = tandaPay.getTotalCoverage();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);
        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;

        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);
        skip(3 days);

        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInSuccessorList.selector)
        );
        tandaPay.emergencyHandOverSecretary(member2);
        vm.stopPrank();
    }

    function testIfRevertIfMemberIsTryingToSetUpEmergencyHandoverMoreThanOnceInAPeriod()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();

        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);

        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);
        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );

        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);
        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;
        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);
        skip(3 days);
        successors.push(member1);
        successors.push(member2);
        successors.push(member3);
        successors.push(member4);
        successors.push(member5);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory secretarySuccessorList = tandaPay
            .getSecretarySuccessors();
        assertEq(secretarySuccessorList[0], successors[0]);
        assertEq(secretarySuccessorList[1], successors[1]);
        assertEq(secretarySuccessorList[2], successors[2]);
        assertEq(secretarySuccessorList[3], successors[3]);
        uint256 handoverStartTimeBefore = tandaPay
            .getEmergencyHandoverStartedAt();
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member3);
        tandaPay.emergencyHandOverSecretary(member3);
        vm.stopPrank();
        uint256 handoverStartTimeAfter = tandaPay
            .getEmergencyHandoverStartedAt();
        assertTrue(handoverStartTimeAfter > handoverStartTimeBefore);
        uint256 handoverStartPeriod = tandaPay
            .getEmergencyHandOverStartedPeriod();
        assertEq(handoverStartPeriod, currentPeriodIdAfter);
        address[2] memory emembergencySecretaries = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries[0], member3);
        assertEq(emembergencySecretaries[1], address(0));

        vm.startPrank(member4);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member2);
        tandaPay.emergencyHandOverSecretary(member2);
        vm.stopPrank();
        address[2] memory emembergencySecretaries2 = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries2[0], address(0));
        assertEq(emembergencySecretaries2[1], address(0));
        address upcomingSecretary = tandaPay.getUpcomingSecretary();
        assertEq(upcomingSecretary, address(0));
        vm.startPrank(member3);
        vm.expectRevert(abi.encodeWithSelector(TandaPay.SamePeriod.selector));
        tandaPay.emergencyHandOverSecretary(member2);
        vm.stopPrank();
    }

    function testIfRevertIfSecondEmergencySecretaryIsBeingSetAfter24HoursInTheSamePeriod()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );

        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);
        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;
        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);
        skip(3 days);
        successors.push(member1);
        successors.push(member2);
        successors.push(member3);
        successors.push(member4);
        successors.push(member5);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory secretarySuccessorList = tandaPay
            .getSecretarySuccessors();

        assertEq(secretarySuccessorList[0], successors[0]);
        assertEq(secretarySuccessorList[1], successors[1]);
        assertEq(secretarySuccessorList[2], successors[2]);
        assertEq(secretarySuccessorList[3], successors[3]);
        uint256 handoverStartTimeBefore = tandaPay
            .getEmergencyHandoverStartedAt();
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member3);
        tandaPay.emergencyHandOverSecretary(member3);
        vm.stopPrank();
        uint256 handoverStartTimeAfter = tandaPay
            .getEmergencyHandoverStartedAt();
        assertTrue(handoverStartTimeAfter > handoverStartTimeBefore);
        uint256 handoverStartPeriod = tandaPay
            .getEmergencyHandOverStartedPeriod();
        assertEq(handoverStartPeriod, currentPeriodIdAfter);
        address[2] memory emembergencySecretaries = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries[0], member3);
        assertEq(emembergencySecretaries[1], address(0));

        vm.startPrank(member4);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member2);
        tandaPay.emergencyHandOverSecretary(member2);
        vm.stopPrank();
        address[2] memory emembergencySecretaries2 = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries2[0], address(0));
        assertEq(emembergencySecretaries2[1], address(0));
        address upcomingSecretary = tandaPay.getUpcomingSecretary();
        assertEq(upcomingSecretary, address(0));
        vm.startPrank(member3);
        skip(2 days);
        vm.expectRevert(abi.encodeWithSelector(TandaPay.SamePeriod.selector));
        tandaPay.emergencyHandOverSecretary(member2);
        vm.stopPrank();
    }

    function testIfValidMemberCanSuccessfullySetUpTheFirstEmergencySecretaryByCallingEmergencyHandOverSecretaryFunction()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);
        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);
        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);

        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);
        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;

        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);
        skip(3 days);
        successors.push(member1);
        successors.push(member2);
        successors.push(member3);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory secretarySuccessorList = tandaPay
            .getSecretarySuccessors();
        assertEq(secretarySuccessorList[0], successors[0]);
        assertEq(secretarySuccessorList[1], successors[1]);
        assertEq(secretarySuccessorList[2], successors[2]);
        uint256 handoverStartTimeBefore = tandaPay
            .getEmergencyHandoverStartedAt();
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member3);
        tandaPay.emergencyHandOverSecretary(member3);
        vm.stopPrank();
        uint256 handoverStartTimeAfter = tandaPay
            .getEmergencyHandoverStartedAt();
        assertTrue(handoverStartTimeAfter > handoverStartTimeBefore);
        uint256 handoverStartPeriod = tandaPay
            .getEmergencyHandOverStartedPeriod();
        assertEq(handoverStartPeriod, currentPeriodIdAfter);
        address[2] memory emembergencySecretaries = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries[0], member3);
        assertEq(emembergencySecretaries[1], address(0));
    }

    function testIfValidMemberWhoIsInLineOfSuccessorListCanSuccessfullySetUpTheSecondEmergencySecretaryByCallingEmergencyHandOverSecretaryFunction()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);
        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);
        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);

        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);
        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;
        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);
        skip(3 days);
        successors.push(member1);
        successors.push(member2);
        successors.push(member3);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory secretarySuccessorList = tandaPay
            .getSecretarySuccessors();
        assertEq(secretarySuccessorList[0], successors[0]);
        assertEq(secretarySuccessorList[1], successors[1]);
        assertEq(secretarySuccessorList[2], successors[2]);
        uint256 handoverStartTimeBefore = tandaPay
            .getEmergencyHandoverStartedAt();
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member3);
        tandaPay.emergencyHandOverSecretary(member3);
        vm.stopPrank();
        uint256 handoverStartTimeAfter = tandaPay
            .getEmergencyHandoverStartedAt();
        assertTrue(handoverStartTimeAfter > handoverStartTimeBefore);
        uint256 handoverStartPeriod = tandaPay
            .getEmergencyHandOverStartedPeriod();
        assertEq(handoverStartPeriod, currentPeriodIdAfter);
        address[2] memory emembergencySecretaries = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries[0], member3);
        assertEq(emembergencySecretaries[1], address(0));
        vm.startPrank(member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member3);
        tandaPay.emergencyHandOverSecretary(member3);
        vm.stopPrank();
        address[2] memory emembergencySecretaries2 = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries2[0], address(0));
        assertEq(emembergencySecretaries2[1], address(0));
        address currentSecretary = tandaPay.secretary();
        assertEq(currentSecretary, member3);
    }

    function testIfResetTheHandoverTimeAndPeriodIdIfRetryingTheHandoverAsInPreviousPeriodSecondEmergencySecretaryWasNotbeingSetAfter24HoursOfTheFirstOneWhileEmergencyHandingOverSecretary()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);
        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);
        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);
        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;
        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);
        skip(3 days);
        successors.push(member1);
        successors.push(member2);
        successors.push(member3);
        successors.push(member4);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory secretarySuccessorList = tandaPay
            .getSecretarySuccessors();
        assertEq(secretarySuccessorList[0], successors[0]);
        assertEq(secretarySuccessorList[1], successors[1]);
        assertEq(secretarySuccessorList[2], successors[2]);
        assertEq(secretarySuccessorList[3], successors[3]);
        uint256 handoverStartTimeBefore = tandaPay
            .getEmergencyHandoverStartedAt();
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member3);
        tandaPay.emergencyHandOverSecretary(member3);
        vm.stopPrank();
        uint256 handoverStartTimeAfter = tandaPay
            .getEmergencyHandoverStartedAt();
        assertTrue(handoverStartTimeAfter > handoverStartTimeBefore);
        uint256 handoverStartPeriod = tandaPay
            .getEmergencyHandOverStartedPeriod();
        assertEq(handoverStartPeriod, currentPeriodIdAfter);
        address[2] memory emembergencySecretaries = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries[0], member3);
        assertEq(emembergencySecretaries[1], address(0));
        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        console.log(currentPeriodIdAfter2);
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member4);
        tandaPay.emergencyHandOverSecretary(member4);
        vm.stopPrank();
        uint256 handoverStartTimeAfter2 = tandaPay
            .getEmergencyHandoverStartedAt();
        assertTrue(handoverStartTimeAfter2 > handoverStartTimeBefore);
        uint256 handoverStartPeriod2 = tandaPay
            .getEmergencyHandOverStartedPeriod();
        assertEq(handoverStartPeriod2, currentPeriodIdAfter2);
        address[2] memory emembergencySecretaries2 = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries2[0], member4);
        assertEq(emembergencySecretaries2[1], address(0));
    }

    function testIfEmergencySecretaryHandingoverIsResetIfBothTheWalletInSuccessorListPassDifferentSuccessorToBeSecretary()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);
        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );

        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);
        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);
        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;
        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);
        skip(3 days);
        successors.push(member1);
        successors.push(member2);
        successors.push(member3);
        successors.push(member4);
        successors.push(member5);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory secretarySuccessorList = tandaPay
            .getSecretarySuccessors();
        assertEq(secretarySuccessorList[0], successors[0]);
        assertEq(secretarySuccessorList[1], successors[1]);
        assertEq(secretarySuccessorList[2], successors[2]);
        assertEq(secretarySuccessorList[3], successors[3]);
        uint256 handoverStartTimeBefore = tandaPay
            .getEmergencyHandoverStartedAt();
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member3);
        tandaPay.emergencyHandOverSecretary(member3);
        vm.stopPrank();
        uint256 handoverStartTimeAfter = tandaPay
            .getEmergencyHandoverStartedAt();
        assertTrue(handoverStartTimeAfter > handoverStartTimeBefore);
        uint256 handoverStartPeriod = tandaPay
            .getEmergencyHandOverStartedPeriod();
        assertEq(handoverStartPeriod, currentPeriodIdAfter);
        address[2] memory emembergencySecretaries = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries[0], member3);
        assertEq(emembergencySecretaries[1], address(0));

        vm.startPrank(member4);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member2);
        tandaPay.emergencyHandOverSecretary(member2);
        vm.stopPrank();
        address[2] memory emembergencySecretaries2 = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries2[0], address(0));
        assertEq(emembergencySecretaries2[1], address(0));
        address upcomingSecretary = tandaPay.getUpcomingSecretary();
        assertEq(upcomingSecretary, address(0));
    }

    function testIfSuccessorsCanSuccessfullySetUpNewEmergencySecretaryAndNewSecretaryCanAcceptItAndCanCallOnlySecretaryFunctions()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);
        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);
        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);

        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(27 days);
        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;
        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);
        skip(3 days);
        successors.push(member1);
        successors.push(member2);
        successors.push(member3);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SecretarySuccessorsDefined(successors);
        tandaPay.defineSecretarySuccessor(successors);
        address[] memory secretarySuccessorList = tandaPay
            .getSecretarySuccessors();

        assertEq(secretarySuccessorList[0], successors[0]);
        assertEq(secretarySuccessorList[1], successors[1]);
        assertEq(secretarySuccessorList[2], successors[2]);
        uint256 handoverStartTimeBefore = tandaPay
            .getEmergencyHandoverStartedAt();
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member3);
        tandaPay.emergencyHandOverSecretary(member3);
        vm.stopPrank();
        uint256 handoverStartTimeAfter = tandaPay
            .getEmergencyHandoverStartedAt();
        assertTrue(handoverStartTimeAfter > handoverStartTimeBefore);
        uint256 handoverStartPeriod = tandaPay
            .getEmergencyHandOverStartedPeriod();
        assertEq(handoverStartPeriod, currentPeriodIdAfter);
        address[2] memory emembergencySecretaries = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries[0], member3);
        assertEq(emembergencySecretaries[1], address(0));
        vm.startPrank(member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.EmergencyhandOverSecretary(member3);
        tandaPay.emergencyHandOverSecretary(member3);

        vm.stopPrank();
        address[2] memory emembergencySecretaries2 = tandaPay
            .getEmergencySecretaries();
        assertEq(emembergencySecretaries2[0], address(0));
        assertEq(emembergencySecretaries2[1], address(0));
        address upcomingSecretary = tandaPay.getUpcomingSecretary();
        assertEq(upcomingSecretary, address(0));
        address currentSecretary = tandaPay.secretary();
        assertEq(currentSecretary, member3);
        vm.startPrank(member3);
        addToCommunity(member13);
        vm.stopPrank();
    }

    function testIfRevertIfNonSecretaryWalletIsCallingInjectFunds() public {
        vm.startPrank(member1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Secretary.SecretaryUnauthorizedSecretary.selector,
                member1
            )
        );
        tandaPay.injectFunds();
        vm.stopPrank();
    }

    function testIfRevertIfNotInInjectWindowWhileCallingInjectFunds() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);
        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);

        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);

        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        skip(4 days);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NotInInjectionWindow.selector)
        );
        tandaPay.injectFunds();
    }

    function testIfRevertIfNoClaimOccuredWhileCallingInjectFunds() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);
        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);

        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.NoClaimOccured.selector)
        );
        tandaPay.injectFunds();
    }

    function testIfRevertIfCoverageIsAlreadyFullfilledWhileInjectingFunds()
        public
    {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);

        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);
        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);

        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);

        skip(27 days);

        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;

        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);

        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        console.log(currentPeriodIdAfter2);
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);
        uint256 cIdBefore = tandaPay.getCurrentClaimId();
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ClaimSubmitted(member1, cIdBefore + 1);
        tandaPay.submitClaim();
        vm.stopPrank();
        uint256 cIdAfter = tandaPay.getCurrentClaimId();
        assertEq(cIdBefore + 1, cIdAfter);
        vm.expectRevert(
            abi.encodeWithSelector(TandaPay.CoverageFullfilled.selector)
        );
        tandaPay.injectFunds();
    }

    function testIfSecretaryCanSuccessfullyInjectFunds() public {
        addToCommunity(member1);
        addToCommunity(member2);
        addToCommunity(member3);
        addToCommunity(member4);
        addToCommunity(member5);
        addToCommunity(member6);
        addToCommunity(member7);
        addToCommunity(member8);
        addToCommunity(member9);
        addToCommunity(member10);
        addToCommunity(member11);
        addToCommunity(member12);

        uint256 gIdAfter1 = createASubGroup();
        uint256 gIdAfter2 = createASubGroup();
        uint256 gIdAfter3 = createASubGroup();

        assignToSubGroup(member1, gIdAfter1, 1);
        assignToSubGroup(member2, gIdAfter1, 2);
        assignToSubGroup(member3, gIdAfter1, 3);
        assignToSubGroup(member4, gIdAfter1, 4);
        assignToSubGroup(member5, gIdAfter2, 1);
        assignToSubGroup(member6, gIdAfter2, 2);
        assignToSubGroup(member7, gIdAfter2, 3);
        assignToSubGroup(member8, gIdAfter2, 4);
        assignToSubGroup(member9, gIdAfter3, 1);
        assignToSubGroup(member10, gIdAfter3, 2);
        assignToSubGroup(member11, gIdAfter3, 3);
        assignToSubGroup(member12, gIdAfter3, 4);

        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        basePremium = tandaPay.getBasePremium();

        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;

        joinToCommunity(member1, joinFee);
        joinToCommunity(member2, joinFee);
        joinToCommunity(member3, joinFee);
        joinToCommunity(member4, joinFee);
        joinToCommunity(member5, joinFee);
        joinToCommunity(member6, joinFee);
        joinToCommunity(member7, joinFee);
        joinToCommunity(member8, joinFee);
        joinToCommunity(member9, joinFee);
        joinToCommunity(member10, joinFee);
        joinToCommunity(member11, joinFee);
        joinToCommunity(member12, joinFee);
        uint256 currentPeriodIdBefore = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore + 1, currentPeriodIdAfter);

        TandaPay.PeriodInfo memory pInfo = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter
        );
        assertEq(pInfo.startedAt + 30 days, pInfo.willEndAt);

        skip(27 days);

        basePremium = tandaPay.getBasePremium();
        uint256 pFee = basePremium + ((basePremium * 20) / 100);
        bool shouldJoin = true;

        approveSubGroupAssignment(member1, shouldJoin);
        payPremium(member1, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member2, shouldJoin);
        payPremium(member2, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member3, shouldJoin);
        payPremium(member3, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member4, shouldJoin);
        payPremium(member4, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member5, shouldJoin);
        payPremium(member5, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member6, shouldJoin);
        payPremium(member6, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member7, shouldJoin);
        payPremium(member7, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member8, shouldJoin);
        payPremium(member8, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member9, shouldJoin);
        payPremium(member9, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member10, shouldJoin);
        payPremium(member10, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member11, shouldJoin);
        payPremium(member11, pFee, currentPeriodIdAfter, false);
        approveSubGroupAssignment(member12, shouldJoin);
        payPremium(member12, pFee, currentPeriodIdAfter, false);

        skip(3 days);
        uint256 currentPeriodIdBefore2 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.MemberStatusUpdated(
            member1,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member2,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member3,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member4,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member5,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member6,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member7,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member8,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member9,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member10,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member11,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member12,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore2 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();

        uint256 currentPeriodIdAfter2 = tandaPay.getPeriodId();
        assertEq(currentPeriodIdBefore2 + 1, currentPeriodIdAfter2);
        TandaPay.PeriodInfo memory pInfo2 = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter2
        );
        assertEq(pInfo2.startedAt + 30 days, pInfo2.willEndAt);
        skip(4 days);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.RefundIssued();
        tandaPay.issueRefund(false);
        basePremium = tandaPay.getBasePremium();
        pFee = basePremium + ((basePremium * 20) / 100);
        skip(23 days);
        payPremium(member1, pFee, currentPeriodIdAfter2, true);
        payPremium(member2, pFee, currentPeriodIdAfter2, true);
        payPremium(member3, pFee, currentPeriodIdAfter2, true);
        payPremium(member4, pFee, currentPeriodIdAfter2, true);
        payPremium(member5, pFee, currentPeriodIdAfter2, true);
        payPremium(member6, pFee, currentPeriodIdAfter2, true);
        payPremium(member7, pFee, currentPeriodIdAfter2, true);
        payPremium(member8, pFee, currentPeriodIdAfter2, true);
        payPremium(member9, pFee, currentPeriodIdAfter2, true);
        payPremium(member10, pFee, currentPeriodIdAfter2, true);
        payPremium(member11, pFee, currentPeriodIdAfter2, true);
        skip(3 days);
        uint256 currentPeriodIdBefore3 = tandaPay.getPeriodId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.MemberStatusUpdated(
            member1,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member2,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member3,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member4,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member5,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member6,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member7,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member8,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member9,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member10,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member11,
            TandaPayEvents.MemberStatus.VALID
        );
        emit TandaPayEvents.MemberStatusUpdated(
            member12,
            TandaPayEvents.MemberStatus.UNPAID_INVALID
        );
        emit TandaPayEvents.NextPeriodInitiated(
            currentPeriodIdBefore3 + 1,
            currentCoverage,
            basePremium
        );
        tandaPay.AdvanceToTheNextPeriod();
        uint256 currentPeriodIdAfter3 = tandaPay.getPeriodId();
        console.log(currentPeriodIdAfter3);
        assertEq(currentPeriodIdBefore3 + 1, currentPeriodIdAfter3);
        uint256 cIdBefore = tandaPay.getCurrentClaimId();
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.ClaimSubmitted(member1, cIdBefore + 1);
        tandaPay.submitClaim();
        vm.stopPrank();
        uint256 cIdAfter = tandaPay.getCurrentClaimId();
        assertEq(cIdBefore + 1, cIdAfter);
        TandaPay.PeriodInfo memory pInfo3 = tandaPay.getPeriodIdToPeriodInfo(
            currentPeriodIdAfter3
        );
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.FundInjected(pInfo3.coverage - pInfo3.totalPaid);
        tandaPay.injectFunds();
    }

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
                Secretary.SecretaryUnauthorizedSecretary.selector,
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
                Secretary.SecretaryUnauthorizedSecretary.selector,
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

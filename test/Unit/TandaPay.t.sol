// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {TandaPay, Secretary, TandaPayEvents} from "../../src/TandaPay.sol";
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
        uint256 mIdBefore3 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member3, mIdBefore3 + 1);
        tandaPay.addToCommunity(member3);
        uint256 mIdAfter3 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore3 + 1, mIdAfter3);
        TandaPay.DemoMemberInfo memory mInfo3 = tandaPay.getMemberToMemberInfo(
            member3,
            0
        );
        assertEq(mInfo3.associatedGroupId, 0);
        assertEq(mInfo3.member, member3);
        assertEq(mInfo3.memberId, mIdAfter3);
        assertEq(
            uint8(mInfo3.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo3.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore4 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member4, mIdBefore4 + 1);
        tandaPay.addToCommunity(member4);
        uint256 mIdAfter4 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore4 + 1, mIdAfter4);
        TandaPay.DemoMemberInfo memory mInfo4 = tandaPay.getMemberToMemberInfo(
            member4,
            0
        );
        assertEq(mInfo4.associatedGroupId, 0);
        assertEq(mInfo4.member, member4);
        assertEq(mInfo4.memberId, mIdAfter4);
        assertEq(
            uint8(mInfo4.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo4.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore5 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member5, mIdBefore5 + 1);
        tandaPay.addToCommunity(member5);
        uint256 mIdAfter5 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore5 + 1, mIdAfter5);
        TandaPay.DemoMemberInfo memory mInfo5 = tandaPay.getMemberToMemberInfo(
            member5,
            0
        );
        assertEq(mInfo5.associatedGroupId, 0);
        assertEq(mInfo5.member, member5);
        assertEq(mInfo5.memberId, mIdAfter5);
        assertEq(
            uint8(mInfo5.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo5.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore6 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member6, mIdBefore6 + 1);
        tandaPay.addToCommunity(member6);
        uint256 mIdAfter6 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore6 + 1, mIdAfter6);
        TandaPay.DemoMemberInfo memory mInfo6 = tandaPay.getMemberToMemberInfo(
            member6,
            0
        );
        assertEq(mInfo6.associatedGroupId, 0);
        assertEq(mInfo6.member, member6);
        assertEq(mInfo6.memberId, mIdAfter6);
        assertEq(
            uint8(mInfo6.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo6.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore7 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member7, mIdBefore7 + 1);
        tandaPay.addToCommunity(member7);
        uint256 mIdAfter7 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore7 + 1, mIdAfter7);
        TandaPay.DemoMemberInfo memory mInfo7 = tandaPay.getMemberToMemberInfo(
            member7,
            0
        );
        assertEq(mInfo7.associatedGroupId, 0);
        assertEq(mInfo7.member, member7);
        assertEq(mInfo7.memberId, mIdAfter7);
        assertEq(
            uint8(mInfo7.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo7.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 gIdBefore = tandaPay.getCurrentSubGroupId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.SubGroupCreated(gIdBefore + 1);
        tandaPay.createSubGroup();
        uint256 gIdAfter = tandaPay.getCurrentSubGroupId();
        assertEq(gIdBefore + 1, gIdAfter);

        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member1, gIdAfter, false);
        tandaPay.assignToSubGroup(member1, gIdAfter, false);
        mInfo1 = tandaPay.getMemberToMemberInfo(member1, 0);
        assertEq(mInfo1.associatedGroupId, gIdAfter);
        TandaPay.SubGroupInfo memory sInfo = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter);
        assertEq(sInfo.id, gIdAfter);
        bool isIn;
        for (uint256 i = 0; i < sInfo.members.length; i++) {
            if (sInfo.members[i] == member1) {
                isIn = true;
            }
        }
        assertTrue(isIn);
        assertTrue(!sInfo.isValid);
        assertEq(sInfo.members.length, 1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member2, gIdAfter, false);
        tandaPay.assignToSubGroup(member2, gIdAfter, false);
        mInfo2 = tandaPay.getMemberToMemberInfo(member2, 0);
        assertEq(mInfo2.associatedGroupId, gIdAfter);
        TandaPay.SubGroupInfo memory sInfo2 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter);
        assertEq(sInfo2.id, gIdAfter);
        bool isIn0;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member2) {
                console.log(sInfo2.members[i]);
                isIn0 = true;
            }
        }
        assertTrue(isIn0);
        assertEq(sInfo2.members.length, 2);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member3, gIdAfter, false);
        tandaPay.assignToSubGroup(member3, gIdAfter, false);
        mInfo3 = tandaPay.getMemberToMemberInfo(member3, 0);
        assertEq(mInfo3.associatedGroupId, gIdAfter);
        TandaPay.SubGroupInfo memory sInfo3 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter);
        assertEq(sInfo3.id, gIdAfter);
        bool isIn2;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member3) {
                isIn2 = true;
            }
        }
        assertTrue(isIn2);
        assertEq(sInfo3.members.length, 3);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member4, gIdAfter, false);
        tandaPay.assignToSubGroup(member4, gIdAfter, false);
        mInfo4 = tandaPay.getMemberToMemberInfo(member4, 0);
        assertEq(mInfo4.associatedGroupId, gIdAfter);
        TandaPay.SubGroupInfo memory sInfo4 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter);
        assertEq(sInfo4.id, gIdAfter);
        bool isIn3;
        for (uint256 i = 0; i < sInfo4.members.length; i++) {
            if (sInfo4.members[i] == member4) {
                isIn3 = true;
            }
        }
        assertTrue(isIn3);
        assertEq(sInfo4.members.length, 4);
        assertTrue(sInfo4.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member5, gIdAfter, false);
        tandaPay.assignToSubGroup(member5, gIdAfter, false);
        mInfo5 = tandaPay.getMemberToMemberInfo(member5, 0);
        assertEq(mInfo5.associatedGroupId, gIdAfter);
        TandaPay.SubGroupInfo memory sInfo5 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter);
        assertEq(sInfo5.id, gIdAfter);
        bool isIn5;
        for (uint256 i = 0; i < sInfo5.members.length; i++) {
            if (sInfo5.members[i] == member5) {
                isIn5 = true;
            }
        }
        assertTrue(isIn5);
        assertEq(sInfo5.members.length, 5);
        assertTrue(sInfo5.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member6, gIdAfter, false);
        tandaPay.assignToSubGroup(member6, gIdAfter, false);
        mInfo6 = tandaPay.getMemberToMemberInfo(member6, 0);
        assertEq(mInfo6.associatedGroupId, gIdAfter);
        TandaPay.SubGroupInfo memory sInfo6 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter);
        assertEq(sInfo6.id, gIdAfter);
        bool isIn6;
        for (uint256 i = 0; i < sInfo6.members.length; i++) {
            if (sInfo6.members[i] == member6) {
                isIn6 = true;
            }
        }
        assertTrue(isIn6);
        assertEq(sInfo6.members.length, 6);
        assertTrue(sInfo6.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member7, gIdAfter, false);
        tandaPay.assignToSubGroup(member7, gIdAfter, false);
        mInfo7 = tandaPay.getMemberToMemberInfo(member7, 0);
        assertEq(mInfo7.associatedGroupId, gIdAfter);
        TandaPay.SubGroupInfo memory sInfo7 = tandaPay
            .getSubGroupIdToSubGroupInfo(gIdAfter);
        assertEq(sInfo7.id, gIdAfter);
        bool isIn7;
        for (uint256 i = 0; i < sInfo7.members.length; i++) {
            if (sInfo7.members[i] == member7) {
                isIn7 = true;
            }
        }
        assertTrue(isIn7);
        assertEq(sInfo7.members.length, 7);
        assertTrue(sInfo7.isValid);
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
        uint256 mIdBefore3 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member3, mIdBefore3 + 1);
        tandaPay.addToCommunity(member3);
        uint256 mIdAfter3 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore3 + 1, mIdAfter3);
        TandaPay.DemoMemberInfo memory mInfo3 = tandaPay.getMemberToMemberInfo(
            member3,
            0
        );
        assertEq(mInfo3.associatedGroupId, 0);

        assertEq(mInfo3.member, member3);
        assertEq(mInfo3.memberId, mIdAfter3);
        assertEq(
            uint8(mInfo3.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo3.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore4 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member4, mIdBefore4 + 1);
        tandaPay.addToCommunity(member4);
        uint256 mIdAfter4 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore4 + 1, mIdAfter4);
        TandaPay.DemoMemberInfo memory mInfo4 = tandaPay.getMemberToMemberInfo(
            member4,
            0
        );
        assertEq(mInfo4.associatedGroupId, 0);

        assertEq(mInfo4.member, member4);
        assertEq(mInfo4.memberId, mIdAfter4);
        assertEq(
            uint8(mInfo4.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo4.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore5 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member5, mIdBefore5 + 1);
        tandaPay.addToCommunity(member5);
        uint256 mIdAfter5 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore5 + 1, mIdAfter5);
        TandaPay.DemoMemberInfo memory mInfo5 = tandaPay.getMemberToMemberInfo(
            member5,
            0
        );
        assertEq(mInfo5.associatedGroupId, 0);

        assertEq(mInfo5.member, member5);
        assertEq(mInfo5.memberId, mIdAfter5);
        assertEq(
            uint8(mInfo5.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo5.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore6 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member6, mIdBefore6 + 1);
        tandaPay.addToCommunity(member6);
        uint256 mIdAfter6 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore6 + 1, mIdAfter6);
        TandaPay.DemoMemberInfo memory mInfo6 = tandaPay.getMemberToMemberInfo(
            member6,
            0
        );
        assertEq(mInfo6.associatedGroupId, 0);

        assertEq(mInfo6.member, member6);
        assertEq(mInfo6.memberId, mIdAfter6);
        assertEq(
            uint8(mInfo6.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo6.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore7 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member7, mIdBefore7 + 1);
        tandaPay.addToCommunity(member7);
        uint256 mIdAfter7 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore7 + 1, mIdAfter7);
        TandaPay.DemoMemberInfo memory mInfo7 = tandaPay.getMemberToMemberInfo(
            member7,
            0
        );
        assertEq(mInfo7.associatedGroupId, 0);

        assertEq(mInfo7.member, member7);
        assertEq(mInfo7.memberId, mIdAfter7);
        assertEq(
            uint8(mInfo7.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo7.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore8 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member8, mIdBefore8 + 1);
        tandaPay.addToCommunity(member8);
        uint256 mIdAfter8 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore8 + 1, mIdAfter8);
        TandaPay.DemoMemberInfo memory mInfo8 = tandaPay.getMemberToMemberInfo(
            member8,
            0
        );
        assertEq(mInfo8.associatedGroupId, 0);

        assertEq(mInfo8.member, member8);
        assertEq(mInfo8.memberId, mIdAfter8);
        assertEq(
            uint8(mInfo8.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo8.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore9 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member9, mIdBefore9 + 1);
        tandaPay.addToCommunity(member9);
        uint256 mIdAfter9 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore9 + 1, mIdAfter9);
        TandaPay.DemoMemberInfo memory mInfo9 = tandaPay.getMemberToMemberInfo(
            member9,
            0
        );
        assertEq(mInfo9.associatedGroupId, 0);

        assertEq(mInfo9.member, member9);
        assertEq(mInfo9.memberId, mIdAfter9);
        assertEq(
            uint8(mInfo9.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo9.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore10 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member10, mIdBefore10 + 1);
        tandaPay.addToCommunity(member10);
        uint256 mIdAfter10 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore10 + 1, mIdAfter10);
        TandaPay.DemoMemberInfo memory mInfo10 = tandaPay.getMemberToMemberInfo(
            member10,
            0
        );
        assertEq(mInfo10.associatedGroupId, 0);

        assertEq(mInfo10.member, member10);
        assertEq(mInfo10.memberId, mIdAfter10);
        assertEq(
            uint8(mInfo10.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo10.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore11 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member11, mIdBefore11 + 1);
        tandaPay.addToCommunity(member11);
        uint256 mIdAfter11 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore11 + 1, mIdAfter11);
        TandaPay.DemoMemberInfo memory mInfo11 = tandaPay.getMemberToMemberInfo(
            member11,
            0
        );
        assertEq(mInfo11.associatedGroupId, 0);

        assertEq(mInfo11.member, member11);
        assertEq(mInfo11.memberId, mIdAfter11);
        assertEq(
            uint8(mInfo11.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo11.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore12 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member12, mIdBefore12 + 1);
        tandaPay.addToCommunity(member12);
        uint256 mIdAfter12 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore12 + 1, mIdAfter12);
        TandaPay.DemoMemberInfo memory mInfo12 = tandaPay.getMemberToMemberInfo(
            member12,
            0
        );
        assertEq(mInfo12.associatedGroupId, 0);

        assertEq(mInfo12.member, member12);
        assertEq(mInfo12.memberId, mIdAfter12);
        assertEq(
            uint8(mInfo12.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo12.assignment),
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
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member2, gIdAfter1, false);
        tandaPay.assignToSubGroup(member2, gIdAfter1, false);
        mInfo2 = tandaPay.getMemberToMemberInfo(member2, 0);
        assertEq(mInfo2.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn2;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member2) {
                isIn2 = true;
            }
        }
        assertTrue(isIn2);
        assertEq(sInfo1.members.length, 2);
        assertTrue(!sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member3, gIdAfter1, false);
        tandaPay.assignToSubGroup(member3, gIdAfter1, false);
        mInfo3 = tandaPay.getMemberToMemberInfo(member3, 0);
        assertEq(mInfo3.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn3;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member3) {
                isIn3 = true;
            }
        }
        assertTrue(isIn3);
        assertEq(sInfo1.members.length, 3);
        assertTrue(!sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member4, gIdAfter1, false);
        tandaPay.assignToSubGroup(member4, gIdAfter1, false);
        mInfo4 = tandaPay.getMemberToMemberInfo(member4, 0);
        assertEq(mInfo4.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn4;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member4) {
                isIn4 = true;
            }
        }
        assertTrue(isIn4);
        assertEq(sInfo1.members.length, 4);
        assertTrue(sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member5, gIdAfter2, false);
        tandaPay.assignToSubGroup(member5, gIdAfter2, false);
        mInfo5 = tandaPay.getMemberToMemberInfo(member5, 0);
        assertEq(mInfo5.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn5;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member5) {
                isIn5 = true;
            }
        }
        assertTrue(isIn5);
        assertEq(sInfo2.members.length, 1);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member6, gIdAfter2, false);
        tandaPay.assignToSubGroup(member6, gIdAfter2, false);
        mInfo6 = tandaPay.getMemberToMemberInfo(member6, 0);
        assertEq(mInfo6.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn6;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member6) {
                isIn6 = true;
            }
        }
        assertTrue(isIn6);
        assertEq(sInfo2.members.length, 2);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member7, gIdAfter2, false);
        tandaPay.assignToSubGroup(member7, gIdAfter2, false);
        mInfo7 = tandaPay.getMemberToMemberInfo(member7, 0);
        assertEq(mInfo7.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn7;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member7) {
                isIn7 = true;
            }
        }
        assertTrue(isIn7);
        assertEq(sInfo2.members.length, 3);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member8, gIdAfter2, false);
        tandaPay.assignToSubGroup(member8, gIdAfter2, false);
        mInfo8 = tandaPay.getMemberToMemberInfo(member8, 0);
        assertEq(mInfo8.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn8;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member8) {
                isIn8 = true;
            }
        }
        assertTrue(isIn8);
        assertEq(sInfo2.members.length, 4);
        assertTrue(sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member9, gIdAfter3, false);
        tandaPay.assignToSubGroup(member9, gIdAfter3, false);
        mInfo9 = tandaPay.getMemberToMemberInfo(member9, 0);
        assertEq(mInfo9.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn9;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member9) {
                isIn9 = true;
            }
        }
        assertTrue(isIn9);
        assertEq(sInfo3.members.length, 1);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member10, gIdAfter3, false);
        tandaPay.assignToSubGroup(member10, gIdAfter3, false);
        mInfo10 = tandaPay.getMemberToMemberInfo(member10, 0);
        assertEq(mInfo10.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn10;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member10) {
                isIn10 = true;
            }
        }
        assertTrue(isIn10);
        assertEq(sInfo3.members.length, 2);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member11, gIdAfter3, false);
        tandaPay.assignToSubGroup(member11, gIdAfter3, false);
        mInfo11 = tandaPay.getMemberToMemberInfo(member11, 0);
        assertEq(mInfo11.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn11;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member11) {
                isIn11 = true;
            }
        }
        assertTrue(isIn11);
        assertEq(sInfo3.members.length, 3);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member12, gIdAfter3, false);
        tandaPay.assignToSubGroup(member12, gIdAfter3, false);
        mInfo12 = tandaPay.getMemberToMemberInfo(member12, 0);
        assertEq(mInfo12.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn12;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member12) {
                isIn12 = true;
            }
        }
        assertTrue(isIn12);
        assertEq(sInfo3.members.length, 4);
        assertTrue(sInfo3.isValid);

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
        uint256 mIdBefore3 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member3, mIdBefore3 + 1);
        tandaPay.addToCommunity(member3);
        uint256 mIdAfter3 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore3 + 1, mIdAfter3);
        TandaPay.DemoMemberInfo memory mInfo3 = tandaPay.getMemberToMemberInfo(
            member3,
            0
        );
        assertEq(mInfo3.associatedGroupId, 0);

        assertEq(mInfo3.member, member3);
        assertEq(mInfo3.memberId, mIdAfter3);
        assertEq(
            uint8(mInfo3.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo3.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore4 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member4, mIdBefore4 + 1);
        tandaPay.addToCommunity(member4);
        uint256 mIdAfter4 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore4 + 1, mIdAfter4);
        TandaPay.DemoMemberInfo memory mInfo4 = tandaPay.getMemberToMemberInfo(
            member4,
            0
        );
        assertEq(mInfo4.associatedGroupId, 0);

        assertEq(mInfo4.member, member4);
        assertEq(mInfo4.memberId, mIdAfter4);
        assertEq(
            uint8(mInfo4.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo4.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore5 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member5, mIdBefore5 + 1);
        tandaPay.addToCommunity(member5);
        uint256 mIdAfter5 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore5 + 1, mIdAfter5);
        TandaPay.DemoMemberInfo memory mInfo5 = tandaPay.getMemberToMemberInfo(
            member5,
            0
        );
        assertEq(mInfo5.associatedGroupId, 0);

        assertEq(mInfo5.member, member5);
        assertEq(mInfo5.memberId, mIdAfter5);
        assertEq(
            uint8(mInfo5.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo5.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore6 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member6, mIdBefore6 + 1);
        tandaPay.addToCommunity(member6);
        uint256 mIdAfter6 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore6 + 1, mIdAfter6);
        TandaPay.DemoMemberInfo memory mInfo6 = tandaPay.getMemberToMemberInfo(
            member6,
            0
        );
        assertEq(mInfo6.associatedGroupId, 0);

        assertEq(mInfo6.member, member6);
        assertEq(mInfo6.memberId, mIdAfter6);
        assertEq(
            uint8(mInfo6.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo6.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore7 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member7, mIdBefore7 + 1);
        tandaPay.addToCommunity(member7);
        uint256 mIdAfter7 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore7 + 1, mIdAfter7);
        TandaPay.DemoMemberInfo memory mInfo7 = tandaPay.getMemberToMemberInfo(
            member7,
            0
        );
        assertEq(mInfo7.associatedGroupId, 0);

        assertEq(mInfo7.member, member7);
        assertEq(mInfo7.memberId, mIdAfter7);
        assertEq(
            uint8(mInfo7.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo7.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore8 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member8, mIdBefore8 + 1);
        tandaPay.addToCommunity(member8);
        uint256 mIdAfter8 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore8 + 1, mIdAfter8);
        TandaPay.DemoMemberInfo memory mInfo8 = tandaPay.getMemberToMemberInfo(
            member8,
            0
        );
        assertEq(mInfo8.associatedGroupId, 0);

        assertEq(mInfo8.member, member8);
        assertEq(mInfo8.memberId, mIdAfter8);
        assertEq(
            uint8(mInfo8.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo8.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore9 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member9, mIdBefore9 + 1);
        tandaPay.addToCommunity(member9);
        uint256 mIdAfter9 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore9 + 1, mIdAfter9);
        TandaPay.DemoMemberInfo memory mInfo9 = tandaPay.getMemberToMemberInfo(
            member9,
            0
        );
        assertEq(mInfo9.associatedGroupId, 0);

        assertEq(mInfo9.member, member9);
        assertEq(mInfo9.memberId, mIdAfter9);
        assertEq(
            uint8(mInfo9.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo9.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore10 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member10, mIdBefore10 + 1);
        tandaPay.addToCommunity(member10);
        uint256 mIdAfter10 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore10 + 1, mIdAfter10);
        TandaPay.DemoMemberInfo memory mInfo10 = tandaPay.getMemberToMemberInfo(
            member10,
            0
        );
        assertEq(mInfo10.associatedGroupId, 0);

        assertEq(mInfo10.member, member10);
        assertEq(mInfo10.memberId, mIdAfter10);
        assertEq(
            uint8(mInfo10.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo10.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore11 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member11, mIdBefore11 + 1);
        tandaPay.addToCommunity(member11);
        uint256 mIdAfter11 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore11 + 1, mIdAfter11);
        TandaPay.DemoMemberInfo memory mInfo11 = tandaPay.getMemberToMemberInfo(
            member11,
            0
        );
        assertEq(mInfo11.associatedGroupId, 0);

        assertEq(mInfo11.member, member11);
        assertEq(mInfo11.memberId, mIdAfter11);
        assertEq(
            uint8(mInfo11.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo11.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore12 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member12, mIdBefore12 + 1);
        tandaPay.addToCommunity(member12);
        uint256 mIdAfter12 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore12 + 1, mIdAfter12);
        TandaPay.DemoMemberInfo memory mInfo12 = tandaPay.getMemberToMemberInfo(
            member12,
            0
        );
        assertEq(mInfo12.associatedGroupId, 0);

        assertEq(mInfo12.member, member12);
        assertEq(mInfo12.memberId, mIdAfter12);
        assertEq(
            uint8(mInfo12.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo12.assignment),
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
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member2, gIdAfter1, false);
        tandaPay.assignToSubGroup(member2, gIdAfter1, false);
        mInfo2 = tandaPay.getMemberToMemberInfo(member2, 0);
        assertEq(mInfo2.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn2;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member2) {
                isIn2 = true;
            }
        }
        assertTrue(isIn2);
        assertEq(sInfo1.members.length, 2);
        assertTrue(!sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member3, gIdAfter1, false);
        tandaPay.assignToSubGroup(member3, gIdAfter1, false);
        mInfo3 = tandaPay.getMemberToMemberInfo(member3, 0);
        assertEq(mInfo3.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn3;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member3) {
                isIn3 = true;
            }
        }
        assertTrue(isIn3);
        assertEq(sInfo1.members.length, 3);
        assertTrue(!sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member4, gIdAfter1, false);
        tandaPay.assignToSubGroup(member4, gIdAfter1, false);
        mInfo4 = tandaPay.getMemberToMemberInfo(member4, 0);
        assertEq(mInfo4.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn4;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member4) {
                isIn4 = true;
            }
        }
        assertTrue(isIn4);
        assertEq(sInfo1.members.length, 4);
        assertTrue(sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member5, gIdAfter2, false);
        tandaPay.assignToSubGroup(member5, gIdAfter2, false);
        mInfo5 = tandaPay.getMemberToMemberInfo(member5, 0);
        assertEq(mInfo5.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn5;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member5) {
                isIn5 = true;
            }
        }
        assertTrue(isIn5);
        assertEq(sInfo2.members.length, 1);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member6, gIdAfter2, false);
        tandaPay.assignToSubGroup(member6, gIdAfter2, false);
        mInfo6 = tandaPay.getMemberToMemberInfo(member6, 0);
        assertEq(mInfo6.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn6;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member6) {
                isIn6 = true;
            }
        }
        assertTrue(isIn6);
        assertEq(sInfo2.members.length, 2);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member7, gIdAfter2, false);
        tandaPay.assignToSubGroup(member7, gIdAfter2, false);
        mInfo7 = tandaPay.getMemberToMemberInfo(member7, 0);
        assertEq(mInfo7.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn7;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member7) {
                isIn7 = true;
            }
        }
        assertTrue(isIn7);
        assertEq(sInfo2.members.length, 3);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member8, gIdAfter2, false);
        tandaPay.assignToSubGroup(member8, gIdAfter2, false);
        mInfo8 = tandaPay.getMemberToMemberInfo(member8, 0);
        assertEq(mInfo8.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn8;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member8) {
                isIn8 = true;
            }
        }
        assertTrue(isIn8);
        assertEq(sInfo2.members.length, 4);
        assertTrue(sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member9, gIdAfter3, false);
        tandaPay.assignToSubGroup(member9, gIdAfter3, false);
        mInfo9 = tandaPay.getMemberToMemberInfo(member9, 0);
        assertEq(mInfo9.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn9;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member9) {
                isIn9 = true;
            }
        }
        assertTrue(isIn9);
        assertEq(sInfo3.members.length, 1);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member10, gIdAfter3, false);
        tandaPay.assignToSubGroup(member10, gIdAfter3, false);
        mInfo10 = tandaPay.getMemberToMemberInfo(member10, 0);
        assertEq(mInfo10.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn10;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member10) {
                isIn10 = true;
            }
        }
        assertTrue(isIn10);
        assertEq(sInfo3.members.length, 2);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member11, gIdAfter3, false);
        tandaPay.assignToSubGroup(member11, gIdAfter3, false);
        mInfo11 = tandaPay.getMemberToMemberInfo(member11, 0);
        assertEq(mInfo11.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn11;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member11) {
                isIn11 = true;
            }
        }
        assertTrue(isIn11);
        assertEq(sInfo3.members.length, 3);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member12, gIdAfter3, false);
        tandaPay.assignToSubGroup(member12, gIdAfter3, false);
        mInfo12 = tandaPay.getMemberToMemberInfo(member12, 0);
        assertEq(mInfo12.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn12;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member12) {
                isIn12 = true;
            }
        }
        assertTrue(isIn12);
        assertEq(sInfo3.members.length, 4);
        assertTrue(sInfo3.isValid);

        uint256 coverage = 10e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        paymentToken.transfer(member12, 1000e18);
        uint256 m12BalanceBefore = paymentToken.balanceOf(member12);
        vm.startPrank(member12);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 bPAmount = tandaPay.getBasePremium();

        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member12, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m12BalanceAfter = paymentToken.balanceOf(member12);
        assertEq(m12BalanceBefore, m12BalanceAfter + joinFee);
        mInfo12 = tandaPay.getMemberToMemberInfo(member12, 0);
        assertEq(mInfo12.associatedGroupId, gIdAfter3);
        assertEq(uint8(mInfo12.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo12.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
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
        uint256 mIdBefore3 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member3, mIdBefore3 + 1);
        tandaPay.addToCommunity(member3);
        uint256 mIdAfter3 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore3 + 1, mIdAfter3);
        TandaPay.DemoMemberInfo memory mInfo3 = tandaPay.getMemberToMemberInfo(
            member3,
            0
        );
        assertEq(mInfo3.associatedGroupId, 0);

        assertEq(mInfo3.member, member3);
        assertEq(mInfo3.memberId, mIdAfter3);
        assertEq(
            uint8(mInfo3.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo3.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore4 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member4, mIdBefore4 + 1);
        tandaPay.addToCommunity(member4);
        uint256 mIdAfter4 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore4 + 1, mIdAfter4);
        TandaPay.DemoMemberInfo memory mInfo4 = tandaPay.getMemberToMemberInfo(
            member4,
            0
        );
        assertEq(mInfo4.associatedGroupId, 0);

        assertEq(mInfo4.member, member4);
        assertEq(mInfo4.memberId, mIdAfter4);
        assertEq(
            uint8(mInfo4.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo4.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore5 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member5, mIdBefore5 + 1);
        tandaPay.addToCommunity(member5);
        uint256 mIdAfter5 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore5 + 1, mIdAfter5);
        TandaPay.DemoMemberInfo memory mInfo5 = tandaPay.getMemberToMemberInfo(
            member5,
            0
        );
        assertEq(mInfo5.associatedGroupId, 0);

        assertEq(mInfo5.member, member5);
        assertEq(mInfo5.memberId, mIdAfter5);
        assertEq(
            uint8(mInfo5.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo5.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore6 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member6, mIdBefore6 + 1);
        tandaPay.addToCommunity(member6);
        uint256 mIdAfter6 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore6 + 1, mIdAfter6);
        TandaPay.DemoMemberInfo memory mInfo6 = tandaPay.getMemberToMemberInfo(
            member6,
            0
        );
        assertEq(mInfo6.associatedGroupId, 0);

        assertEq(mInfo6.member, member6);
        assertEq(mInfo6.memberId, mIdAfter6);
        assertEq(
            uint8(mInfo6.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo6.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore7 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member7, mIdBefore7 + 1);
        tandaPay.addToCommunity(member7);
        uint256 mIdAfter7 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore7 + 1, mIdAfter7);
        TandaPay.DemoMemberInfo memory mInfo7 = tandaPay.getMemberToMemberInfo(
            member7,
            0
        );
        assertEq(mInfo7.associatedGroupId, 0);

        assertEq(mInfo7.member, member7);
        assertEq(mInfo7.memberId, mIdAfter7);
        assertEq(
            uint8(mInfo7.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo7.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore8 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member8, mIdBefore8 + 1);
        tandaPay.addToCommunity(member8);
        uint256 mIdAfter8 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore8 + 1, mIdAfter8);
        TandaPay.DemoMemberInfo memory mInfo8 = tandaPay.getMemberToMemberInfo(
            member8,
            0
        );
        assertEq(mInfo8.associatedGroupId, 0);

        assertEq(mInfo8.member, member8);
        assertEq(mInfo8.memberId, mIdAfter8);
        assertEq(
            uint8(mInfo8.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo8.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore9 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member9, mIdBefore9 + 1);
        tandaPay.addToCommunity(member9);
        uint256 mIdAfter9 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore9 + 1, mIdAfter9);
        TandaPay.DemoMemberInfo memory mInfo9 = tandaPay.getMemberToMemberInfo(
            member9,
            0
        );
        assertEq(mInfo9.associatedGroupId, 0);

        assertEq(mInfo9.member, member9);
        assertEq(mInfo9.memberId, mIdAfter9);
        assertEq(
            uint8(mInfo9.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo9.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore10 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member10, mIdBefore10 + 1);
        tandaPay.addToCommunity(member10);
        uint256 mIdAfter10 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore10 + 1, mIdAfter10);
        TandaPay.DemoMemberInfo memory mInfo10 = tandaPay.getMemberToMemberInfo(
            member10,
            0
        );
        assertEq(mInfo10.associatedGroupId, 0);

        assertEq(mInfo10.member, member10);
        assertEq(mInfo10.memberId, mIdAfter10);
        assertEq(
            uint8(mInfo10.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo10.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore11 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member11, mIdBefore11 + 1);
        tandaPay.addToCommunity(member11);
        uint256 mIdAfter11 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore11 + 1, mIdAfter11);
        TandaPay.DemoMemberInfo memory mInfo11 = tandaPay.getMemberToMemberInfo(
            member11,
            0
        );
        assertEq(mInfo11.associatedGroupId, 0);

        assertEq(mInfo11.member, member11);
        assertEq(mInfo11.memberId, mIdAfter11);
        assertEq(
            uint8(mInfo11.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo11.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore12 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member12, mIdBefore12 + 1);
        tandaPay.addToCommunity(member12);
        uint256 mIdAfter12 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore12 + 1, mIdAfter12);
        TandaPay.DemoMemberInfo memory mInfo12 = tandaPay.getMemberToMemberInfo(
            member12,
            0
        );
        assertEq(mInfo12.associatedGroupId, 0);

        assertEq(mInfo12.member, member12);
        assertEq(mInfo12.memberId, mIdAfter12);
        assertEq(
            uint8(mInfo12.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo12.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );

        vm.expectRevert(abi.encodeWithSelector(TandaPay.DFNotMet.selector));
        tandaPay.initiatDefaultStateAndSetCoverage(10e18);
    }

    function testIfRevertIfAnyOfTheSubGroupHasLessThan4memberWhileInitiatingTheDefaultState()
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
        uint256 mIdBefore3 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member3, mIdBefore3 + 1);
        tandaPay.addToCommunity(member3);
        uint256 mIdAfter3 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore3 + 1, mIdAfter3);
        TandaPay.DemoMemberInfo memory mInfo3 = tandaPay.getMemberToMemberInfo(
            member3,
            0
        );
        assertEq(mInfo3.associatedGroupId, 0);

        assertEq(mInfo3.member, member3);
        assertEq(mInfo3.memberId, mIdAfter3);
        assertEq(
            uint8(mInfo3.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo3.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore4 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member4, mIdBefore4 + 1);
        tandaPay.addToCommunity(member4);
        uint256 mIdAfter4 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore4 + 1, mIdAfter4);
        TandaPay.DemoMemberInfo memory mInfo4 = tandaPay.getMemberToMemberInfo(
            member4,
            0
        );
        assertEq(mInfo4.associatedGroupId, 0);

        assertEq(mInfo4.member, member4);
        assertEq(mInfo4.memberId, mIdAfter4);
        assertEq(
            uint8(mInfo4.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo4.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore5 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member5, mIdBefore5 + 1);
        tandaPay.addToCommunity(member5);
        uint256 mIdAfter5 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore5 + 1, mIdAfter5);
        TandaPay.DemoMemberInfo memory mInfo5 = tandaPay.getMemberToMemberInfo(
            member5,
            0
        );
        assertEq(mInfo5.associatedGroupId, 0);

        assertEq(mInfo5.member, member5);
        assertEq(mInfo5.memberId, mIdAfter5);
        assertEq(
            uint8(mInfo5.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo5.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore6 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member6, mIdBefore6 + 1);
        tandaPay.addToCommunity(member6);
        uint256 mIdAfter6 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore6 + 1, mIdAfter6);
        TandaPay.DemoMemberInfo memory mInfo6 = tandaPay.getMemberToMemberInfo(
            member6,
            0
        );
        assertEq(mInfo6.associatedGroupId, 0);

        assertEq(mInfo6.member, member6);
        assertEq(mInfo6.memberId, mIdAfter6);
        assertEq(
            uint8(mInfo6.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo6.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore7 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member7, mIdBefore7 + 1);
        tandaPay.addToCommunity(member7);
        uint256 mIdAfter7 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore7 + 1, mIdAfter7);
        TandaPay.DemoMemberInfo memory mInfo7 = tandaPay.getMemberToMemberInfo(
            member7,
            0
        );
        assertEq(mInfo7.associatedGroupId, 0);

        assertEq(mInfo7.member, member7);
        assertEq(mInfo7.memberId, mIdAfter7);
        assertEq(
            uint8(mInfo7.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo7.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore8 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member8, mIdBefore8 + 1);
        tandaPay.addToCommunity(member8);
        uint256 mIdAfter8 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore8 + 1, mIdAfter8);
        TandaPay.DemoMemberInfo memory mInfo8 = tandaPay.getMemberToMemberInfo(
            member8,
            0
        );
        assertEq(mInfo8.associatedGroupId, 0);

        assertEq(mInfo8.member, member8);
        assertEq(mInfo8.memberId, mIdAfter8);
        assertEq(
            uint8(mInfo8.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo8.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore9 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member9, mIdBefore9 + 1);
        tandaPay.addToCommunity(member9);
        uint256 mIdAfter9 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore9 + 1, mIdAfter9);
        TandaPay.DemoMemberInfo memory mInfo9 = tandaPay.getMemberToMemberInfo(
            member9,
            0
        );
        assertEq(mInfo9.associatedGroupId, 0);

        assertEq(mInfo9.member, member9);
        assertEq(mInfo9.memberId, mIdAfter9);
        assertEq(
            uint8(mInfo9.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo9.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore10 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member10, mIdBefore10 + 1);
        tandaPay.addToCommunity(member10);
        uint256 mIdAfter10 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore10 + 1, mIdAfter10);
        TandaPay.DemoMemberInfo memory mInfo10 = tandaPay.getMemberToMemberInfo(
            member10,
            0
        );
        assertEq(mInfo10.associatedGroupId, 0);

        assertEq(mInfo10.member, member10);
        assertEq(mInfo10.memberId, mIdAfter10);
        assertEq(
            uint8(mInfo10.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo10.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore11 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member11, mIdBefore11 + 1);
        tandaPay.addToCommunity(member11);
        uint256 mIdAfter11 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore11 + 1, mIdAfter11);
        TandaPay.DemoMemberInfo memory mInfo11 = tandaPay.getMemberToMemberInfo(
            member11,
            0
        );
        assertEq(mInfo11.associatedGroupId, 0);

        assertEq(mInfo11.member, member11);
        assertEq(mInfo11.memberId, mIdAfter11);
        assertEq(
            uint8(mInfo11.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo11.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore12 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member12, mIdBefore12 + 1);
        tandaPay.addToCommunity(member12);
        uint256 mIdAfter12 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore12 + 1, mIdAfter12);
        TandaPay.DemoMemberInfo memory mInfo12 = tandaPay.getMemberToMemberInfo(
            member12,
            0
        );
        assertEq(mInfo12.associatedGroupId, 0);

        assertEq(mInfo12.member, member12);
        assertEq(mInfo12.memberId, mIdAfter12);
        assertEq(
            uint8(mInfo12.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo12.assignment),
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
        uint256 mIdBefore3 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member3, mIdBefore3 + 1);
        tandaPay.addToCommunity(member3);
        uint256 mIdAfter3 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore3 + 1, mIdAfter3);
        TandaPay.DemoMemberInfo memory mInfo3 = tandaPay.getMemberToMemberInfo(
            member3,
            0
        );
        assertEq(mInfo3.associatedGroupId, 0);

        assertEq(mInfo3.member, member3);
        assertEq(mInfo3.memberId, mIdAfter3);
        assertEq(
            uint8(mInfo3.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo3.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore4 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member4, mIdBefore4 + 1);
        tandaPay.addToCommunity(member4);
        uint256 mIdAfter4 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore4 + 1, mIdAfter4);
        TandaPay.DemoMemberInfo memory mInfo4 = tandaPay.getMemberToMemberInfo(
            member4,
            0
        );
        assertEq(mInfo4.associatedGroupId, 0);

        assertEq(mInfo4.member, member4);
        assertEq(mInfo4.memberId, mIdAfter4);
        assertEq(
            uint8(mInfo4.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo4.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore5 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member5, mIdBefore5 + 1);
        tandaPay.addToCommunity(member5);
        uint256 mIdAfter5 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore5 + 1, mIdAfter5);
        TandaPay.DemoMemberInfo memory mInfo5 = tandaPay.getMemberToMemberInfo(
            member5,
            0
        );
        assertEq(mInfo5.associatedGroupId, 0);

        assertEq(mInfo5.member, member5);
        assertEq(mInfo5.memberId, mIdAfter5);
        assertEq(
            uint8(mInfo5.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo5.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore6 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member6, mIdBefore6 + 1);
        tandaPay.addToCommunity(member6);
        uint256 mIdAfter6 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore6 + 1, mIdAfter6);
        TandaPay.DemoMemberInfo memory mInfo6 = tandaPay.getMemberToMemberInfo(
            member6,
            0
        );
        assertEq(mInfo6.associatedGroupId, 0);

        assertEq(mInfo6.member, member6);
        assertEq(mInfo6.memberId, mIdAfter6);
        assertEq(
            uint8(mInfo6.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo6.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore7 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member7, mIdBefore7 + 1);
        tandaPay.addToCommunity(member7);
        uint256 mIdAfter7 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore7 + 1, mIdAfter7);
        TandaPay.DemoMemberInfo memory mInfo7 = tandaPay.getMemberToMemberInfo(
            member7,
            0
        );
        assertEq(mInfo7.associatedGroupId, 0);

        assertEq(mInfo7.member, member7);
        assertEq(mInfo7.memberId, mIdAfter7);
        assertEq(
            uint8(mInfo7.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo7.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore8 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member8, mIdBefore8 + 1);
        tandaPay.addToCommunity(member8);
        uint256 mIdAfter8 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore8 + 1, mIdAfter8);
        TandaPay.DemoMemberInfo memory mInfo8 = tandaPay.getMemberToMemberInfo(
            member8,
            0
        );
        assertEq(mInfo8.associatedGroupId, 0);

        assertEq(mInfo8.member, member8);
        assertEq(mInfo8.memberId, mIdAfter8);
        assertEq(
            uint8(mInfo8.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo8.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore9 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member9, mIdBefore9 + 1);
        tandaPay.addToCommunity(member9);
        uint256 mIdAfter9 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore9 + 1, mIdAfter9);
        TandaPay.DemoMemberInfo memory mInfo9 = tandaPay.getMemberToMemberInfo(
            member9,
            0
        );
        assertEq(mInfo9.associatedGroupId, 0);

        assertEq(mInfo9.member, member9);
        assertEq(mInfo9.memberId, mIdAfter9);
        assertEq(
            uint8(mInfo9.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo9.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore10 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member10, mIdBefore10 + 1);
        tandaPay.addToCommunity(member10);

        uint256 mIdAfter10 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore10 + 1, mIdAfter10);
        TandaPay.DemoMemberInfo memory mInfo10 = tandaPay.getMemberToMemberInfo(
            member10,
            0
        );
        assertEq(mInfo10.associatedGroupId, 0);

        assertEq(mInfo10.member, member10);
        assertEq(mInfo10.memberId, mIdAfter10);
        assertEq(
            uint8(mInfo10.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo10.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore11 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member11, mIdBefore11 + 1);
        tandaPay.addToCommunity(member11);
        uint256 mIdAfter11 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore11 + 1, mIdAfter11);
        TandaPay.DemoMemberInfo memory mInfo11 = tandaPay.getMemberToMemberInfo(
            member11,
            0
        );
        assertEq(mInfo11.associatedGroupId, 0);

        assertEq(mInfo11.member, member11);
        assertEq(mInfo11.memberId, mIdAfter11);
        assertEq(
            uint8(mInfo11.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo11.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore12 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member12, mIdBefore12 + 1);
        tandaPay.addToCommunity(member12);
        uint256 mIdAfter12 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore12 + 1, mIdAfter12);
        TandaPay.DemoMemberInfo memory mInfo12 = tandaPay.getMemberToMemberInfo(
            member12,
            0
        );
        assertEq(mInfo12.associatedGroupId, 0);

        assertEq(mInfo12.member, member12);
        assertEq(mInfo12.memberId, mIdAfter12);
        assertEq(
            uint8(mInfo12.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo12.assignment),
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
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member2, gIdAfter1, false);
        tandaPay.assignToSubGroup(member2, gIdAfter1, false);
        mInfo2 = tandaPay.getMemberToMemberInfo(member2, 0);
        assertEq(mInfo2.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn2;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member2) {
                isIn2 = true;
            }
        }
        assertTrue(isIn2);
        assertEq(sInfo1.members.length, 2);
        assertTrue(!sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member3, gIdAfter1, false);
        tandaPay.assignToSubGroup(member3, gIdAfter1, false);
        mInfo3 = tandaPay.getMemberToMemberInfo(member3, 0);
        assertEq(mInfo3.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn3;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member3) {
                isIn3 = true;
            }
        }
        assertTrue(isIn3);
        assertEq(sInfo1.members.length, 3);
        assertTrue(!sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member4, gIdAfter1, false);
        tandaPay.assignToSubGroup(member4, gIdAfter1, false);
        mInfo4 = tandaPay.getMemberToMemberInfo(member4, 0);
        assertEq(mInfo4.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn4;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member4) {
                isIn4 = true;
            }
        }
        assertTrue(isIn4);
        assertEq(sInfo1.members.length, 4);
        assertTrue(sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member5, gIdAfter2, false);
        tandaPay.assignToSubGroup(member5, gIdAfter2, false);
        mInfo5 = tandaPay.getMemberToMemberInfo(member5, 0);
        assertEq(mInfo5.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn5;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member5) {
                isIn5 = true;
            }
        }
        assertTrue(isIn5);
        assertEq(sInfo2.members.length, 1);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member6, gIdAfter2, false);
        tandaPay.assignToSubGroup(member6, gIdAfter2, false);
        mInfo6 = tandaPay.getMemberToMemberInfo(member6, 0);
        assertEq(mInfo6.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn6;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member6) {
                isIn6 = true;
            }
        }
        assertTrue(isIn6);
        assertEq(sInfo2.members.length, 2);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member7, gIdAfter2, false);
        tandaPay.assignToSubGroup(member7, gIdAfter2, false);
        mInfo7 = tandaPay.getMemberToMemberInfo(member7, 0);
        assertEq(mInfo7.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn7;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member7) {
                isIn7 = true;
            }
        }
        assertTrue(isIn7);
        assertEq(sInfo2.members.length, 3);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member8, gIdAfter2, false);
        tandaPay.assignToSubGroup(member8, gIdAfter2, false);
        mInfo8 = tandaPay.getMemberToMemberInfo(member8, 0);
        assertEq(mInfo8.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn8;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member8) {
                isIn8 = true;
            }
        }
        assertTrue(isIn8);
        assertEq(sInfo2.members.length, 4);
        assertTrue(sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member9, gIdAfter3, false);
        tandaPay.assignToSubGroup(member9, gIdAfter3, false);
        mInfo9 = tandaPay.getMemberToMemberInfo(member9, 0);
        assertEq(mInfo9.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn9;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member9) {
                isIn9 = true;
            }
        }
        assertTrue(isIn9);
        assertEq(sInfo3.members.length, 1);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member10, gIdAfter3, false);
        tandaPay.assignToSubGroup(member10, gIdAfter3, false);
        mInfo10 = tandaPay.getMemberToMemberInfo(member10, 0);
        assertEq(mInfo10.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn10;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member10) {
                isIn10 = true;
            }
        }
        assertTrue(isIn10);
        assertEq(sInfo3.members.length, 2);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member11, gIdAfter3, false);
        tandaPay.assignToSubGroup(member11, gIdAfter3, false);
        mInfo11 = tandaPay.getMemberToMemberInfo(member11, 0);
        assertEq(mInfo11.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn11;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member11) {
                isIn11 = true;
            }
        }
        assertTrue(isIn11);
        assertEq(sInfo3.members.length, 3);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member12, gIdAfter3, false);
        tandaPay.assignToSubGroup(member12, gIdAfter3, false);
        mInfo12 = tandaPay.getMemberToMemberInfo(member12, 0);
        assertEq(mInfo12.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn12;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member12) {
                isIn12 = true;
            }
        }
        assertTrue(isIn12);
        assertEq(sInfo3.members.length, 4);
        assertTrue(sInfo3.isValid);
        uint256 coverage = 10e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        uint256 basePremium = tandaPay.getBasePremium();
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
        uint256 mIdBefore3 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member3, mIdBefore3 + 1);
        tandaPay.addToCommunity(member3);
        uint256 mIdAfter3 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore3 + 1, mIdAfter3);
        TandaPay.DemoMemberInfo memory mInfo3 = tandaPay.getMemberToMemberInfo(
            member3,
            0
        );
        assertEq(mInfo3.associatedGroupId, 0);

        assertEq(mInfo3.member, member3);
        assertEq(mInfo3.memberId, mIdAfter3);
        assertEq(
            uint8(mInfo3.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo3.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore4 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member4, mIdBefore4 + 1);
        tandaPay.addToCommunity(member4);
        uint256 mIdAfter4 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore4 + 1, mIdAfter4);
        TandaPay.DemoMemberInfo memory mInfo4 = tandaPay.getMemberToMemberInfo(
            member4,
            0
        );
        assertEq(mInfo4.associatedGroupId, 0);

        assertEq(mInfo4.member, member4);
        assertEq(mInfo4.memberId, mIdAfter4);
        assertEq(
            uint8(mInfo4.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo4.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore5 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member5, mIdBefore5 + 1);
        tandaPay.addToCommunity(member5);
        uint256 mIdAfter5 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore5 + 1, mIdAfter5);
        TandaPay.DemoMemberInfo memory mInfo5 = tandaPay.getMemberToMemberInfo(
            member5,
            0
        );
        assertEq(mInfo5.associatedGroupId, 0);

        assertEq(mInfo5.member, member5);
        assertEq(mInfo5.memberId, mIdAfter5);
        assertEq(
            uint8(mInfo5.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo5.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore6 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member6, mIdBefore6 + 1);
        tandaPay.addToCommunity(member6);
        uint256 mIdAfter6 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore6 + 1, mIdAfter6);
        TandaPay.DemoMemberInfo memory mInfo6 = tandaPay.getMemberToMemberInfo(
            member6,
            0
        );
        assertEq(mInfo6.associatedGroupId, 0);

        assertEq(mInfo6.member, member6);
        assertEq(mInfo6.memberId, mIdAfter6);
        assertEq(
            uint8(mInfo6.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo6.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore7 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member7, mIdBefore7 + 1);
        tandaPay.addToCommunity(member7);
        uint256 mIdAfter7 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore7 + 1, mIdAfter7);
        TandaPay.DemoMemberInfo memory mInfo7 = tandaPay.getMemberToMemberInfo(
            member7,
            0
        );
        assertEq(mInfo7.associatedGroupId, 0);

        assertEq(mInfo7.member, member7);
        assertEq(mInfo7.memberId, mIdAfter7);
        assertEq(
            uint8(mInfo7.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo7.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore8 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member8, mIdBefore8 + 1);
        tandaPay.addToCommunity(member8);
        uint256 mIdAfter8 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore8 + 1, mIdAfter8);
        TandaPay.DemoMemberInfo memory mInfo8 = tandaPay.getMemberToMemberInfo(
            member8,
            0
        );
        assertEq(mInfo8.associatedGroupId, 0);

        assertEq(mInfo8.member, member8);
        assertEq(mInfo8.memberId, mIdAfter8);
        assertEq(
            uint8(mInfo8.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo8.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore9 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member9, mIdBefore9 + 1);
        tandaPay.addToCommunity(member9);
        uint256 mIdAfter9 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore9 + 1, mIdAfter9);
        TandaPay.DemoMemberInfo memory mInfo9 = tandaPay.getMemberToMemberInfo(
            member9,
            0
        );
        assertEq(mInfo9.associatedGroupId, 0);

        assertEq(mInfo9.member, member9);
        assertEq(mInfo9.memberId, mIdAfter9);
        assertEq(
            uint8(mInfo9.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo9.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore10 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member10, mIdBefore10 + 1);
        tandaPay.addToCommunity(member10);

        uint256 mIdAfter10 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore10 + 1, mIdAfter10);
        TandaPay.DemoMemberInfo memory mInfo10 = tandaPay.getMemberToMemberInfo(
            member10,
            0
        );
        assertEq(mInfo10.associatedGroupId, 0);

        assertEq(mInfo10.member, member10);
        assertEq(mInfo10.memberId, mIdAfter10);
        assertEq(
            uint8(mInfo10.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo10.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore11 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member11, mIdBefore11 + 1);
        tandaPay.addToCommunity(member11);
        uint256 mIdAfter11 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore11 + 1, mIdAfter11);
        TandaPay.DemoMemberInfo memory mInfo11 = tandaPay.getMemberToMemberInfo(
            member11,
            0
        );
        assertEq(mInfo11.associatedGroupId, 0);

        assertEq(mInfo11.member, member11);
        assertEq(mInfo11.memberId, mIdAfter11);
        assertEq(
            uint8(mInfo11.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo11.assignment),
            uint8(TandaPay.AssignmentStatus.AddedBySecretery)
        );
        uint256 mIdBefore12 = tandaPay.getCurrentMemberId();
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AddedToCommunity(member12, mIdBefore12 + 1);
        tandaPay.addToCommunity(member12);
        uint256 mIdAfter12 = tandaPay.getCurrentMemberId();
        assertEq(mIdBefore12 + 1, mIdAfter12);
        TandaPay.DemoMemberInfo memory mInfo12 = tandaPay.getMemberToMemberInfo(
            member12,
            0
        );
        assertEq(mInfo12.associatedGroupId, 0);

        assertEq(mInfo12.member, member12);
        assertEq(mInfo12.memberId, mIdAfter12);
        assertEq(
            uint8(mInfo12.status),
            uint8(TandaPayEvents.MemberStatus.Assigned)
        );
        assertEq(
            uint8(mInfo12.assignment),
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
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member2, gIdAfter1, false);
        tandaPay.assignToSubGroup(member2, gIdAfter1, false);
        mInfo2 = tandaPay.getMemberToMemberInfo(member2, 0);
        assertEq(mInfo2.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn2;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member2) {
                isIn2 = true;
            }
        }
        assertTrue(isIn2);
        assertEq(sInfo1.members.length, 2);
        assertTrue(!sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member3, gIdAfter1, false);
        tandaPay.assignToSubGroup(member3, gIdAfter1, false);
        mInfo3 = tandaPay.getMemberToMemberInfo(member3, 0);
        assertEq(mInfo3.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn3;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member3) {
                isIn3 = true;
            }
        }
        assertTrue(isIn3);
        assertEq(sInfo1.members.length, 3);
        assertTrue(!sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member4, gIdAfter1, false);
        tandaPay.assignToSubGroup(member4, gIdAfter1, false);
        mInfo4 = tandaPay.getMemberToMemberInfo(member4, 0);
        assertEq(mInfo4.associatedGroupId, gIdAfter1);
        sInfo1 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter1);
        assertEq(sInfo1.id, gIdAfter1);
        bool isIn4;
        for (uint256 i = 0; i < sInfo1.members.length; i++) {
            if (sInfo1.members[i] == member4) {
                isIn4 = true;
            }
        }
        assertTrue(isIn4);
        assertEq(sInfo1.members.length, 4);
        assertTrue(sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member5, gIdAfter2, false);
        tandaPay.assignToSubGroup(member5, gIdAfter2, false);
        mInfo5 = tandaPay.getMemberToMemberInfo(member5, 0);

        assertEq(mInfo5.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);

        assertEq(sInfo2.id, gIdAfter2);
        bool isIn5;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member5) {
                isIn5 = true;
            }
        }
        assertTrue(isIn5);
        assertEq(sInfo2.members.length, 1);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member6, gIdAfter2, false);
        tandaPay.assignToSubGroup(member6, gIdAfter2, false);
        mInfo6 = tandaPay.getMemberToMemberInfo(member6, 0);
        assertEq(mInfo6.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn6;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member6) {
                isIn6 = true;
            }
        }
        assertTrue(isIn6);
        assertEq(sInfo2.members.length, 2);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member7, gIdAfter2, false);
        tandaPay.assignToSubGroup(member7, gIdAfter2, false);
        mInfo7 = tandaPay.getMemberToMemberInfo(member7, 0);
        assertEq(mInfo7.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn7;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member7) {
                isIn7 = true;
            }
        }
        assertTrue(isIn7);
        assertEq(sInfo2.members.length, 3);
        assertTrue(!sInfo2.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member8, gIdAfter2, false);
        tandaPay.assignToSubGroup(member8, gIdAfter2, false);
        mInfo8 = tandaPay.getMemberToMemberInfo(member8, 0);
        assertEq(mInfo8.associatedGroupId, gIdAfter2);
        sInfo2 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter2);
        assertEq(sInfo2.id, gIdAfter2);
        bool isIn8;
        for (uint256 i = 0; i < sInfo2.members.length; i++) {
            if (sInfo2.members[i] == member8) {
                isIn8 = true;
            }
        }
        assertTrue(isIn8);
        assertEq(sInfo2.members.length, 4);
        assertTrue(sInfo1.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member9, gIdAfter3, false);
        tandaPay.assignToSubGroup(member9, gIdAfter3, false);
        mInfo9 = tandaPay.getMemberToMemberInfo(member9, 0);
        assertEq(mInfo9.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn9;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member9) {
                isIn9 = true;
            }
        }
        assertTrue(isIn9);
        assertEq(sInfo3.members.length, 1);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member10, gIdAfter3, false);
        tandaPay.assignToSubGroup(member10, gIdAfter3, false);
        mInfo10 = tandaPay.getMemberToMemberInfo(member10, 0);
        assertEq(mInfo10.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn10;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member10) {
                isIn10 = true;
            }
        }
        assertTrue(isIn10);
        assertEq(sInfo3.members.length, 2);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member11, gIdAfter3, false);
        tandaPay.assignToSubGroup(member11, gIdAfter3, false);
        mInfo11 = tandaPay.getMemberToMemberInfo(member11, 0);
        assertEq(mInfo11.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn11;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member11) {
                isIn11 = true;
            }
        }
        assertTrue(isIn11);
        assertEq(sInfo3.members.length, 3);
        assertTrue(!sInfo3.isValid);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.AssignedToSubGroup(member12, gIdAfter3, false);
        tandaPay.assignToSubGroup(member12, gIdAfter3, false);
        mInfo12 = tandaPay.getMemberToMemberInfo(member12, 0);
        assertEq(mInfo12.associatedGroupId, gIdAfter3);
        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn12;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member12) {
                isIn12 = true;
            }
        }
        assertTrue(isIn12);
        assertEq(sInfo3.members.length, 4);
        assertTrue(sInfo3.isValid);
        uint256 coverage = 12e18;
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.DefaultStateInitiatedAndCoverageSet(coverage);
        tandaPay.initiatDefaultStateAndSetCoverage(coverage);
        TandaPay.CommunityStates states = tandaPay.getCommunityState();
        assertEq(uint8(states), uint8(TandaPay.CommunityStates.DEFAULT));
        uint256 currentCoverage = tandaPay.getTotalCoverage();
        assertEq(currentCoverage, coverage);
        uint256 currentMemberId = tandaPay.getCurrentMemberId();
        uint256 basePremium = tandaPay.getBasePremium();
        assertEq(basePremium, currentCoverage / currentMemberId);
        uint256 bPAmount = tandaPay.getBasePremium();
        uint256 joinFee = ((bPAmount + (bPAmount * 20) / 100) * 11) / 12;
        vm.startPrank(member1);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m1BalanceBefore = paymentToken.balanceOf(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member1, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m1BalanceAfter = paymentToken.balanceOf(member1);
        assertEq(m1BalanceBefore, m1BalanceAfter + joinFee);
        mInfo1 = tandaPay.getMemberToMemberInfo(member1, 0);
        assertEq(joinFee, mInfo1.ISEscorwAmount);
        assertEq(mInfo1.associatedGroupId, gIdAfter1);
        assertEq(uint8(mInfo1.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo1.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.startPrank(member2);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m2BalanceBefore = paymentToken.balanceOf(member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member2, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m2BalanceAfter = paymentToken.balanceOf(member2);
        assertEq(m2BalanceBefore, m2BalanceAfter + joinFee);
        mInfo2 = tandaPay.getMemberToMemberInfo(member2, 0);
        assertEq(joinFee, mInfo2.ISEscorwAmount);
        assertEq(mInfo2.associatedGroupId, gIdAfter1);
        assertEq(uint8(mInfo2.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo2.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.startPrank(member3);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m3BalanceBefore = paymentToken.balanceOf(member3);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member3, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m3BalanceAfter = paymentToken.balanceOf(member3);
        assertEq(m3BalanceBefore, m3BalanceAfter + joinFee);
        mInfo3 = tandaPay.getMemberToMemberInfo(member3, 0);
        assertEq(joinFee, mInfo3.ISEscorwAmount);
        assertEq(mInfo3.associatedGroupId, gIdAfter1);
        assertEq(uint8(mInfo3.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo3.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.startPrank(member4);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m4BalanceBefore = paymentToken.balanceOf(member4);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member4, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m4BalanceAfter = paymentToken.balanceOf(member4);
        assertEq(m4BalanceBefore, m4BalanceAfter + joinFee);
        mInfo4 = tandaPay.getMemberToMemberInfo(member4, 0);
        assertEq(joinFee, mInfo4.ISEscorwAmount);
        assertEq(mInfo4.associatedGroupId, gIdAfter1);
        assertEq(uint8(mInfo4.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo4.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.startPrank(member5);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m5BalanceBefore = paymentToken.balanceOf(member5);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member5, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m5BalanceAfter = paymentToken.balanceOf(member5);
        assertEq(m5BalanceBefore, m5BalanceAfter + joinFee);
        mInfo5 = tandaPay.getMemberToMemberInfo(member5, 0);
        assertEq(joinFee, mInfo5.ISEscorwAmount);
        assertEq(mInfo5.associatedGroupId, gIdAfter2);
        assertEq(uint8(mInfo5.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo5.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.startPrank(member6);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m6BalanceBefore = paymentToken.balanceOf(member6);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member6, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m6BalanceAfter = paymentToken.balanceOf(member6);
        assertEq(m6BalanceBefore, m6BalanceAfter + joinFee);
        mInfo6 = tandaPay.getMemberToMemberInfo(member6, 0);
        assertEq(joinFee, mInfo6.ISEscorwAmount);
        assertEq(mInfo6.associatedGroupId, gIdAfter2);
        assertEq(uint8(mInfo6.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo6.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.startPrank(member7);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m7BalanceBefore = paymentToken.balanceOf(member7);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member7, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m7BalanceAfter = paymentToken.balanceOf(member7);
        assertEq(m7BalanceBefore, m7BalanceAfter + joinFee);
        mInfo7 = tandaPay.getMemberToMemberInfo(member7, 0);
        assertEq(joinFee, mInfo7.ISEscorwAmount);
        assertEq(mInfo7.associatedGroupId, gIdAfter2);
        assertEq(uint8(mInfo7.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo7.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.startPrank(member8);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m8BalanceBefore = paymentToken.balanceOf(member8);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member8, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m8BalanceAfter = paymentToken.balanceOf(member8);
        assertEq(m8BalanceBefore, m8BalanceAfter + joinFee);
        mInfo8 = tandaPay.getMemberToMemberInfo(member8, 0);
        assertEq(joinFee, mInfo8.ISEscorwAmount);
        assertEq(mInfo8.associatedGroupId, gIdAfter2);
        assertEq(uint8(mInfo8.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo8.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.startPrank(member9);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m9BalanceBefore = paymentToken.balanceOf(member9);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member9, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m9BalanceAfter = paymentToken.balanceOf(member9);
        assertEq(m9BalanceBefore, m9BalanceAfter + joinFee);
        mInfo9 = tandaPay.getMemberToMemberInfo(member9, 0);
        assertEq(joinFee, mInfo9.ISEscorwAmount);
        assertEq(mInfo9.associatedGroupId, gIdAfter3);
        assertEq(uint8(mInfo9.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo9.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.startPrank(member10);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m10BalanceBefore = paymentToken.balanceOf(member10);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member10, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m10BalanceAfter = paymentToken.balanceOf(member10);
        assertEq(m10BalanceBefore, m10BalanceAfter + joinFee);
        mInfo10 = tandaPay.getMemberToMemberInfo(member10, 0);
        assertEq(joinFee, mInfo10.ISEscorwAmount);
        assertEq(mInfo10.associatedGroupId, gIdAfter3);
        assertEq(uint8(mInfo10.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo10.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.startPrank(member11);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m11BalanceBefore = paymentToken.balanceOf(member11);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member11, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m11BalanceAfter = paymentToken.balanceOf(member11);
        assertEq(m11BalanceBefore, m11BalanceAfter + joinFee);
        mInfo11 = tandaPay.getMemberToMemberInfo(member11, 0);
        assertEq(joinFee, mInfo11.ISEscorwAmount);
        assertEq(mInfo11.associatedGroupId, gIdAfter3);
        assertEq(uint8(mInfo11.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo11.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
        vm.startPrank(member12);
        paymentToken.approve(address(tandaPay), 1000e18);
        uint256 m12BalanceBefore = paymentToken.balanceOf(member12);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.JoinedToCommunity(member12, joinFee);
        tandaPay.joinToCommunity();
        vm.stopPrank();
        uint256 m12BalanceAfter = paymentToken.balanceOf(member12);
        assertEq(m12BalanceBefore, m12BalanceAfter + joinFee);
        mInfo12 = tandaPay.getMemberToMemberInfo(member12, 0);
        assertEq(joinFee, mInfo12.ISEscorwAmount);
        assertEq(mInfo12.associatedGroupId, gIdAfter3);
        assertEq(uint8(mInfo12.status), uint8(TandaPayEvents.MemberStatus.New));
        assertEq(
            uint8(mInfo12.assignment),
            uint8(TandaPay.AssignmentStatus.ApprovedByMember)
        );
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
        vm.startPrank(member1);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.PremiumPaid(
            member1,
            currentPeriodIdAfter,
            basePremium + (pFee - mInfo1.ISEscorwAmount),
            false
        );
        tandaPay.payPremium(false);
        mInfo1 = tandaPay.getMemberToMemberInfo(
            member1,
            currentPeriodIdAfter + 1
        );
        assertTrue(mInfo1.eligibleForCoverageInPeriod);
        assertTrue(mInfo1.isPremiumPaid);
        assertEq(mInfo1.cEscrowAmount, basePremium);
        assertEq(mInfo1.ISEscorwAmount, pFee);
        vm.stopPrank();
        vm.startPrank(member2);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.PremiumPaid(
            member2,
            currentPeriodIdAfter,
            basePremium + (pFee - mInfo2.ISEscorwAmount),
            false
        );
        tandaPay.payPremium(false);
        mInfo2 = tandaPay.getMemberToMemberInfo(
            member2,
            currentPeriodIdAfter + 1
        );
        assertTrue(mInfo2.eligibleForCoverageInPeriod);
        assertTrue(mInfo2.isPremiumPaid);
        assertEq(mInfo2.cEscrowAmount, basePremium);
        assertEq(mInfo2.ISEscorwAmount, pFee);
        vm.stopPrank();
        vm.startPrank(member3);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.PremiumPaid(
            member3,
            currentPeriodIdAfter,
            basePremium + (pFee - mInfo3.ISEscorwAmount),
            false
        );
        tandaPay.payPremium(false);
        mInfo3 = tandaPay.getMemberToMemberInfo(
            member3,
            currentPeriodIdAfter + 1
        );
        assertTrue(mInfo3.eligibleForCoverageInPeriod);
        assertTrue(mInfo3.isPremiumPaid);
        assertEq(mInfo3.cEscrowAmount, basePremium);
        assertEq(mInfo3.ISEscorwAmount, pFee);
        vm.stopPrank();
        vm.startPrank(member4);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.PremiumPaid(
            member4,
            currentPeriodIdAfter,
            basePremium + (pFee - mInfo4.ISEscorwAmount),
            false
        );
        tandaPay.payPremium(false);
        mInfo4 = tandaPay.getMemberToMemberInfo(
            member4,
            currentPeriodIdAfter + 1
        );
        assertTrue(mInfo4.eligibleForCoverageInPeriod);
        assertTrue(mInfo4.isPremiumPaid);
        assertEq(mInfo4.cEscrowAmount, basePremium);
        assertEq(mInfo4.ISEscorwAmount, pFee);
        vm.stopPrank();
        vm.startPrank(member5);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.PremiumPaid(
            member5,
            currentPeriodIdAfter,
            basePremium + (pFee - mInfo5.ISEscorwAmount),
            false
        );
        tandaPay.payPremium(false);
        mInfo5 = tandaPay.getMemberToMemberInfo(
            member5,
            currentPeriodIdAfter + 1
        );
        assertTrue(mInfo5.eligibleForCoverageInPeriod);
        assertTrue(mInfo5.isPremiumPaid);
        assertEq(mInfo5.cEscrowAmount, basePremium);
        assertEq(mInfo5.ISEscorwAmount, pFee);
        vm.stopPrank();
        vm.startPrank(member6);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.PremiumPaid(
            member6,
            currentPeriodIdAfter,
            basePremium + (pFee - mInfo6.ISEscorwAmount),
            false
        );
        tandaPay.payPremium(false);
        mInfo6 = tandaPay.getMemberToMemberInfo(
            member6,
            currentPeriodIdAfter + 1
        );
        assertTrue(mInfo6.eligibleForCoverageInPeriod);
        assertTrue(mInfo6.isPremiumPaid);
        assertEq(mInfo6.cEscrowAmount, basePremium);
        assertEq(mInfo6.ISEscorwAmount, pFee);
        vm.stopPrank();
        vm.startPrank(member7);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.PremiumPaid(
            member7,
            currentPeriodIdAfter,
            basePremium + (pFee - mInfo7.ISEscorwAmount),
            false
        );
        tandaPay.payPremium(false);
        mInfo7 = tandaPay.getMemberToMemberInfo(
            member7,
            currentPeriodIdAfter + 1
        );
        assertTrue(mInfo7.eligibleForCoverageInPeriod);
        assertTrue(mInfo7.isPremiumPaid);
        assertEq(mInfo7.cEscrowAmount, basePremium);
        assertEq(mInfo7.ISEscorwAmount, pFee);
        vm.stopPrank();
        vm.startPrank(member8);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.PremiumPaid(
            member8,
            currentPeriodIdAfter,
            basePremium + (pFee - mInfo8.ISEscorwAmount),
            false
        );
        tandaPay.payPremium(false);
        mInfo8 = tandaPay.getMemberToMemberInfo(
            member8,
            currentPeriodIdAfter + 1
        );
        assertTrue(mInfo8.eligibleForCoverageInPeriod);
        assertTrue(mInfo8.isPremiumPaid);
        assertEq(mInfo8.cEscrowAmount, basePremium);
        assertEq(mInfo8.ISEscorwAmount, pFee);
        vm.stopPrank();
        vm.startPrank(member9);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.PremiumPaid(
            member9,
            currentPeriodIdAfter,
            basePremium + (pFee - mInfo9.ISEscorwAmount),
            false
        );
        tandaPay.payPremium(false);
        mInfo9 = tandaPay.getMemberToMemberInfo(
            member9,
            currentPeriodIdAfter + 1
        );
        assertTrue(mInfo9.eligibleForCoverageInPeriod);
        assertTrue(mInfo9.isPremiumPaid);
        assertEq(mInfo9.cEscrowAmount, basePremium);
        assertEq(mInfo9.ISEscorwAmount, pFee);
        vm.stopPrank();
        vm.startPrank(member10);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.PremiumPaid(
            member10,
            currentPeriodIdAfter,
            basePremium + (pFee - mInfo10.ISEscorwAmount),
            false
        );
        tandaPay.payPremium(false);
        mInfo10 = tandaPay.getMemberToMemberInfo(
            member10,
            currentPeriodIdAfter + 1
        );
        assertTrue(mInfo10.eligibleForCoverageInPeriod);
        assertTrue(mInfo10.isPremiumPaid);
        assertEq(mInfo10.cEscrowAmount, basePremium);
        assertEq(mInfo10.ISEscorwAmount, pFee);
        vm.stopPrank();
        vm.startPrank(member11);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.PremiumPaid(
            member11,
            currentPeriodIdAfter,
            basePremium + (pFee - mInfo11.ISEscorwAmount),
            false
        );
        tandaPay.payPremium(false);
        mInfo11 = tandaPay.getMemberToMemberInfo(
            member11,
            currentPeriodIdAfter + 1
        );
        assertTrue(mInfo11.eligibleForCoverageInPeriod);
        assertTrue(mInfo11.isPremiumPaid);
        assertEq(mInfo11.cEscrowAmount, basePremium);
        assertEq(mInfo11.ISEscorwAmount, pFee);
        vm.stopPrank();
        vm.startPrank(member12);
        vm.expectEmit(address(tandaPay));
        emit TandaPayEvents.PremiumPaid(
            member12,
            currentPeriodIdAfter,
            basePremium + (pFee - mInfo12.ISEscorwAmount),
            false
        );
        tandaPay.payPremium(false);
        mInfo12 = tandaPay.getMemberToMemberInfo(
            member12,
            currentPeriodIdAfter + 1
        );
        assertTrue(mInfo12.eligibleForCoverageInPeriod);
        assertTrue(mInfo12.isPremiumPaid);
        assertEq(mInfo12.cEscrowAmount, basePremium);
        assertEq(mInfo12.ISEscorwAmount, pFee);
        vm.stopPrank();
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
        mInfo1 = tandaPay.getMemberToMemberInfo(member1, 0);
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

        sInfo3 = tandaPay.getSubGroupIdToSubGroupInfo(gIdAfter3);
        assertEq(sInfo3.id, gIdAfter3);
        bool isIn1Again;
        for (uint256 i = 0; i < sInfo3.members.length; i++) {
            if (sInfo3.members[i] == member1) {
                isIn1 = true;
            }
        }
        assertTrue(isIn1Again);
        assertEq(sInfo3.members.length, 5);
        assertTrue(sInfo3.isValid);
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

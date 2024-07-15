// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract ReentrancyGuard {
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        _status = NOT_ENTERED;
    }

    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}

abstract contract Secretary is Context {
    address internal _secretary;
    address[] internal secretarySuccessors;
    address internal upcomingSecretary;
    address[2] internal _emergencySecretaries;
    bool internal isHandingOver;
    uint256 internal emergencyHandOverStartedPeriod;
    uint256 internal handoverStartedAt;
    uint256 internal emergencyHandoverStartedAt;
    error SecretaryUnauthorizedSecretary(address account);
    error SecretaryInvalidOwner(address owner);
    event SecretaryTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor(address initialSecretary) {
        if (initialSecretary == address(0)) {
            revert SecretaryInvalidOwner(address(0));
        }
        _transferSecretary(initialSecretary);
    }

    // modifier onlySecretary() {
    //     _checkOwner();
    //     _;
    // }
    modifier onlySecretary() {
        _checkSecretary();
        _;
    }

    function secretary() public view virtual returns (address) {
        return _secretary;
    }

    function getSecretarySuccessors() public view returns (address[] memory) {
        return secretarySuccessors;
    }

    function getUpcomingSecretary() public view returns (address) {
        return upcomingSecretary;
    }

    function getEmergencySecretaries() public view returns (address[2] memory) {
        return _emergencySecretaries;
    }

    function getIsHandingOver() public view returns (bool) {
        return isHandingOver;
    }

    function getEmergencyHandOverStartedPeriod() public view returns (uint256) {
        return emergencyHandOverStartedPeriod;
    }

    function getHandoverStartedAt() public view returns (uint256) {
        return handoverStartedAt;
    }

    function getEmergencyHandoverStartedAt() public view returns (uint256) {
        return emergencyHandoverStartedAt;
    }
    function _checkSecretary() internal view virtual {
        if (secretary() != _msgSender()) {
            revert SecretaryUnauthorizedSecretary(_msgSender());
        }
    }

    function _transferSecretary(address newSecretary) internal virtual {
        address oldOwner = _secretary;
        _secretary = newSecretary;
        emit SecretaryTransferred(oldOwner, newSecretary);
    }
}

contract TandaPayEvents {
    enum MemberStatus {
        UnAssigned,
        Assigned,
        New,
        SAEPaid,
        VALID,
        PAID_INVALID,
        UNPAID_INVALID,
        REORGED,
        USER_LEFT,
        DEFECTED,
        USER_QUIT,
        REJECTEDBYGM
    }
    event ManualCollapsedCancelled(uint256 time);

    event MemberStatusUpdated(address member, MemberStatus newStatus);

    event LeavedFromGroup(address member, uint256 gId, uint256 mId);

    event AddedToCommunity(address member, uint256 id);

    event SubGroupCreated(uint256 id);

    event AssignedToSubGroup(address member, uint256 groupId, bool isReOrging);

    event JoinedToCommunity(address member, uint256 paidAmount);

    event FundInjected(uint256 amount);

    event DefaultStateInitiatedAndCoverageSet(uint256 coverage);

    event ManualCollapseCancelled();

    event ApprovedGroupAssignment(address member, uint256 groupId, bool joined);

    event ApproveNewGroupMember(
        address member,
        address approver,
        uint256 groupId,
        bool approved
    );

    event ExitedFromSubGroup(address member, uint256 groupId);

    event ClaimWhiteListed(uint256 cId);

    event MemberDefected(address member, uint256 periodId);

    event PremiumPaid(
        address member,
        uint256 periodId,
        uint256 amount,
        bool usingATW
    );

    event RefundIssued();

    event CoverageUpdated(uint256 coverage, uint256 basePremium);

    event SecretarySuccessorsDefined(address[] successors);

    event SecretaryHandOverEnabled(address prefferedSuccessr);

    event SecretaryAccepted(address nSecretary);

    event EmergencyhandOverSecretary(address secretary);

    event ClaimSubmitted(address member, uint256 claimId);

    event AdditionalDayAdded(uint256 pEndTime);

    event FundClaimed(address claimant, uint256 amount, uint256 cId);

    event RefundWithdrawn(address member, uint256 amount);

    event ShortFallDivided(
        uint256 totalAmount,
        uint256 pmAmount,
        uint256 fromSecrretary
    );

    event ManualCollapsedHappenend();

    event NextPeriodInitiated(
        uint256 periodId,
        uint256 coverage,
        uint256 baseAmount
    );
}

contract TandaPay is Secretary, ReentrancyGuard, TandaPayEvents {
    error NotInIniOrDef();
    error InvalidMember();
    error InvalidSubGroup();
    error NotReorged();
    error NotInDefOrFra();
    error NotWhitelistWindow();
    error ClaimantNotValidMember();
    error NotValidMember();
    error NotInCovereged();
    error ClaimNoOccured();
    error NotDefectWindow();
    error NotPayWindow();
    error NotHandingOver();
    error TimeNotPassed();
    error NotIncluded();
    error NotInSuccessorList();
    error SamePeriod();
    error NeedMoreSuccessor();
    error NotInInjectionWindow();
    error AlreadyAdded();
    error NoClaimOccured();
    error ManuallyCollapsed();
    error NotInManualCollaps();
    error PrevPeriodNotEnded();
    error NotPaidInvalid();
    error AlreadySet();
    error NotRefundWindow();
    error AmountZero();
    error NotClaimant();
    error NotWhiteListed();
    error AlreadyClaimed();
    error NotClaimWindow();
    error CoverageFullfilled();
    error DelayInitiated();
    error NotInInitilization();
    error DFNotMet();
    error NotInInDefault();
    error TurningTimePassed();
    error AlreadySubmitted();
    error SGMNotFullfilled();
    error OutOfTheCommunity();
    error NotAssignedYet();
    error NotInAssigned();
    error NotInAssignmentSuccessfull();
    error NoVerifiedMember();
    error InValidClaim();
    error NotFirstSuccessor();

    IERC20 private paymentToken;
    uint256 private memberId;
    uint256 private subGroupId;
    uint256 private claimId;
    uint256 private periodId;
    uint256 private totalCoverage;
    uint256 private basePremium;
    // uint256 private minimumSavingAccountBalance;
    bool private isManuallyCollapsed;
    uint256 private manuallyCollapsedPeriod;
    uint256 private daysInSeconds = 1 days;
    CommunityStates private communityStates;
    mapping(uint256 => uint256[]) private periodIdWhiteListedClaims;
    mapping(uint256 => MemberInfo) private memberIdToMemberInfo;
    mapping(uint256 => SubGroupInfo) private subGroupIdToSubGroupInfo;
    mapping(uint256 => mapping(uint256 => ClaimInfo))
        private periodIdToClaimIdToClaimInfo;
    mapping(uint256 => uint256[]) private periodIdToClaimIds;
    // mapping(uint256 => address[]) private subGroupIdToApplicants;
    mapping(address => uint256) private memberToMemberId;
    mapping(uint256 => PeriodInfo) private periodIdToPeriodInfo;
    mapping(uint256 => bool) private isAMemberDefectedInPeriod;
    mapping(uint256 => bool) private isAllMemberNotPaidInPeriod;
    mapping(uint256 => uint256[]) private periodIdToDefectorsId;
    mapping(uint256 => ManualCollapse) private periodIdToManualCollapse;
    mapping(address => mapping(uint256 => uint256))
        private memberAndPeriodIdToClaimId;

    enum CommunityStates {
        INITIALIZATION,
        DEFAULT,
        FRACTURED,
        COLLAPSED
    }

    // enum MemberStatus {
    //     Assigned,
    //     New,
    //     SAEPaid,
    //     VALID,
    //     PAID_INVALID,
    //     UNPAID_INVALID,
    //     REORGED,
    //     USER_LEFT,
    //     DEFECTED,
    //     USER_QUIT,
    //     REJECTEDBYGM
    // }

    enum AssignmentStatus {
        AddedBySecretery,
        AssignedToGroup,
        ApprovedByMember,
        ApprovedByGroupMember,
        AssignmentSuccessfull,
        CancelledByMember,
        CancelledGMember
    }

    struct DemoMemberInfo {
        uint256 memberId;
        uint256 associatedGroupId;
        address member;
        uint256 cEscrowAmount;
        uint256 ISEscorwAmount;
        uint256 pendingRefundAmount;
        uint256 availableToWithdraw;
        bool eligibleForCoverageInPeriod;
        bool isPremiumPaid;
        uint256 idToQuedRefundAmount;
        MemberStatus status;
        AssignmentStatus assignment;
    }

    struct MemberInfo {
        uint256 memberId;
        uint256 associatedGroupId;
        address member;
        uint256 cEscrowAmount;
        // uint256 PPCEscrowAmount;
        uint256 ISEscorwAmount;
        uint256 pendingRefundAmount;
        uint256 availableToWithdraw;
        mapping(uint256 => bool) eligibleForCoverageInPeriod;
        mapping(uint256 => bool) isPremiumPaid;
        mapping(uint256 => uint256) idToQuedRefundAmount;
        MemberStatus status;
        AssignmentStatus assignment;
    }

    struct SubGroupInfo {
        uint256 id;
        address[] members;
        // uint256 memberCount;
        // uint256 defected;
        bool isValid;
    }

    struct ClaimInfo {
        uint256 id;
        address claimant;
        uint256 claimAmount;
        uint256 SGId;
        bool isWhitelistd;
        bool isClaimed;
    }

    struct PeriodInfo {
        uint256 startedAt;
        uint256 willEndAt;
        uint256[] claimIds;
        uint256 coverage;
        uint256 totalPaid;
    }
    struct ManualCollapse {
        uint256 startedAT;
        uint256 availableToTurnTill;
    }

    constructor(address _paymentToken) Secretary(msg.sender) {
        paymentToken = IERC20(_paymentToken);
        communityStates = CommunityStates.INITIALIZATION;
    }

    function addToCommunity(address _member) public onlySecretary {
        if (
            communityStates != CommunityStates.INITIALIZATION &&
            communityStates != CommunityStates.DEFAULT
        ) {
            revert NotInIniOrDef();
        }
        if (memberToMemberId[_member] != 0) {
            revert AlreadyAdded();
        }
        memberId++;
        MemberInfo storage mInfo = memberIdToMemberInfo[memberId];
        mInfo.memberId = memberId;
        memberToMemberId[_member] = mInfo.memberId;
        mInfo.member = _member;
        mInfo.status = MemberStatus.Assigned;
        mInfo.assignment = AssignmentStatus.AddedBySecretery;
        emit AddedToCommunity(_member, memberId);
    }

    function createSubGroup() public onlySecretary {
        subGroupId++;
        SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[subGroupId];
        sInfo.id = subGroupId;
        emit SubGroupCreated(subGroupId);
    }

    function assignToSubGroup(
        address _member,
        uint256 _sId,
        bool _isReorging
    ) public onlySecretary {
        SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[_sId];
        MemberInfo storage mInfo = memberIdToMemberInfo[
            memberToMemberId[_member]
        ];

        if (sInfo.id == 0) {
            revert InvalidSubGroup();
        }

        if (mInfo.member == address(0)) {
            revert InvalidMember();
        }
        sInfo.members.push(mInfo.member);
        if (_isReorging) {
            if (mInfo.status != MemberStatus.PAID_INVALID) {
                revert NotPaidInvalid();
            }
            mInfo.status = MemberStatus.REORGED;
        } else {
            mInfo.assignment = AssignmentStatus.AssignedToGroup;
        }
        mInfo.associatedGroupId = _sId;
        if (sInfo.members.length >= 4 && sInfo.members.length <= 7) {
            if (!sInfo.isValid) {
                sInfo.isValid = true;
            }
        } else {
            if (sInfo.isValid) {
                sInfo.isValid = false;
            }
        }

        emit AssignedToSubGroup(_member, _sId, _isReorging);
    }

    function joinToCommunity() public {
        if (communityStates != CommunityStates.DEFAULT) {
            revert NotInInDefault();
        }

        MemberInfo storage mInfo = memberIdToMemberInfo[
            memberToMemberId[msg.sender]
        ];
        if (mInfo.status != MemberStatus.Assigned) {
            revert NotInAssigned();
        }
        uint256 saAmount = basePremium + ((basePremium * 20) / 100);
        uint256 joinFee = (saAmount * 11) / 12;
        paymentToken.transferFrom(msg.sender, address(this), joinFee);
        mInfo.ISEscorwAmount += joinFee;
        mInfo.status = MemberStatus.New;
        mInfo.assignment = AssignmentStatus.ApprovedByMember;
        emit JoinedToCommunity(mInfo.member, (saAmount * 11) / 12);
    }

    function initiatDefaultStateAndSetCoverage(
        uint256 _coverage
    ) public onlySecretary {
        if (communityStates != CommunityStates.INITIALIZATION) {
            revert NotInInitilization();
        }
        if (memberId < 12 || subGroupId < 3) {
            revert DFNotMet();
        }
        for (uint256 i = 1; i < 4; i++) {
            if (subGroupIdToSubGroupInfo[i].members.length < 4) {
                revert SGMNotFullfilled();
            }
        }
        communityStates = CommunityStates.DEFAULT;
        totalCoverage = _coverage;
        basePremium = totalCoverage / memberId;
        emit DefaultStateInitiatedAndCoverageSet(_coverage);
    }

    function approveSubGroupAssignment(bool _shouldJoin) public {
        MemberInfo storage mInfo = memberIdToMemberInfo[
            memberToMemberId[msg.sender]
        ];
        if (mInfo.associatedGroupId == 0) {
            revert NotAssignedYet();
        }

        SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[
            mInfo.associatedGroupId
        ];

        if (_shouldJoin) {
            if (mInfo.status == MemberStatus.REORGED) {
                mInfo.assignment = AssignmentStatus.ApprovedByMember;
            } else {
                // mInfo.status = MemberStatus.New;
                mInfo.assignment = AssignmentStatus.AssignmentSuccessfull;
            }
        } else {
            uint256 index;
            for (uint256 i = 0; i < sInfo.members.length; i++) {
                if (sInfo.members[i] == msg.sender) {
                    index = i;
                }
            }
            sInfo.members[index] = sInfo.members[sInfo.members.length - 1];
            sInfo.members.pop();
            memberIdToMemberInfo[memberToMemberId[msg.sender]]
                .status = MemberStatus.USER_QUIT;
        }

        emit ApprovedGroupAssignment(
            msg.sender,
            mInfo.associatedGroupId,
            _shouldJoin
        );
    }

    function approveNewSubgroupMember(
        uint256 _sId,
        uint256 _nMemberId,
        bool _accepted
    ) public {
        SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[_sId];
        MemberInfo storage mInfo = memberIdToMemberInfo[_nMemberId];
        if (mInfo.status != MemberStatus.REORGED) {
            revert NotReorged();
        }
        bool isIn;
        for (uint256 j = 0; j < sInfo.members.length; j++) {
            if (msg.sender == sInfo.members[j]) {
                isIn = true;
                break;
            }
        }
        if (!isIn) {
            revert NotIncluded();
        }
        if (_accepted) {
            mInfo.status = MemberStatus.VALID;
            mInfo.assignment = AssignmentStatus.AssignmentSuccessfull;
        } else {
            mInfo.assignment = AssignmentStatus.CancelledGMember;
        }
        emit ApproveNewGroupMember(mInfo.member, msg.sender, _sId, _accepted);
    }

    function exitSubGroup() public {
        MemberInfo storage mInfo = memberIdToMemberInfo[
            memberToMemberId[msg.sender]
        ];
        if (mInfo.associatedGroupId == 0) {
            revert NotAssignedYet();
        }
        SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[
            mInfo.associatedGroupId
        ];
        bool isIn;
        for (uint256 j = 0; j < sInfo.members.length; j++) {
            if (msg.sender == sInfo.members[j]) {
                isIn = true;
                break;
            }
        }
        if (!isIn) {
            revert NotIncluded();
        }
        uint256 index;
        for (uint256 i = 0; i < sInfo.members.length; i++) {
            if (msg.sender == sInfo.members[i]) {
                index = i;
            }
        }
        sInfo.members[index] = sInfo.members[sInfo.members.length - 1];
        sInfo.members.pop();
        if (mInfo.isPremiumPaid[periodId]) {
            mInfo.status = MemberStatus.PAID_INVALID;
        } else {
            mInfo.status = MemberStatus.UNPAID_INVALID;
        }
        mInfo.associatedGroupId = 0;
        if (sInfo.members.length < 4) {
            sInfo.isValid = false;
            for (uint256 i = 0; i < sInfo.members.length; i++) {
                memberIdToMemberInfo[memberToMemberId[sInfo.members[i]]]
                    .status = MemberStatus.PAID_INVALID;
            }
        }
        emit ExitedFromSubGroup(mInfo.member, sInfo.id);
    }

    function whitelistClaim(uint256 _cId) public onlySecretary {
        if (
            communityStates != CommunityStates.DEFAULT &&
            communityStates != CommunityStates.FRACTURED
        ) {
            revert NotInDefOrFra();
        }
        if (
            block.timestamp >
            periodIdToPeriodInfo[periodId].startedAt + (15 * daysInSeconds) ||
            block.timestamp < periodIdToPeriodInfo[periodId].startedAt
        ) {
            revert NotWhitelistWindow();
        }
        ClaimInfo storage cInfo = periodIdToClaimIdToClaimInfo[periodId][_cId];
        if (cInfo.id != _cId) {
            revert InValidClaim();
        }
        if (
            memberIdToMemberInfo[memberToMemberId[cInfo.claimant]].status !=
            MemberStatus.VALID ||
            !memberIdToMemberInfo[memberToMemberId[cInfo.claimant]]
                .eligibleForCoverageInPeriod[periodId]
        ) {
            revert ClaimantNotValidMember();
        }
        cInfo.isWhitelistd = true;
        periodIdWhiteListedClaims[periodId].push(cInfo.id);

        emit ClaimWhiteListed(_cId);
    }

    function defects() public {
        MemberInfo storage mInfo = memberIdToMemberInfo[
            memberToMemberId[msg.sender]
        ];
        SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[
            mInfo.associatedGroupId
        ];

        if (mInfo.member == address(0)) {
            revert NotValidMember();
        }

        if (
            block.timestamp >
            periodIdToPeriodInfo[periodId].startedAt + (3 * daysInSeconds) ||
            block.timestamp < periodIdToPeriodInfo[periodId].startedAt
        ) {
            revert NotDefectWindow();
        }

        // if (periodIdToClaimIdToClaimInfo[periodId][_cId].SGId != sInfo.id) {
        //     revert ClaimNoOccured();
        // }
        if (periodIdToClaimIds[periodId - 1].length <= 0) {
            revert ClaimNoOccured();
        }

        if (!mInfo.eligibleForCoverageInPeriod[periodId]) {
            mInfo.status = MemberStatus.USER_QUIT;
        } else {
            mInfo.status = MemberStatus.DEFECTED;
            uint256 index;
            for (uint256 i = 0; i < sInfo.members.length; i++) {
                if (msg.sender == sInfo.members[i]) {
                    index = i;
                }
            }
            sInfo.members[index] = sInfo.members[sInfo.members.length - 1];
            sInfo.members.pop();
            mInfo.associatedGroupId = 0;
            periodIdToDefectorsId[periodId].push(mInfo.memberId);
        }
        mInfo.pendingRefundAmount = mInfo.cEscrowAmount + mInfo.ISEscorwAmount;
        mInfo.cEscrowAmount = 0;
        mInfo.ISEscorwAmount = 0;
        if (communityStates == CommunityStates.DEFAULT) {
            uint256 DMCount;
            for (uint256 i = 1; i < memberId + 1; i++) {
                MemberInfo storage mInfo2 = memberIdToMemberInfo[i];
                if (mInfo2.status == MemberStatus.DEFECTED) {
                    DMCount++;
                }
            }
            if (DMCount > ((memberId * 12) / 100)) {
                communityStates = CommunityStates.FRACTURED;
            }
        }
        mInfo.eligibleForCoverageInPeriod[periodId] = false;
        if (!isAMemberDefectedInPeriod[periodId]) {
            isAMemberDefectedInPeriod[periodId] = true;
        }
        emit MemberDefected(msg.sender, periodId);
    }

    function payPremium(bool _useFromATW) public {
        // if (communityStates != CommunityStates.DEFAULT) {
        //     revert NotInInDefault();
        // }
        if (
            // communityStates != CommunityStates.INITIALIZATION &&
            communityStates != CommunityStates.DEFAULT &&
            communityStates != CommunityStates.FRACTURED
        ) {
            revert NotInDefOrFra();
        }
        if (isManuallyCollapsed) {
            revert ManuallyCollapsed();
        }
        if (periodId > 0) {
            if (
                block.timestamp <
                periodIdToPeriodInfo[periodId].startedAt +
                    (27 * daysInSeconds) ||
                block.timestamp > periodIdToPeriodInfo[periodId].willEndAt
            ) {
                revert NotPayWindow();
            }
        }
        PeriodInfo storage pInfo = periodIdToPeriodInfo[periodId + 1];
        MemberInfo storage mInfo = memberIdToMemberInfo[
            memberToMemberId[msg.sender]
        ];
        if (mInfo.member == address(0)) {
            revert NotValidMember();
        }
        if (
            mInfo.assignment != TandaPay.AssignmentStatus.AssignmentSuccessfull
        ) {
            revert NotInAssignmentSuccessfull();
        }
        if (
            mInfo.status == MemberStatus.DEFECTED ||
            mInfo.status == MemberStatus.USER_QUIT
        ) {
            revert OutOfTheCommunity();
        }
        // SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[
        //     mInfo.associatedGroupId
        // ];
        uint256 amountToPay = basePremium;
        uint256 saAmount = basePremium + ((basePremium * 20) / 100);
        // uint256 saAmount = ((basePremium * 20) / 100);
        // if (mInfo.status == MemberStatus.New) {
        //     amountToPay = (saAmount * 11) / 12;
        // } else {
        // amountToPay = basePremium;
        if (mInfo.ISEscorwAmount < saAmount) {
            amountToPay += saAmount - mInfo.ISEscorwAmount;
        }
        // }

        pInfo.totalPaid += amountToPay;
        if (_useFromATW) {
            uint256 atwAmount = mInfo.availableToWithdraw;
            mInfo.availableToWithdraw = atwAmount > amountToPay
                ? atwAmount - amountToPay
                : 0;
            amountToPay = atwAmount > amountToPay ? 0 : amountToPay - atwAmount;
        }
        if (amountToPay > 0) {
            paymentToken.transferFrom(msg.sender, address(this), amountToPay);
        }
        // if (mInfo.status == MemberStatus.New) {
        //     mInfo.ISEscorwAmount += amountToPay;
        // } else {
        // if (mInfo.cEscrowAmount > 0) {
        //     mInfo.PPCEscrowAmount = mInfo.cEscrowAmount;
        //     mInfo.cEscrowAmount = 0;
        // }
        mInfo.cEscrowAmount += basePremium;
        if (mInfo.ISEscorwAmount < saAmount) {
            mInfo.ISEscorwAmount += saAmount - mInfo.ISEscorwAmount;
        }
        // }
        // if (
        //     mInfo.status == MemberStatus.New &&
        //     mInfo.ISEscorwAmount > (saAmount * 11) / 12
        // ) {
        //     mInfo.status = MemberStatus.SAEPaid;
        // }
        if (
            (// mInfo.status == MemberStatus.SAEPaid ||
            mInfo.status == MemberStatus.New ||
                mInfo.status == MemberStatus.VALID ||
                mInfo.status == MemberStatus.UNPAID_INVALID) &&
            mInfo.cEscrowAmount >= basePremium &&
            mInfo.ISEscorwAmount >= saAmount
        ) {
            if (mInfo.status != MemberStatus.VALID) {
                mInfo.status = MemberStatus.VALID;
            }
            mInfo.eligibleForCoverageInPeriod[periodId + 1] = true;
            mInfo.isPremiumPaid[periodId + 1] = true;
        }
        // if (
        //     mInfo.cEscrowAmount >= basePremium &&
        //     mInfo.ISEscorwAmount >= saAmount
        // ) {
        //     mInfo.isPremiumPaid[periodId] = true;
        // }
        emit PremiumPaid(msg.sender, periodId, amountToPay, _useFromATW);
    }

    function updateCoverageAmount(uint256 _coverage) public onlySecretary {
        if (
            communityStates != CommunityStates.INITIALIZATION &&
            communityStates != CommunityStates.DEFAULT
        ) {
            revert NotInIniOrDef();
        }
        if (totalCoverage != 0) {
            updateMemberStatus();
        }
        totalCoverage = _coverage;
        uint256 totalValidCount;
        for (uint256 i = 1; i < memberId + 1; i++) {
            if (memberIdToMemberInfo[i].status == MemberStatus.VALID) {
                totalValidCount++;
            }
        }
        basePremium = totalCoverage / totalValidCount;
        periodIdToPeriodInfo[periodId].coverage = totalCoverage;
        // minimumSavingAccountBalance = basePremium + ((basePremium * 20) / 100);
        emit CoverageUpdated(_coverage, basePremium);
    }

    function defineSecretarySuccessor(
        address[] memory _successors
    ) public onlySecretary {
        if (memberId >= 12 && memberId <= 35) {
            if (_successors.length < 2) {
                revert NeedMoreSuccessor();
            }
        } else if (memberId > 35) {
            if (_successors.length < 6) {
                revert NeedMoreSuccessor();
            }
        }

        for (uint256 i = 0; i < _successors.length; i++) {
            bool isIn;
            for (uint256 j = 1; j < memberId + 1; j++) {
                if (_successors[i] == memberIdToMemberInfo[j].member) {
                    isIn = true;
                    break;
                }
            }
            if (!isIn) {
                revert NotIncluded();
            }

            secretarySuccessors.push(_successors[i]);
        }

        emit SecretarySuccessorsDefined(_successors);
    }

    function handoverSecretary(
        address _prefferedSuccessor
    ) public onlySecretary {
        if (_prefferedSuccessor != address(0)) {
            bool isIn;
            for (uint256 j = 0; j < secretarySuccessors.length; j++) {
                if (_prefferedSuccessor == secretarySuccessors[j]) {
                    isIn = true;
                    break;
                }
            }
            if (!isIn) {
                revert NotIncluded();
            }
        }
        upcomingSecretary = _prefferedSuccessor;
        handoverStartedAt = block.timestamp;
        isHandingOver = true;

        emit SecretaryHandOverEnabled(_prefferedSuccessor);
    }

    function secretaryAcceptance() public {
        if (!isHandingOver) {
            revert NotHandingOver();
        }
        bool isIn;
        for (uint256 i = 0; i < secretarySuccessors.length; i++) {
            if (msg.sender == secretarySuccessors[i]) {
                isIn = true;
            }
        }
        if (!isIn) {
            revert NotIncluded();
        }
        isHandingOver = false;
        if (msg.sender == upcomingSecretary) {
            // _secretary = msg.sender;
            _transferSecretary(msg.sender);
            uint256 index;
            for (uint256 i = 0; i < secretarySuccessors.length; i++) {
                if (msg.sender == secretarySuccessors[i]) {
                    index = i;
                }
            }
            secretarySuccessors[index] = secretarySuccessors[
                secretarySuccessors.length - 1
            ];
            secretarySuccessors.pop();
        } else {
            if (
                upcomingSecretary != address(0) &&
                block.timestamp < handoverStartedAt + 24 hours
            ) {
                revert TimeNotPassed();
            }

            if (msg.sender == secretarySuccessors[0]) {
                // _secretary = secretarySuccessors[0];
                _transferSecretary(secretarySuccessors[0]);
                secretarySuccessors[0] = secretarySuccessors[
                    secretarySuccessors.length - 1
                ];
                secretarySuccessors.pop();
            } else {
                revert NotFirstSuccessor();
            }
        }
        emit SecretaryAccepted(msg.sender);
    }

    function emergencyHandOverSecretary(address _eSecretary) public {
        bool isIn;
        if (
            memberToMemberId[msg.sender] != 0 &&
            memberIdToMemberInfo[memberToMemberId[msg.sender]].status ==
            MemberStatus.VALID
        ) {
            isIn = true;
        }
        if (!isIn) {
            revert NotIncluded();
        }
        bool isInES;
        for (uint256 i = 0; i < secretarySuccessors.length; i++) {
            if (_eSecretary == secretarySuccessors[i]) {
                isInES = true;
            }
        }
        if (!isInES) {
            revert NotInSuccessorList();
        }

        if (
            _emergencySecretaries[0] == address(0) &&
            _emergencySecretaries[1] == address(0) &&
            emergencyHandOverStartedPeriod == periodId
        ) {
            revert SamePeriod();
        }
        if (_emergencySecretaries[0] == address(0)) {
            _emergencySecretaries[0] = _eSecretary;
            emergencyHandoverStartedAt = block.timestamp;
            emergencyHandOverStartedPeriod = periodId;
        } else {
            if (
                block.timestamp <
                emergencyHandoverStartedAt + (1 * daysInSeconds) &&
                emergencyHandOverStartedPeriod == periodId
            ) {
                _emergencySecretaries[1] = _eSecretary;
            } else {
                if (
                    block.timestamp >
                    emergencyHandoverStartedAt + (1 * daysInSeconds) &&
                    emergencyHandOverStartedPeriod != periodId
                ) {
                    _emergencySecretaries[0] = _eSecretary;
                    emergencyHandoverStartedAt = block.timestamp;
                    emergencyHandOverStartedPeriod = periodId;
                } else {
                    revert SamePeriod();
                }
            }
        }
        if (
            _emergencySecretaries[0] != address(0) &&
            _emergencySecretaries[1] != address(0)
        ) {
            uint256 index;
            if (_emergencySecretaries[0] == _emergencySecretaries[1]) {
                // upcomingSecretary = _emergencySecretaries[0];
                _secretary = _emergencySecretaries[0];

                for (uint256 i = 0; i < secretarySuccessors.length; i++) {
                    if (secretarySuccessors[i] == _emergencySecretaries[0]) {
                        index = i;
                    }
                }
            } else {
                _secretary = secretarySuccessors[0];
                index = 0;
            }
            // if (_emergencySecretaries[0] != _emergencySecretaries[1])
            // else {
            _emergencySecretaries[0] = address(0);
            _emergencySecretaries[1] = address(0);
            secretarySuccessors[index] = secretarySuccessors[
                secretarySuccessors.length - 1
            ];
            secretarySuccessors.pop();
            // }
        }
        emit EmergencyhandOverSecretary(_eSecretary);
    }

    function injectFunds() public onlySecretary {
        if (
            block.timestamp < periodIdToPeriodInfo[periodId].startedAt ||
            block.timestamp >
            periodIdToPeriodInfo[periodId].startedAt + (3 * daysInSeconds)
        ) {
            revert NotInInjectionWindow();
        }
        if (periodIdToPeriodInfo[periodId].claimIds.length <= 0) {
            revert NoClaimOccured();
        }
        PeriodInfo storage pInfo = periodIdToPeriodInfo[periodId];
        if (pInfo.totalPaid >= pInfo.coverage) {
            revert CoverageFullfilled();
        }

        uint256 sAmount = pInfo.coverage - pInfo.totalPaid;

        paymentToken.transferFrom(msg.sender, address(this), sAmount);
        pInfo.totalPaid += sAmount;

        emit FundInjected(sAmount);
    }

    function divideShortFall() public onlySecretary {
        if (
            block.timestamp < periodIdToPeriodInfo[periodId].startedAt ||
            block.timestamp >
            periodIdToPeriodInfo[periodId].startedAt + (3 * daysInSeconds)
        ) {
            revert NotInInjectionWindow();
        }
        if (periodIdToPeriodInfo[periodId].claimIds.length <= 0) {
            revert NoClaimOccured();
        }
        PeriodInfo storage pInfo = periodIdToPeriodInfo[periodId];
        if (pInfo.totalPaid >= pInfo.coverage) {
            revert CoverageFullfilled();
        }
        // if (periodIdToPeriodInfo[periodId].totalPaid > totalCoverage) {
        //     revert CoverageFullfilled();
        // }

        uint256 validMCount;
        uint256 mvAmount;
        for (uint256 i = 1; i < memberId + 1; i++) {
            MemberInfo storage mInfo = memberIdToMemberInfo[i];
            if (mInfo.status == MemberStatus.VALID) {
                validMCount++;
                if (mInfo.ISEscorwAmount > 0) {
                    if (mvAmount != 0 && mInfo.ISEscorwAmount < mvAmount) {
                        mvAmount = mInfo.ISEscorwAmount;
                    } else if (mvAmount == 0) {
                        mvAmount = mInfo.ISEscorwAmount;
                    }
                }
            }
        }
        uint256 sAmount = pInfo.coverage - pInfo.totalPaid;
        uint256 spMember = sAmount / validMCount < mvAmount
            ? sAmount / validMCount
            : mvAmount;
        if (spMember * validMCount < sAmount) {
            paymentToken.transferFrom(
                msg.sender,
                address(this),
                sAmount - (spMember * validMCount)
            );
        }
        for (uint256 j = 1; j < memberId + 1; j++) {
            MemberInfo storage mInfo = memberIdToMemberInfo[j];
            if (mInfo.status == MemberStatus.VALID) {
                if (mInfo.ISEscorwAmount >= spMember) {
                    mInfo.ISEscorwAmount -= spMember;
                }
            }
        }
        periodIdToPeriodInfo[periodId].totalPaid += sAmount;

        emit ShortFallDivided(
            sAmount,
            spMember,
            spMember * validMCount < sAmount
                ? sAmount - (spMember * validMCount)
                : 0
        );
    }

    function addAdditionalDay() public onlySecretary {
        periodIdToPeriodInfo[periodId].willEndAt =
            periodIdToPeriodInfo[periodId].willEndAt +
            (1 * daysInSeconds);
        emit AdditionalDayAdded(periodIdToPeriodInfo[periodId].willEndAt);
    }

    function manualCollapsBySecretary() public onlySecretary {
        if (
            periodIdToManualCollapse[manuallyCollapsedPeriod]
                .availableToTurnTill > block.timestamp
        ) {
            revert DelayInitiated();
        }
        isManuallyCollapsed = true;

        communityStates = CommunityStates.COLLAPSED;
        manuallyCollapsedPeriod = periodId;
        periodIdToManualCollapse[periodId].startedAT = block.timestamp;
        periodIdToManualCollapse[periodId].availableToTurnTill =
            periodIdToPeriodInfo[periodId].willEndAt +
            (4 * daysInSeconds);
        emit ManualCollapsedHappenend();
    }

    function cancelManualCollapsBySecretary() public onlySecretary {
        if (!isManuallyCollapsed) {
            revert NotInManualCollaps();
        }
        if (
            block.timestamp >
            periodIdToManualCollapse[manuallyCollapsedPeriod]
                .availableToTurnTill
        ) {
            revert TurningTimePassed();
        }
        isManuallyCollapsed = false;
        communityStates = CommunityStates.DEFAULT;

        emit ManualCollapsedCancelled(block.timestamp);
    }

    function leaveFromASubGroup() public {
        MemberInfo storage mInfo = memberIdToMemberInfo[
            memberToMemberId[msg.sender]
        ];
        SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[
            mInfo.associatedGroupId
        ];
        if (mInfo.member == address(0)) {
            revert NotValidMember();
        }
        mInfo.associatedGroupId = 0;
        mInfo.status = MemberStatus.PAID_INVALID;
        uint256 index;
        for (uint256 i = 0; i < sInfo.members.length; i++) {
            if (msg.sender == sInfo.members[i]) {
                index = i;
            }
        }
        sInfo.members[index] = sInfo.members[sInfo.members.length - 1];
        sInfo.members.pop();

        mInfo.status = MemberStatus.PAID_INVALID;
        mInfo.eligibleForCoverageInPeriod[periodId] = false;
        uint256 rAmount = mInfo.cEscrowAmount +
            // mInfo.PPCEscrowAmount +
            mInfo.ISEscorwAmount;
        mInfo.cEscrowAmount = 0;
        // mInfo.PPCEscrowAmount = 0;
        mInfo.ISEscorwAmount = 0;
        mInfo.availableToWithdraw = rAmount;
        if (sInfo.members.length < 4) {
            sInfo.isValid = false;
            for (uint256 i = 0; i < sInfo.members.length; i++) {
                MemberInfo storage mInfo2 = memberIdToMemberInfo[memberId];
                mInfo.status = MemberStatus.PAID_INVALID;
                uint256 rAmount2 = mInfo.cEscrowAmount +
                    // mInfo2.PPCEscrowAmount +
                    mInfo2.ISEscorwAmount;
                mInfo2.cEscrowAmount = 0;
                // mInfo2.PPCEscrowAmount = 0;
                mInfo2.ISEscorwAmount = 0;
                mInfo2.availableToWithdraw = rAmount2;
            }
        }
        emit LeavedFromGroup(mInfo.member, sInfo.id, mInfo.memberId);
    }

    function AdvanceToTheNextPeriod() public onlySecretary {
        if (
            communityStates != CommunityStates.DEFAULT &&
            communityStates != CommunityStates.FRACTURED
        ) {
            revert NotInDefOrFra();
        }
        if (
            periodId > 0 &&
            block.timestamp < periodIdToPeriodInfo[periodId].willEndAt
        ) {
            revert PrevPeriodNotEnded();
        }
        // if (periodId == 0) {
        //     _checkInitialUserPremiumPayment();
        // }
        // if (periodId > 1 && periodIdWhiteListedClaims[periodId].length <= 0) {
        //     _refundUnClaimedFund();
        // }

        periodId++;
        if (communityStates == CommunityStates.FRACTURED) {
            if (
                !isAMemberDefectedInPeriod[periodId - 1] &&
                !isAMemberDefectedInPeriod[periodId - 2] &&
                !isAMemberDefectedInPeriod[periodId - 3] &&
                !isAllMemberNotPaidInPeriod[periodId - 1] &&
                !isAllMemberNotPaidInPeriod[periodId - 2] &&
                !isAllMemberNotPaidInPeriod[periodId - 3]
            ) {
                communityStates = CommunityStates.DEFAULT;
            }
        }
        PeriodInfo storage pInfo = periodIdToPeriodInfo[periodId];
        pInfo.startedAt = block.timestamp;
        if (totalCoverage != 0) {
            // totalCoverage = _coverage;
            updateMemberStatus();
            for (uint256 i = 1; i < subGroupId + 1; i++) {
                SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[i];
                if (sInfo.members.length < 4) {
                    for (uint256 m = 0; m < sInfo.members.length; m++) {
                        MemberInfo storage mInfo = memberIdToMemberInfo[
                            memberToMemberId[sInfo.members[i]]
                        ];
                        if (mInfo.status == MemberStatus.VALID) {
                            // if(mInfo.isPremiumPaid[periodId]){
                            // mInfo.status = MemberStatus.PAID_INVALID;

                            // }else{
                            //     mInfo.status = MemberStatus.UNPAID_INVALID;
                            // }
                            mInfo.status = MemberStatus.USER_LEFT;
                            uint256 rAmount = mInfo.cEscrowAmount +
                                mInfo.ISEscorwAmount;
                            //  +
                            // mInfo.PPCEscrowAmount
                            mInfo.cEscrowAmount = 0;
                            mInfo.ISEscorwAmount = 0;
                            // mInfo.PPCEscrowAmount = 0;
                            mInfo.availableToWithdraw = rAmount;
                        }
                    }
                }
            }
            uint256 VMCount;
            for (uint256 i = 1; i < memberId + 1; i++) {
                if (memberIdToMemberInfo[i].status == MemberStatus.VALID) {
                    VMCount++;
                }
            }
            if (periodId > 1) {
                if (VMCount == 0) {
                    revert NoVerifiedMember();
                }
                basePremium = totalCoverage / VMCount;
            }
        }
        pInfo.willEndAt = block.timestamp + (30 * daysInSeconds);
        pInfo.coverage = totalCoverage;
        emit NextPeriodInitiated(periodId, totalCoverage, basePremium);
    }

    function updateMemberStatus() public onlySecretary {
        for (uint256 i = 1; i < memberId + 1; i++) {
            MemberInfo storage mInfo = memberIdToMemberInfo[i];
            // SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[
            //     mInfo.associatedGroupId
            // ];
            if (
                mInfo.status != MemberStatus.UnAssigned &&
                mInfo.status != MemberStatus.New &&
                mInfo.status != MemberStatus.Assigned
            ) {
                if (mInfo.isPremiumPaid[periodId]) {
                    mInfo.status = MemberStatus.VALID;

                    // if (sInfo.members.length < 4) {
                    //     mInfo.status = MemberStatus.PAID_INVALID;
                    //     uint256 rAmount = mInfo.cEscrowAmount +
                    //         mInfo.ISEscorwAmount
                    //         //  +
                    //         // mInfo.PPCEscrowAmount
                    //         ;
                    //     mInfo.cEscrowAmount = 0;
                    //     mInfo.ISEscorwAmount = 0;
                    //     // mInfo.PPCEscrowAmount = 0;
                    //     mInfo.availableToWithdraw = rAmount;
                    // }
                } else {
                    if (!isAllMemberNotPaidInPeriod[periodId - 1]) {
                        isAllMemberNotPaidInPeriod[periodId - 1] = true;
                    }
                }

                if (
                    communityStates == CommunityStates.DEFAULT &&
                    !mInfo.isPremiumPaid[periodId]
                ) {
                    mInfo.status = MemberStatus.UNPAID_INVALID;
                    mInfo.eligibleForCoverageInPeriod[periodId] = false;
                }
                // if (
                //     communityStates == CommunityStates.FRACTURED &&
                //     !mInfo.isPremiumPaid[periodId]
                // ) {
                //     mInfo.status = MemberStatus.USER_LEFT;
                // }
                if (
                    communityStates == CommunityStates.FRACTURED &&
                    !mInfo.isPremiumPaid[periodId]
                ) {
                    mInfo.status = MemberStatus.USER_LEFT;
                    mInfo.eligibleForCoverageInPeriod[periodId] = false;
                }
                emit MemberStatusUpdated(mInfo.member, mInfo.status);
            }
        }
    }

    // function _refundUnClaimedFund() internal {
    //     for (uint256 i = 1; i < memberId + 1; i++) {
    //         MemberInfo storage mInfo = memberIdToMemberInfo[i];
    //         if (
    //             // mInfo.status == MemberStatus.VALID &&
    //             mInfo.cEscrowAmount > 0
    //         ) {
    //             if (
    //                 communityStates == CommunityStates.FRACTURED &&
    //                 periodIdToClaimIds[periodId].length <= 0
    //             ) {
    //                 uint256 qrAmount = mInfo.cEscrowAmount;
    //                 mInfo.cEscrowAmount = 0;
    //                 mInfo.idToQuedRefundAmount[periodId] = qrAmount;
    //             } else {
    //                 uint256 uAmount = mInfo.cEscrowAmount;
    //                 mInfo.cEscrowAmount = 0;
    //                 mInfo.availableToWithdraw = uAmount;
    //             }
    //         }
    //     }
    // }
    function withdrawClaimFund() public nonReentrant {
        if (
            block.timestamp >
            periodIdToPeriodInfo[periodId].startedAt + (4 * daysInSeconds) ||
            block.timestamp <
            periodIdToPeriodInfo[periodId].startedAt + (3 * daysInSeconds)
        ) {
            revert NotClaimWindow();
        }
        uint256 prevPeriod = periodId - 1;
        ClaimInfo storage cInfo = periodIdToClaimIdToClaimInfo[prevPeriod][
            memberAndPeriodIdToClaimId[msg.sender][prevPeriod]
        ];
        if (msg.sender != cInfo.claimant) {
            revert NotClaimant();
        }
        if (!cInfo.isWhitelistd) {
            revert NotWhiteListed();
        }
        if (cInfo.isClaimed) {
            revert AlreadyClaimed();
        }
        cInfo.isClaimed = true;
        uint256[] memory __ids = periodIdToClaimIds[prevPeriod];
        uint256 wlCount;
        for (uint256 i = 0; i < __ids.length; i++) {
            if (
                periodIdToClaimIdToClaimInfo[prevPeriod][__ids[i]].isWhitelistd
            ) {
                wlCount++;
            }
        }
        uint256 cAmount = periodIdToPeriodInfo[prevPeriod].coverage / wlCount;
        uint256 totalClaimableAmount;
        uint256 VMCount;
        for (uint256 j = 1; j < memberId + 1; j++) {
            if (memberIdToMemberInfo[j].status == MemberStatus.VALID) {
                VMCount++;
            }
        }
        uint256[] memory _dids;
        if (isAMemberDefectedInPeriod[prevPeriod]) {
            _dids = periodIdToDefectorsId[prevPeriod];
            VMCount += _dids.length;
            // for (uint256 l = 0; l < _dids.length; l++) {
            //     VMCount++;

            // }
        }
        uint256 pmAmount = cAmount / VMCount;
        // uint256 dAmount;
        for (uint256 k = 1; k < memberId + 1; k++) {
            MemberInfo storage mInfo = memberIdToMemberInfo[k];
            if (mInfo.status == MemberStatus.VALID) {
                // if (mInfo.PPCEscrowAmount >= pmAmount) {
                //     mInfo.PPCEscrowAmount -= pmAmount;
                // } else {
                mInfo.cEscrowAmount -= pmAmount;
                // }
                totalClaimableAmount += pmAmount;
            }
        }
        if (_dids.length > 0) {
            for (uint256 i = 0; i < _dids.length; i++) {
                SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[
                    memberIdToMemberInfo[_dids[i]].associatedGroupId
                ];
                address[] memory __members = sInfo.members;
                uint256 vmInG;
                uint256 minimumVMAmount;
                for (uint256 k = 0; k < __members.length; k++) {
                    MemberInfo storage mInfoG = memberIdToMemberInfo[
                        memberToMemberId[__members[k]]
                    ];
                    if (mInfoG.status == MemberStatus.VALID) {
                        vmInG++;
                        if (
                            minimumVMAmount != 0 &&
                            minimumVMAmount > mInfoG.ISEscorwAmount
                        ) {
                            minimumVMAmount = mInfoG.ISEscorwAmount;
                        }
                    }
                }
                uint256 ATDeduct = pmAmount / vmInG;
                // if(ATDeduct > minimumVMAmount){
                //     dAmount += pmAmount;

                // }
                for (uint256 m = 0; m < __members.length; m++) {
                    MemberInfo storage mInfo = memberIdToMemberInfo[
                        memberToMemberId[__members[m]]
                    ];
                    if (mInfo.status == MemberStatus.VALID) {
                        mInfo.ISEscorwAmount -= ATDeduct;
                        totalClaimableAmount += ATDeduct;
                    }
                }
            }
        }
        if (totalClaimableAmount >= cAmount) {
            paymentToken.transfer(cInfo.claimant, cAmount);
        } else {
            communityStates = CommunityStates.COLLAPSED;
        }

        emit FundClaimed(cInfo.claimant, cAmount, cInfo.id);
    }

    function submitClaim() public {
        // if (
        //     block.timestamp >
        //     periodIdToPeriodInfo[periodId].startedAt + (3 * daysInSeconds) ||
        //     block.timestamp < periodIdToPeriodInfo[periodId].startedAt
        // ) {
        //     revert NotClaimWindow();
        // }
        if (
            periodId > 1 &&
            !memberIdToMemberInfo[memberToMemberId[msg.sender]]
                .eligibleForCoverageInPeriod[periodId]
        ) {
            revert NotInCovereged();
        }
        claimId++;
        if (memberAndPeriodIdToClaimId[msg.sender][periodId] == 0) {
            memberAndPeriodIdToClaimId[msg.sender][periodId] = claimId;
        } else {
            revert AlreadySubmitted();
        }

        ClaimInfo storage cInfo = periodIdToClaimIdToClaimInfo[periodId][
            claimId
        ];

        periodIdToClaimIds[periodId].push(claimId);
        periodIdToPeriodInfo[periodId].claimIds.push(claimId);
        cInfo.id = claimId;
        cInfo.claimant = msg.sender;
        cInfo.SGId = memberIdToMemberInfo[memberToMemberId[msg.sender]]
            .associatedGroupId;
        emit ClaimSubmitted(cInfo.claimant, claimId);
    }

    function issueRefund(bool _shouldTransfer) public {
        if (
            block.timestamp >
            periodIdToPeriodInfo[periodId].startedAt + (4 * daysInSeconds) ||
            block.timestamp <
            periodIdToPeriodInfo[periodId].startedAt + (3 * daysInSeconds)
        ) {
            revert NotRefundWindow();
        }
        // if (periodId > 1 && periodIdWhiteListedClaims[periodId].length <= 0) {
        // _refundUnClaimedFund();
        // }

        for (uint256 i = 1; i < memberId + 1; i++) {
            MemberInfo storage mInfo = memberIdToMemberInfo[i];
            if (mInfo.pendingRefundAmount > 0) {
                uint256 pAmount = mInfo.pendingRefundAmount;
                mInfo.pendingRefundAmount = 0;
                mInfo.availableToWithdraw = pAmount;
            }
            if (
                periodId > 1 &&
                periodIdWhiteListedClaims[periodId - 1].length <= 0 &&
                mInfo.cEscrowAmount > 0
            ) {
                if (
                    communityStates == CommunityStates.FRACTURED &&
                    periodIdToClaimIds[periodId - 1].length <= 0
                ) {
                    uint256 qrAmount = mInfo.cEscrowAmount;
                    mInfo.cEscrowAmount = 0;
                    mInfo.idToQuedRefundAmount[periodId - 1] = qrAmount;
                } else {
                    uint256 uAmount = mInfo.cEscrowAmount;
                    mInfo.cEscrowAmount = 0;
                    mInfo.availableToWithdraw = uAmount;
                }
            }
            // if (mInfo.PPCEscrowAmount > 0) {
            //     mInfo.availableToWithdraw += mInfo.PPCEscrowAmount;
            //     mInfo.PPCEscrowAmount = 0;
            // }
            for (uint256 m = 1; m < 10; m++) {
                if (periodId > m) {
                    if (mInfo.idToQuedRefundAmount[periodId - m] > 0) {
                        mInfo.availableToWithdraw += mInfo.idToQuedRefundAmount[
                            periodId - m
                        ];
                        mInfo.idToQuedRefundAmount[periodId - m] = 0;
                    }
                }
            }

            if (_shouldTransfer && mInfo.availableToWithdraw > 0) {
                uint256 wAmount = mInfo.availableToWithdraw;
                mInfo.availableToWithdraw = 0;
                paymentToken.transfer(mInfo.member, wAmount);
            }
        }
        emit RefundIssued();
    }

    // function increaseSavingAccountAmount(uint256 _amount) public {
    //     if (
    //         block.timestamp <
    //         periodIdToPeriodInfo[periodId].startedAt + (27 * daysInSeconds) ||
    //         block.timestamp > periodIdToPeriodInfo[periodId].willEndAt
    //     ) {
    //         revert NotPayWindow();
    //     }
    //     MemberInfo storage mInfo = memberIdToMemberInfo[
    //         memberToMemberId[msg.sender]
    //     ];
    //     paymentToken.transferFrom(msg.sender, address(this), _amount);
    //     mInfo.ISEscorwAmount += _amount;
    //     uint256 MSAmount = basePremium + ((basePremium * 120) / 100);
    //     if (mInfo.ISEscorwAmount > MSAmount) {
    //         mInfo.cEscrowAmount += mInfo.ISEscorwAmount - MSAmount;
    //         mInfo.ISEscorwAmount -= MSAmount;
    //     }
    // }

    function withdrawRefund() public nonReentrant {
        MemberInfo storage mInfo = memberIdToMemberInfo[
            memberToMemberId[msg.sender]
        ];
        uint256 wAmount = mInfo.availableToWithdraw;
        mInfo.availableToWithdraw = 0;
        if (wAmount == 0) {
            revert AmountZero();
        }
        paymentToken.transfer(mInfo.member, wAmount);
        emit RefundWithdrawn(mInfo.member, wAmount);
    }

    // function setInitialCoverage(uint256 _coverage) public onlySecretary {
    //     if (totalCoverage != 0) {
    //         revert AlreadySet();
    //     }
    //     totalCoverage = _coverage;
    // }

    // function _checkInitialUserPremiumPayment() internal {
    //     for (uint256 i = 1; i < memberId; i++) {
    //         MemberInfo storage mInfo = memberIdToMemberInfo[i];
    //         if (
    //             mInfo.ISEscorwAmount == 0 ||
    //             mInfo.ISEscorwAmount <
    //             (basePremium + (((basePremium * 20) / 100) * 11) / 12)
    //         ) {
    //             mInfo.status = MemberStatus.UNPAID_INVALID;
    //         }
    //     }
    // }

    function getPaymentToken() public view returns (address) {
        return address(paymentToken);
    }

    function getCurrentMemberId() public view returns (uint256) {
        return memberId;
    }
    function getCurrentSubGroupId() public view returns (uint256) {
        return subGroupId;
    }
    function getCurrentClaimId() public view returns (uint256) {
        return claimId;
    }
    function getPeriodId() public view returns (uint256) {
        return periodId;
    }
    function getTotalCoverage() public view returns (uint256) {
        return totalCoverage;
    }
    function getBasePremium() public view returns (uint256) {
        return basePremium;
    }
    function getManuallyCollapsedPeriod() public view returns (uint256) {
        return manuallyCollapsedPeriod;
    }

    function getIsManuallyCollapsed() public view returns (bool) {
        return isManuallyCollapsed;
    }

    // function getIsHandingOver() public view returns (bool) {
    //     return isHandingOver;
    // }

    function getCommunityState() public view returns (CommunityStates) {
        return communityStates;
    }

    function getSubGroupIdToSubGroupInfo(
        uint256 _sId
    ) public view returns (SubGroupInfo memory) {
        return subGroupIdToSubGroupInfo[_sId];
    }

    function getPeriodIdToClaimIdToClaimInfo(
        uint256 _pId,
        uint256 _cId
    ) public view returns (ClaimInfo memory) {
        return periodIdToClaimIdToClaimInfo[_pId][_cId];
    }

    function getPeriodIdToClaimIds(
        uint256 _pId
    ) public view returns (uint256[] memory) {
        return periodIdToClaimIds[_pId];
    }

    function getPeriodIdToDefectorsId(
        uint256 _pId
    ) public view returns (uint256[] memory) {
        return periodIdToDefectorsId[_pId];
    }

    function getMemberToMemberId(
        address _member
    ) public view returns (uint256) {
        return memberToMemberId[_member];
    }

    function getPeriodIdWhiteListedClaims(
        uint256 _pId
    ) public view returns (uint256[] memory) {
        return periodIdWhiteListedClaims[_pId];
    }

    function getMemberToMemberInfo(
        address _member,
        uint256 _pId
    ) public view returns (DemoMemberInfo memory) {
        MemberInfo storage mInfo = memberIdToMemberInfo[
            memberToMemberId[_member]
        ];
        uint256 pId = _pId == 0 ? periodId : _pId;
        DemoMemberInfo memory dInfo = DemoMemberInfo(
            mInfo.memberId,
            mInfo.associatedGroupId,
            mInfo.member,
            mInfo.cEscrowAmount,
            mInfo.ISEscorwAmount,
            mInfo.pendingRefundAmount,
            mInfo.availableToWithdraw,
            mInfo.eligibleForCoverageInPeriod[pId],
            mInfo.isPremiumPaid[pId],
            mInfo.idToQuedRefundAmount[pId],
            mInfo.status,
            mInfo.assignment
        );
        return dInfo;
    }

    function getIsAMemberDefectedInPeriod(
        uint256 _pId
    ) public view returns (bool) {
        return isAMemberDefectedInPeriod[_pId];
    }

    function getPeriodIdToPeriodInfo(
        uint256 _pId
    ) public view returns (PeriodInfo memory) {
        return periodIdToPeriodInfo[_pId];
    }

    function getIsAllMemberNotPaidInPeriod(
        uint256 _pId
    ) public view returns (bool) {
        return isAllMemberNotPaidInPeriod[_pId];
    }
}

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

abstract contract Ownable is Context {
    // address internal _owner;
    address internal _secretary;
    address[] internal secretarySuccessors;
    address internal upcomingSecretary;
    address[2] internal _emergencySecretaries;
    bool internal isHandingOver;
    uint256 internal embergencyHandOverStartedPeriod;
    uint256 internal handoverStartedAt;
    uint256 internal embergencyHandoverStartedAt;
    // error OwnableUnauthorizedAccount(address account);
    error OwnableUnauthorizedSecretary(address account);
    error OwnableInvalidOwner(address owner);
    event SecretaryTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor(address initialSecretary) {
        if (initialSecretary == address(0)) {
            revert OwnableInvalidOwner(address(0));
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

    // function _checkSecretary() internal view virtual {
    //     if (owner() != _msgSender()) {
    //         revert OwnableUnauthorizedAccount(_msgSender());
    //     }
    // }
    function _checkSecretary() internal view virtual {
        if (secretary() != _msgSender()) {
            revert OwnableUnauthorizedSecretary(_msgSender());
        }
    }

    // function renounceOwnership() public virtual onlySecretary {
    //     _transferOwnership(address(0));
    // }

    // function transferOwnership(address newOwner) public virtual onlySecretary {
    //     if (newOwner == address(0)) {
    //         revert OwnableInvalidOwner(address(0));
    //     }
    //     _transferOwnership(newOwner);
    // }

    function _transferSecretary(address newSecretary) internal virtual {
        address oldOwner = _secretary;
        _secretary = newSecretary;
        emit SecretaryTransferred(oldOwner, newSecretary);
    }
}

contract TandaPay is Ownable, ReentrancyGuard {
    error NotInIniOrDef();
    error InvalidMember();
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
    error NeedMoreSuccessor();
    error NotInInjectionWindow();
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

    IERC20 private paymentToken;
    uint256 private memberId;
    uint256 private subGroupId;
    uint256 private claimId;
    uint256 private periodId;
    uint256 private totalCoverage;
    uint256 private basePremium;
    uint256 private minimumSavingAccountBalance;
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
    mapping(uint256 => address[]) private subGroupIdToApplicants;
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

    enum MemberStatus {
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

    enum AssignmentStatus {
        AddedBySecretery,
        ApprovedByMember,
        AssignedToGroup,
        ApprovedByGroupMember,
        AssignmentSuccessfull,
        CancelledByMember,
        CancelledGMember
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

    constructor(address _paymentToken) Ownable(msg.sender) {
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
        memberId++;
        MemberInfo storage mInfo = memberIdToMemberInfo[memberId];
        mInfo.memberId = memberId;
        memberToMemberId[_member] = mInfo.memberId;
        mInfo.member = _member;
        mInfo.status = MemberStatus.Assigned;
        mInfo.assignment = AssignmentStatus.AddedBySecretery;
    }

    function createSubGroup() public onlySecretary {
        subGroupId++;
        SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[subGroupId];
        sInfo.id = subGroupId;
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

        if (mInfo.member == address(0)) {
            revert InvalidMember();
        }
        sInfo.members.push(mInfo.member);
        mInfo.assignment = AssignmentStatus.AssignedToGroup;
        mInfo.associatedGroupId = _sId;
        if (sInfo.members.length > 4 && sInfo.members.length <= 7) {
            if (!sInfo.isValid) {
                sInfo.isValid = true;
            }
        } else {
            if (sInfo.isValid) {
                sInfo.isValid = false;
            }
        }
        if (_isReorging) {
            if (mInfo.status != MemberStatus.PAID_INVALID) {
                revert NotPaidInvalid();
            }
            mInfo.status = MemberStatus.REORGED;
        }
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
        paymentToken.transferFrom(
            msg.sender,
            address(this),
            (saAmount * 11) / 12
        );
        mInfo.status = MemberStatus.New;
        mInfo.assignment = AssignmentStatus.ApprovedByMember;
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
        uint256 index;
        for (uint256 i = 0; i < sInfo.members.length; i++) {
            if (sInfo.members[i] == msg.sender) {
                index = i;
            }
        }

        if (_shouldJoin) {
            if (mInfo.status == MemberStatus.REORGED) {
                mInfo.assignment = AssignmentStatus.ApprovedByMember;
            } else {
                // mInfo.status = MemberStatus.New;
                mInfo.assignment = AssignmentStatus.AssignmentSuccessfull;
            }
        } else {
            sInfo.members[index] = sInfo.members[sInfo.members.length - 1];
            sInfo.members.pop();
            memberIdToMemberInfo[memberToMemberId[msg.sender]]
                .status = MemberStatus.USER_QUIT;
        }
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
    }

    function exitSubGroup() public {
        MemberInfo storage mInfo = memberIdToMemberInfo[
            memberToMemberId[msg.sender]
        ];
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

        if (
            memberIdToMemberInfo[memberToMemberId[cInfo.claimant]].status !=
            MemberStatus.VALID &&
            !memberIdToMemberInfo[memberToMemberId[cInfo.claimant]]
                .eligibleForCoverageInPeriod[periodId]
        ) {
            revert ClaimantNotValidMember();
        }
        cInfo.isWhitelistd = true;

        periodIdWhiteListedClaims[periodId].push(cInfo.id);
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
    }

    function payPremium(bool _useFromATW) public {
        // if (communityStates != CommunityStates.DEFAULT) {
        //     revert NotInInDefault();
        // }
        if (
            communityStates != CommunityStates.INITIALIZATION &&
            communityStates != CommunityStates.DEFAULT
        ) {
            revert NotInIniOrDef();
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
        // SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[
        //     mInfo.associatedGroupId
        // ];
        uint256 amountToPay = basePremium;
        uint256 saAmount = basePremium + ((basePremium * 20) / 100);
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
        } else if (
            mInfo.status == MemberStatus.DEFECTED ||
            mInfo.status == MemberStatus.USER_QUIT
        ) {
            revert OutOfTheCommunity();
        }
        // if (
        //     mInfo.cEscrowAmount >= basePremium &&
        //     mInfo.ISEscorwAmount >= saAmount
        // ) {
        //     mInfo.isPremiumPaid[periodId] = true;
        // }
    }

    function updateCoverageAmount(uint256 _coverage) public onlySecretary {
        if (
            communityStates != CommunityStates.INITIALIZATION &&
            communityStates != CommunityStates.DEFAULT
        ) {
            revert NotInDefOrFra();
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
        minimumSavingAccountBalance = basePremium + ((basePremium * 20) / 100);
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
                if (_successors[i] == memberIdToMemberInfo[memberId].member) {
                    isIn = true;
                    break;
                }
            }
            if (!isIn) {
                revert NotIncluded();
            }

            secretarySuccessors.push(_successors[i]);
        }
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
            }
        }
    }

    function emergencyHandOverSecretary(address _eSecretary) public {
        bool isInES;
        for (uint256 i = 0; i < secretarySuccessors.length; i++) {
            if (_eSecretary == secretarySuccessors[i]) {
                isInES = true;
            }
        }
        if (!isInES) {
            revert NotIncluded();
        }
        bool isIn;
        // for (uint256 i = 0; i < memberId + 1; i++) {
        //     if (msg.sender == memberIdToMemberInfo[i].member) {
        //         isIn = true;
        //     }
        // }
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
        if (_emergencySecretaries[0] == address(0)) {
            _emergencySecretaries[0] = _eSecretary;
            embergencyHandoverStartedAt = block.timestamp;
            embergencyHandOverStartedPeriod = periodId;
        } else {
            // if (_emergencySecretaries[0] != address(0)) {
            if (
                block.timestamp <
                embergencyHandoverStartedAt + (1 * daysInSeconds) &&
                embergencyHandOverStartedPeriod == periodId
            ) {
                _emergencySecretaries[1] = _eSecretary;
            } else {
                _emergencySecretaries[0] = _eSecretary;
                embergencyHandoverStartedAt = block.timestamp;
                embergencyHandOverStartedPeriod = periodId;
            }
        }
        if (
            _emergencySecretaries[0] != address(0) &&
            _emergencySecretaries[1] != address(0)
        ) {
            if (_emergencySecretaries[0] == _emergencySecretaries[1]) {
                upcomingSecretary = _emergencySecretaries[0];
            }
            // if (_emergencySecretaries[0] != _emergencySecretaries[1])
            else {
                _emergencySecretaries[0] = address(0);
                _emergencySecretaries[1] = address(0);
            }
        }
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
    }

    function addAdditionalDay() public onlySecretary {
        periodIdToPeriodInfo[periodId].willEndAt =
            periodIdToPeriodInfo[periodId].willEndAt +
            (1 * daysInSeconds);
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
    }

    function leaveFromASubGroup() public {
        MemberInfo storage mInfo = memberIdToMemberInfo[memberId];
        SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[
            mInfo.associatedGroupId
        ];
        if (mInfo.member == address(0)) {
            revert NotValidMember();
        }
        mInfo.associatedGroupId = 0;
        mInfo.status = MemberStatus.DEFECTED;
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
    }

    function AdvanceToTheNextPeriod() public onlySecretary {
        if (
            communityStates != CommunityStates.DEFAULT ||
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
            basePremium = totalCoverage / VMCount;
        }
        pInfo.willEndAt = block.timestamp + (30 * daysInSeconds);
    }

    function updateMemberStatus() public onlySecretary {
        for (uint256 i = 1; i < memberId + 1; i++) {
            MemberInfo storage mInfo = memberIdToMemberInfo[memberId];
            // SubGroupInfo storage sInfo = subGroupIdToSubGroupInfo[
            //     mInfo.associatedGroupId
            // ];
            if (mInfo.status != MemberStatus.Assigned) {
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
            periodIdToPeriodInfo[periodId].startedAt + (3 * daysInSeconds) ||
            block.timestamp < periodIdToPeriodInfo[periodId].startedAt
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
        cInfo.id = claimId;
        cInfo.claimant = msg.sender;
        cInfo.SGId = memberIdToMemberInfo[memberToMemberId[msg.sender]]
            .associatedGroupId;
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
                        mInfo.availableToWithdraw = mInfo.idToQuedRefundAmount[
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
}

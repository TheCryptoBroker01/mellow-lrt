// SPDX-License-Identifier: BSL-1.1
pragma solidity 0.8.25;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

interface IAdminProxy {
    error Forbidden();

    struct Proposal {
        address implementation;
        bytes callData;
    }

    function proxy() external view returns (ITransparentUpgradeableProxy);

    function baseImplementation() external view returns (Proposal memory);

    function proposedBaseImplementation()
        external
        view
        returns (Proposal memory);

    function proposer() external view returns (address);

    function acceptor() external view returns (address);

    function emergencyOperator() external view returns (address);

    function proposalAt(uint256 index) external view returns (Proposal memory);

    function proposalsCount() external view returns (uint256);

    function upgradeProposer(address newProposer) external;

    function upgradeAcceptor(address newAcceptor) external;

    function upgradeEmergencyOperator(address newAcceptor) external;

    function propose(address implementation, bytes calldata callData) external;

    function proposeBaseImplementation(
        address implementation,
        bytes calldata callData
    ) external;

    function acceptBaseImplementation() external;

    function acceptProposal(uint256 index) external;

    function latestAcceptedNonce() external view returns (uint256);

    function rejectAllProposals() external;

    function resetToBaseImplementation() external;

    event EmergencyOperatorUpgraded(
        address newEmergencyOperator,
        address origin
    );

    event ProposerUpgraded(address newProposer, address origin);

    event AcceptorUpgraded(address newAcceptor, address origin);

    event ProposalAccepted(uint256 index, address origin);

    event AllProposalsRejected(uint256 latestAcceptedNonce, address origin);
    event ResetToBaseImplementation(Proposal implementation, address origin);

    event ImplementationProposed(
        address implementation,
        bytes callData,
        address origin
    );

    event BaseImplementationProposed(Proposal implementation, address origin);
    event BaseImplementationAccepted(Proposal implementation, address origin);
}

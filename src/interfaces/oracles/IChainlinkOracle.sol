// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "../utils/IDefaultAccessControl.sol";
import "../external/chainlink/IAggregatorV3.sol";

import "./IPriceOracle.sol";

/**
 * @title IChainlinkOracle
 * @notice Interface defining a price oracle that uses Chainlink data.
 */
interface IChainlinkOracle is IPriceOracle {
    /// @dev Errors
    error AddressZero();
    error InvalidLength();
    error Forbidden();
    error StaleOracle();

    /**
     * @notice Returns the maximum allowable age for an oracle result before it's considered stale.
     * @return uint256 The value representing the maximum age of an oracle result.
     */
    function MAX_ORACLE_AGE() external view returns (uint256);

    /**
     * @notice Returns the constant Q96 used for ratio calculations with 96-bit precision.
     * @return uint256 The value of Q96 (2^96) for ratio calculations.
     */
    function Q96() external view returns (uint256);

    /**
     * @notice Returns the Chainlink price aggregator address for a specific vault and token.
     * @param vault The address of the vault.
     * @param token The address of the token.
     * @return address of the Chainlink price aggregator.
     */
    function aggregatorsV3(
        address vault,
        address token
    ) external view returns (address);

    /**
     * @notice Returns the base token associated with a specific vault.
     * @param vault The address of the vault.
     * @return address of the base token.
     */
    function baseTokens(address vault) external view returns (address);

    /**
     * @notice Sets the base token for a specific vault.
     * @param vault The address of the vault to set the base token for.
     * @param baseToken The address of the base token to associate with the vault.
     */
    function setBaseToken(address vault, address baseToken) external;

    /**
     * @notice Sets Chainlink price oracles for a given vault and an array of tokens.
     * @param vault The address of the vault to associate the tokens and oracles with.
     * @param tokens An array of token addresses that require price data.
     * @param oracles An array of corresponding Chainlink oracle addresses.
     * @dev Both arrays should have the same length.
     */
    function setChainlinkOracles(
        address vault,
        address[] memory tokens,
        address[] memory oracles
    ) external;

    /**
     * @notice Retrieves the latest price for a specific token from a given vault's associated Chainlink oracle.
     * @param vault The address of the vault requesting the price.
     * @param token The address of the token to get the price for.
     * @return answer The latest price of the token.
     * @return decimals The number of decimals used by the Chainlink oracle for this price.
     * @dev Reverts with `StaleOracle` if the price data is too old.
     */
    function getPrice(
        address vault,
        address token
    ) external view returns (uint256 answer, uint8 decimals);

    /**
     * @notice Emitted when the base token is set for a specific vault in the Chainlink Oracle.
     * @param vault The address of the vault for which the base token is set.
     * @param baseToken The address of the base token set for the vault.
     * @param timestamp The timestamp when the base token is set.
     */
    event ChainlinkOracleSetBaseToken(
        address indexed vault,
        address baseToken,
        uint256 timestamp
    );

    /**
     * @notice Emitted when Chainlink oracles are set for a specific vault in the Chainlink Oracle.
     * @param vault The address of the vault for which Chainlink oracles are set.
     * @param tokens An array of token addresses for which Chainlink oracles are set.
     * @param oracles An array of Chainlink oracle addresses set for the tokens.
     * @param timestamp The timestamp when Chainlink oracles are set.
     */
    event ChainlinkOracleSetChainlinkOracles(
        address indexed vault,
        address[] tokens,
        address[] oracles,
        uint256 timestamp
    );
}

// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.18;

/// @title Hasher interface for hashing 2 uint256 elements.
/// @notice This contract is meant to be used to generalize over different hash functions.
interface IHasher {
	/// @dev provides a 2 elemtns hash with left and right elements
	function hashLeftRight(bytes32 _left, bytes32 _right) external view returns (bytes32);

	/// @dev provides Zero (Empty) elements for a IHasher based MerkleTree. Up to 32 levels
	function zeros(uint256 i) external view returns (bytes32);
}
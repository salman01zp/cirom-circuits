// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MerkleTreeWithHistory} from "../src/MerkleTreeWithHistory.sol";
import {KeccakHasher} from "../src/hasher/KeccakHasher.sol";
import "../src/interface/IHasher.sol";

// Mock contract to expose internal _insert function for testing purposes
contract MockMerkleTreeWithHistory is MerkleTreeWithHistory {
    // Expose the internal _insert function as public for testing
    constructor(uint32 _levels, IHasher _hasher) MerkleTreeWithHistory(_levels, _hasher) {}

    // Public function to allow testing of the internal _insert function
    function insertLeaf(bytes32 _leaf) external returns (uint32) {
        return _insert(_leaf);
    }
}

contract MockMerkleTreeWithHistoryTest is Test {
    MockMerkleTreeWithHistory public merkeTree;
    KeccakHasher public hasher;

    // Set up function to deploy the KeccakHasher contract before each test
    function setUp() public {
        hasher = new KeccakHasher(); // Deploy the KeccakHasher
        merkeTree = new MockMerkleTreeWithHistory(30, hasher); // Deploy the MerkleTreeWithHistory with 30 levels
    }

    // Test 1: Verify the initial root after contract deployment
    function test_initialRoot() public view {
        bytes32 initialRoot = merkeTree.getLastRoot();
        console.logBytes32(initialRoot);

        // The initial root should be set to zeros(29) level-1
        bytes32 expectedRoot = bytes32(hasher.zeros(29));
        assertEq(initialRoot, expectedRoot, "The initial root should match the expected zero value.");
    }

    // Test 2: Insert a single leaf and verify that the root changes
    function test_insertSingleLeaf() public {
        bytes32 leaf = keccak256(abi.encodePacked("leaf1")); // A leaf we will insert
        bytes32 initialRoot = merkeTree.getLastRoot();
        console.logBytes32(initialRoot);

        merkeTree.insertLeaf(leaf); // Use the wrapper function for test
        bytes32 newRoot = merkeTree.getLastRoot(); // Get the new root after insertion

        // We expect the new root to be different after inserting a leaf
        assertFalse(initialRoot == newRoot, "The root should change after inserting a leaf.");
    }

}

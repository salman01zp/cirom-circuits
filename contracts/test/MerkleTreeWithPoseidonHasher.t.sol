// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MerkleTreeWithHistory} from "../src/MerkleTreeWithHistory.sol";
import {PoseidonHasher} from "../src/hasher/PoseidonHasher.sol";
import {MockMerkleTree} from "./MockMerkleTree.sol";
import "../src/interface/IHasher.sol";

contract MockMerkleTreeWithPoseidonHasherTest is Test {
    MockMerkleTree public merkeTree;
    PoseidonHasher public hasher;

    // Set up function to deploy the PoseidonHasher contract before each test
    function setUp() public {
        hasher = new PoseidonHasher(); // Deploy the PoseidonHasher
        merkeTree = new MockMerkleTree(30, hasher); // Deploy the MerkleTreeWithHistory with 30 levels
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
        uint256 leaf = 10; // A leaf we will insert
        bytes32 initialRoot = merkeTree.getLastRoot();
        console.logBytes32(initialRoot);

        merkeTree.insertLeaf(bytes32(leaf)); // Use the wrapper function for test
        bytes32 newRoot = merkeTree.getLastRoot(); // Get the new root after insertion

        // We expect the new root to be different after inserting a leaf
        assertFalse(initialRoot == newRoot, "The root should change after inserting a leaf.");
    }

    // Test 3: Insert multiple leaves and verify the root changes
    function test_insertMultipleLeaves() public {
        uint256 leaf1 = 10; // First leaf we will insert
        uint256 leaf2 = 20; // Second leaf we will insert
        uint256 leaf3 = 30; // Third leaf we will insert

        bytes32 initialRoot = merkeTree.getLastRoot();
        console.logBytes32(initialRoot);

        // Insert leaves one by one
        merkeTree.insertLeaf(bytes32(leaf1));
        bytes32 rootAfterFirstInsert = merkeTree.getLastRoot();
        console.logBytes32(rootAfterFirstInsert);

        assertFalse(initialRoot == rootAfterFirstInsert, "Root should change after first leaf insertion.");

        merkeTree.insertLeaf(bytes32(leaf2));
        bytes32 rootAfterSecondInsert = merkeTree.getLastRoot();
        console.logBytes32(rootAfterSecondInsert);

        assertFalse(rootAfterFirstInsert == rootAfterSecondInsert, "Root should change after second leaf insertion.");

        merkeTree.insertLeaf(bytes32(leaf3));
        bytes32 rootAfterThirdInsert = merkeTree.getLastRoot();
        console.logBytes32(rootAfterThirdInsert);

        assertFalse(rootAfterSecondInsert == rootAfterThirdInsert, "Root should change after third leaf insertion.");
    }

    // Test 4: Verify the root history functionality
    function test_rootHistory() public {
        // Insert enough leaves to fill the root history
        for (uint32 i = 0; i < 30; i++) {
            uint256 leaf = i * 10;
            merkeTree.insertLeaf(bytes32(leaf));
        }

        bytes32 latestRoot = merkeTree.getLastRoot();
        console.logBytes32(latestRoot);

        // Test that we can find the latest root in the history
        assertTrue(merkeTree.isKnownRoot(latestRoot), "The latest root should be in the root history.");

        // Test that an initial root is in the history.
        bytes32 initalRoot = merkeTree.roots(29);
        console.logBytes32(initalRoot);
        assertTrue(merkeTree.isKnownRoot(initalRoot), "The Initial root should be in the root history.");
    }
}

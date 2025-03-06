// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MerkleTreeWithHistory} from "../src/MerkleTreeWithHistory.sol";
import {KeccakHasher} from "../src/hasher/KeccakHasher.sol";
import {MockMerkleTree} from "./MockMerkleTree.sol";
import "../src/interface/IHasher.sol";

contract MockMerkleTreeWithKeccakHasherTest is Test {
    MockMerkleTree public merkeTree;
    KeccakHasher public hasher;

    // Set up function to deploy the KeccakHasher contract before each test
    function setUp() public {
        hasher = new KeccakHasher(); // Deploy the KeccakHasher
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
        bytes32 leaf = keccak256(abi.encodePacked("leaf1")); // A leaf we will insert
        bytes32 initialRoot = merkeTree.getLastRoot();
        console.logBytes32(initialRoot);

        merkeTree.insertLeaf(leaf); // Use the wrapper function for test
        bytes32 newRoot = merkeTree.getLastRoot(); // Get the new root after insertion

        // We expect the new root to be different after inserting a leaf
        assertFalse(initialRoot == newRoot, "The root should change after inserting a leaf.");
    }

    // Test 3: Insert multiple leaves and verify the root changes
    function test_insertMultipleLeaves() public {
        bytes32 leaf1 = keccak256(abi.encodePacked("leaf1"));
        bytes32 leaf2 = keccak256(abi.encodePacked("leaf2"));
        bytes32 leaf3 = keccak256(abi.encodePacked("leaf3"));

        bytes32 initialRoot = merkeTree.getLastRoot();
        console.logBytes32(initialRoot);

        // Insert leaves one by one
        merkeTree.insertLeaf(leaf1);
        bytes32 rootAfterFirstInsert = merkeTree.getLastRoot();
        console.logBytes32(rootAfterFirstInsert);

        assertFalse(initialRoot == rootAfterFirstInsert, "Root should change after first leaf insertion.");

        merkeTree.insertLeaf(leaf2);
        bytes32 rootAfterSecondInsert = merkeTree.getLastRoot();
        console.logBytes32(rootAfterSecondInsert);

        assertFalse(rootAfterFirstInsert == rootAfterSecondInsert, "Root should change after second leaf insertion.");

        merkeTree.insertLeaf(leaf3);
        bytes32 rootAfterThirdInsert = merkeTree.getLastRoot();
        console.logBytes32(rootAfterThirdInsert);

        assertFalse(rootAfterSecondInsert == rootAfterThirdInsert, "Root should change after third leaf insertion.");
    }

    // Test 4: Verify the root history functionality
    function test_rootHistory() public {
        // Insert enough leaves to fill the root history
        for (uint32 i = 0; i < 30; i++) {
            bytes32 leaf = keccak256(abi.encodePacked("leaf", i));
            merkeTree.insertLeaf(leaf);
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

    // function test_insertionWhenFull() public {
    //     // Insert 2^levels leaves (30 levels -> 2^30 leaves = 1073741824)
    //     for (uint32 i = 0; i < 2 ** 30; i++) {
    //         bytes32 leaf = keccak256(abi.encodePacked("leaf", i));
    //         merkeTree.insertLeaf(leaf);
    //     }
    //     // The next insertion should revert
    //     bytes32 newLeaf = keccak256(abi.encodePacked("leafTooMany"));
    //     vm.expectRevert("Merkle tree is full. No more leaves can be added");
    //     merkeTree.insertLeaf(newLeaf);
    // }
}

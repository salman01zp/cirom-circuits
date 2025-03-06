// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MerkleTreeWithHistory} from "../src/MerkleTreeWithHistory.sol";
import "../src/interface/IHasher.sol";

// Mock contract to expose internal _insert function for testing purposes
contract MockMerkleTree is MerkleTreeWithHistory {
    // Expose the internal _insert function as public for testing
    constructor(uint32 _levels, IHasher _hasher) MerkleTreeWithHistory(_levels, _hasher) {}

    // Public function to allow testing of the internal _insert function
    function insertLeaf(bytes32 _leaf) external returns (uint32) {
        return _insert(_leaf);
    }
}

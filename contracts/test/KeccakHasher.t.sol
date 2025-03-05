// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import { KeccakHasher } from "../src/hasher/KeccakHasher.sol";
import "../src/interface/IHasher.sol";

contract KeccakHasherTest is Test {
    KeccakHasher public hasher;

    // Set up function to deploy the KeccakHasher contract before each test
    function setUp() public {
        hasher = new KeccakHasher(); 
    }

    function test_hashLeftRight() public view { 
        bytes32 left = keccak256(abi.encodePacked("left"));
        bytes32 right = keccak256(abi.encodePacked("right"));
        bytes32 result = hasher.hashLeftRight(left, right);

        // Calculate the expected hash manually (keccak256 of the concatenated inputs)
        bytes32 expected = keccak256(abi.encodePacked(left, right));
        assertEq(result, expected, "The hashLeftRight result is incorrect");

    }

}

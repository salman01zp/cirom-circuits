// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {PoseidonHasher} from "../src/hasher/PoseidonHasher.sol";
import {PoseidonT3} from "../src/hasher/Poseidon.sol";

import "../src/interface/IHasher.sol";

contract PoseidonHasherTest is Test {
    PoseidonHasher public hasher;

    // Set up function to deploy the PoseidonHasher contract before each test
    function setUp() public {
        hasher = new PoseidonHasher();
    }

    function test_hashLeftRight() public view {
        uint256 left = 10;
        uint256 right = 20;
        bytes32 result = hasher.hashLeftRight(bytes32(left), bytes32(right));

        // Expected poseidon hash
        uint256[2] memory input;
        input[0] = left;
        input[1] = right;
        bytes32 expected = bytes32(PoseidonT3.poseidon(input));
        assertEq(result, expected, "The hashLeftRight result is incorrect");
    }
}

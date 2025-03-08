// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {ERC20Mixer} from "../src/ERC20Mixer.sol";
import {Groth16Verifier} from "../src/Verifier.sol";
import {MerkleTreeWithHistory, IHasher} from "../src/MerkleTreeWithHistory.sol";
import {PoseidonHasher} from "../src/hasher/PoseidonHasher.sol";
import {ERC20Mock} from "./ERC20Mock.sol";
import "../src/interface/IHasher.sol";
import "../src/interface/IVerifier.sol";

contract MixerDepositTest is Test {
    uint32 constant MERKLE_TREE_HEIGHTS = 20;
    uint256 constant DENOMINATION = 10 ether;
    address walletAddress;

    Groth16Verifier verifier;
    ERC20Mixer mixer;
    PoseidonHasher hasher;
    ERC20Mock token;

    // Set up function to deploy the PoseidonHasher contract before each test
    function setUp() public {
        walletAddress = vm.addr(0xabc123);
        hasher = new PoseidonHasher();
        verifier = new Groth16Verifier();
        token = new ERC20Mock();
        mixer = new ERC20Mixer(IVerifier(address(verifier)), hasher, DENOMINATION, MERKLE_TREE_HEIGHTS, token);
        token.mint(walletAddress, DENOMINATION * 10);
        vm.prank(walletAddress);
        token.approve(address(mixer), DENOMINATION * 10);
    }

    function testDeposit() public {
        bytes32 commitment = bytes32(0);
        vm.prank(walletAddress);
        mixer.deposit(commitment);
        assertEq(token.balanceOf(walletAddress), DENOMINATION * 9);
    }

    function testDoubleDepositFails() public {
        bytes32 commitment = bytes32(0);
        vm.prank(walletAddress);
        mixer.deposit(commitment);
        vm.expectRevert();
        mixer.deposit(commitment);
    }
}

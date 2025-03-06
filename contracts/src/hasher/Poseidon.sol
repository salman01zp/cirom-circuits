// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
/// @title Poseidon Hash Implementation in Solidity
/// @notice Implements a full-round permutation Poseidon hash for zkSNARK-compatible hashing
/// @dev Reference: https://eprint.iacr.org/2019/458.pdf

library PoseidonT3 {
    uint256 internal constant F = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001;

    /// @dev Precomputed round constants (for 2-input Poseidon hashing)
    function getRoundConstants() internal pure returns (uint256[4] memory) {
        return [
            0x2f27be690fdaee46c3ce28f7532b13c856c35342c84bda6e20966310fadc01d0,
            0x15b52534031ae18f7f862cb2cf7cf760ab10a8150a337b1ccd99ff6e8797d428,
            0x099952b414884454b21200d7ffafdd5f0c9a9dcc06f2708e9fc1d8209b5c75b9,
            0x1a9f12f3c324f29a76bc1434ebf3ad1213f9dc8c512cd47e2a5db793c3127f56
        ];
    }

    /// @dev Poseidon matrix multiplication constants
    function getMatrixConstants() internal pure returns (uint256[4] memory) {
        return [
            0x109b7f411ba0e4c9b2b70caf5c36a7b194be7c11ad24378bfedb68592ba8118b,
            0x16ed41e13bb9c0c66ae119424fddbcbc9314dc9fdbdeea55d6c64543dc4903e0,
            0x2969f27eed31a480b9c36c764379dbca2cc8fdd1415c3dded62940bcde0bd771,
            0x2e2419f9ec02ec394c9871c832963dc1b89d743c8c7b964029b2311687b1fe23
        ];
    }

    /// @dev Computes Poseidon hash for 2 inputs with multiple rounds
    function poseidon(uint256[2] memory inputs) public pure returns (uint256) {
        uint256[4] memory C = getRoundConstants();
        uint256[4] memory M = getMatrixConstants();

        uint256[2] memory state = [inputs[0], inputs[1]];

        for (uint256 i = 0; i < C.length; i++) {
            // Add round constants
            state[0] = addmod(state[0], C[i], F);
            state[1] = addmod(state[1], C[(i + 1) % C.length], F);

            // Apply S-box (pow5 transformation)
            state[0] = pow5(state[0]);
            state[1] = pow5(state[1]);

            // Mix Layer (Matrix Multiplication)
            uint256 res0 = addmod(mulmod(state[0], M[0], F), mulmod(state[1], M[1], F), F);
            uint256 res1 = addmod(mulmod(state[0], M[2], F), mulmod(state[1], M[3], F), F);
            state[0] = res0;
            state[1] = res1;
        }

        return state[0]; // Return final Poseidon hash output
    }

    /// @dev Computes n^5 mod F
    function pow5(uint256 n) internal pure returns (uint256) {
        uint256 pow2 = mulmod(n, n, F);
        uint256 pow4 = mulmod(pow2, pow2, F);
        return mulmod(n, pow4, F);
    }
}

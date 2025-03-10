pragma circom 2.1.9;

include "../../hasher/poseidon.circom";
include "merkle_tree.circom";

// computes Poseidon(nullifier + secret)
template CommitmentHasher() {
    signal input nullifier;
    signal input secret;
    signal output commitment;
    signal output nullifierHash;

    component commitmentHasher = HashLeftRight();
    commitmentHasher.left <== nullifier;
    commitmentHasher.right <== secret;

    component nullifierHasher = HashLeftRight();
    nullifierHasher.left <==  nullifier;
    nullifierHasher.right <== nullifier;

    nullifierHash <== nullifierHasher.hash;
    commitment <== commitmentHasher.hash;
}

// Verifies that commitment that corresponds to given secret and nullifier is included in the merkle tree of deposits
template Withdraw(levels) {
    signal input root;
    signal input nullifierHash;
    signal input recipient;            // not taking part in any computations
    signal input relayer;              // not taking part in any computations
    signal input fee;                  // not taking part in any computations
    signal input refund;               // not taking part in any computations
    signal input nullifier;            // Private
    signal input secret;               // Private
    signal input pathElements[levels]; // Private
    signal input pathIndices[levels];  // Private

    component hasher = CommitmentHasher();
    hasher.nullifier <== nullifier;
    hasher.secret <== secret;
    hasher.nullifierHash === nullifierHash;

    component tree = MerkleTreeChecker(levels);
    tree.leaf <== hasher.commitment;
    tree.root <== root;
    for (var i = 0; i < levels; i++) {
        tree.pathElements[i] <== pathElements[i];
        tree.pathIndices[i] <== pathIndices[i];
    }

    // Add hidden signals to make sure that tampering with recipient or fee will invalidate the snark proof
    // Most likely it is not required, but it's better to stay on the safe side and it only takes 2 constraints
    // Squares are used to prevent optimizer from removing those constraints
    signal recipientSquare;
    signal feeSquare;
    signal relayerSquare;
    signal refundSquare;
    recipientSquare <== recipient * recipient;
    feeSquare <== fee * fee;
    relayerSquare <== relayer * relayer;
    refundSquare <== refund * refund;
}

component main { public [root, nullifierHash, recipient, relayer, fee, refund]} = Withdraw(10);
pragma circom 2.1.9;

template SumProduct() {
    // Declaratiosn of signals.
    signal input a;
    signal input b;

    signal output sum;
    signal output product;

    // Constraints.
    sum <== a + b;
    product <== a * b;

}

component main = SumProduct();
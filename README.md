## Private transaction Mixer
Simple Implementation on private transaction mixer.


### Circom Installation
Refer Circom and Snarkjs installation guide [here](https://docs.circom.io/getting-started/installation/)

#### 1. Compile Circuit
This will generate wasm and r1cs file in outputs directory
```shell
circom circuit/transaction.circom --r1cs --wasm --sym -o outputs/
```

#### 2. Generate ptau file (This file is used to generate proving and verifying key)
We will be using pregenerated file for testing
```shell
wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_12.ptau
```

#### 3. Setup Gorth16Verifier
```shell
snarkjs groth16 setup outputs/transaction.r1cs outputs/powersOfTau28_hez_final_12.ptau outputs/mixer_transaction_circuit.zkey
```

#### 4. Generate Verification key
```shell
snarkjs zkey export verificationkey outputs/mixer_transaction_circuit.zkey outputs/verification_key.json
```

#### 5. Generate Verifying Contract
```shell
snarkjs zkey export solidityverifier outputs/mixer_transaction_circuit.zkey  outputs/verifier.sol
```


### Install Foundry

Follow the instructions from [their repository](https://book.getfoundry.sh/getting-started/installation) or just do:

```shell
curl -L https://foundry.paradigm.xyz | bash
```

```shell
foundryup
```

#### Install dependencies in submodules

You can do it either with forge:

```shell
forge install
```

or directly with git:

```shell
git submodule update --init --recursive
```

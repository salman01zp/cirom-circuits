## Private transaction Mixer
Simple Implementation on private transaction mixer.

### Circom Installation
Refer Circom and Snarkjs installation guide [here](https://docs.circom.io/getting-started/installation/)

#### 1. Compile Circuit
This will generate wasm and r1cs file in outputs directory
```
circom circuit/transaction.circom --r1cs --wasm --sym -o outputs/
```

#### 2. Generate ptau file (This file is used to generate proving and verifying key)
We will be using pregenerated file for testing
```
wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_12.ptau
```

#### 3. Setup Gorth16Verifier
```
snarkjs groth16 setup outputs/transaction.r1cs outputs/powersOfTau28_hez_final_12.ptau outputs/mixer_transaction_circuit.zkey
```

#### 4. Generate Verification key
```
snarkjs zkey export verificationkey outputs/mixer_transaction_circuit.zkey outputs/verification_key.json
```

#### 5. Generate Verifying Contract
```
snarkjs zkey export solidityverifier outputs/mixer_transaction_circuit.zkey  outputs/verifier.sol
```

# Create3 with assembly

Solidity has the ability to deploy another bytecode to the same address. This works because we can use Create and Create2 opcodes.  But we can't verify code(v2), because etherscan show that its dangerous contract.

## How it works:

There are 3 contracts: a deployer (which creates a proxy, a proxy contract (which deploys the implementation) and the implementation contracts(v1 and v2) itself.
1. You need to take the bytecode of the first implementation version and pass it as a parameter to the deploy function of the deployer contract.
2. The contract saves the passed bytecode and deploys the proxy contract using create2 with a constant salt. The proxy contract is written as a bytecode.
3. The proxy contract begins the creation stage. It accesses the deployer contract to read from the variable the implementation bytecode that it needs to deploy. The constructor cannot be used as it will affect the proxy address. And it should always be the same. After the proxy contract has read the implementation code, it deploys it through create and selfdestruct. Nonce at the proxy address is reset to 0.
4. At the moment there is only a deployer and an implementation contract. We call the selfdestruct function of the implementation.
5. We repeat everything from step 1, but we should pass the implementation bytecode of the second version.


### Links:
- https://medium.com/coinmonks/dark-side-of-create2-opcode-6b6838a42d71
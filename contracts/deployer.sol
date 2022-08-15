//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8;
import "hardhat/console.sol";
contract Deployer {
/*

  proxy bytecode: 631e8b63db60E01b3d523d3d60046000335afa3d600060003e602051604034f0ff

  PUSH4 1e8b63db    Selector of function (public variable) implByteCode
  PUSH1	E0          E0 - 224 in hex. 32 bytes - 4 bytes = 28. 28*8=224
  SHL               Shift bytes(function selector) to left. In stack: 1e8b63db00000....
  RETURNDATASIZE    Cheap way to push 0 in stack
  MSTORE            Write to the beginning of memory function selector
  RETURNDATASIZE    Prepare arguments for staticcall function
  RETURNDATASIZE    Push 0
  PUSH1	04          Length of function selector
  PUSH1	00          Offset in memory
  CALLER            Address of deployer contract
  GAS               Pass all gas to staticcall
  STATICCALL        Call deployer contract for reading bytecode of implementation contract
  RETURNDATASIZE    Implementation bytecode length + size data
  PUSH1	00          Byte offset in the return data from staticcall
  PUSH1	00          Byte offset in the memory where the result will be copied
  RETURNDATACOPY    Copy data from staticcall into memory
  PUSH1	20          Prepare for creating new contract(implementation). Where in memory bytecode length
  MLOAD             Load from memory bytecode length of implementation contract
  PUSH1	40          Byte offset in the memory
  CALLVALUE         0. Implementation don't need eth in constuctor
  CREATE            Create new contract from proxy contract
  SELFDESTRUCT      Proxy contract dont exits any more

*/
    bytes create3proxy = hex"631e8b63db60E01b3d523d3d60046000335afa3d600060003e602051604034f0ff";
                             
    bytes32 KECCAK_create3proxy = keccak256(create3proxy);


    bytes32 commonSalt = "0xAA";
    bytes public implByteCode;

    function deploy(bytes calldata _implByteCode) external {
      implByteCode =_implByteCode;
      bytes memory create3proxyM = create3proxy;
      address proxyAddress;
      bytes32 salt = commonSalt;
      assembly {
        proxyAddress := create2(0, add(create3proxyM, 32), mload(create3proxyM), salt)
      }
      require(proxyAddress != address(0), "wrong address");
    }

    function getProxyAddress()  external view returns(address) {
      return  address(
      uint160(
        uint256(
          keccak256(
            abi.encodePacked(
              hex'ff',
              address(this),
              commonSalt,
              KECCAK_create3proxy
            )
          )
        )
      )
    );
    }

    function getImplAddress() external view returns(address) {
      address proxyAddress =  address(
      uint160(
        uint256(
          keccak256(
            abi.encodePacked(
              hex'ff',
              address(this),
              commonSalt,
              KECCAK_create3proxy
            )
          )
        )
      )
    );
    return address(
      uint160(
        uint256(
          keccak256(
            abi.encodePacked(
              hex"d6_94",
              proxyAddress,
              hex"01"
            )
          )
        )
      )
    );
  }
}



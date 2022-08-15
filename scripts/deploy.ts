import { ethers } from "hardhat";
import {
    Deployer__factory,
    Deployer
} from "../typechain-types";
import * as ETHKeeper1 from "../typechain-types/factories/ImplV1.sol";
import * as ETHKeeper2 from "../typechain-types/factories/ImplV2.sol";
async function main() {
  let deployer:Deployer;
  let owner:any;
  let Im:ETHKeeper1.ETHKeeper__factory; 
  let implAddress:string;
  let impl_1_ByteCode = ETHKeeper1.ETHKeeper__factory.bytecode;
  let impl_2_ByteCode = ETHKeeper2.ETHKeeper__factory.bytecode;
  [owner] = await ethers.getSigners();   
  deployer = await new Deployer__factory(owner).deploy();
  Im = await ethers.getContractFactory("contracts/ImplV1.sol:ETHKeeper") as ETHKeeper1.ETHKeeper__factory;
  await deployer.deploy(impl_1_ByteCode);
  implAddress = await deployer.getImplAddress()
  let im = Im.attach(implAddress);

  await im.destroy({  gasPrice: ethers.utils.parseUnits('100', 'gwei'), gasLimit: 40000});
  await deployer.deploy(impl_2_ByteCode);
  console.log(`Implementation address: ${implAddress}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

import { expect } from "chai";
import { ethers } from "hardhat";
import {
    Deployer__factory,
    Deployer
} from "../typechain-types";
import * as ETHKeeper1 from "../typechain-types/factories/ImplV1.sol";
import * as ETHKeeper2 from "../typechain-types/factories/ImplV2.sol";
const provider = ethers.provider;

describe("Create3", function()   {
    
    let deployer:Deployer;
    let owner:any;
    let Im:ETHKeeper1.ETHKeeper__factory; 
    let implAddress:string;
    let impl_1_ByteCode = ETHKeeper1.ETHKeeper__factory.bytecode;
    let impl_2_ByteCode = ETHKeeper2.ETHKeeper__factory.bytecode;
    before(async() => {
        [owner] = await ethers.getSigners();   
        deployer = await new Deployer__factory(owner).deploy();
        Im = await ethers.getContractFactory("contracts/ImplV1.sol:ETHKeeper") as ETHKeeper1.ETHKeeper__factory;
    })

    it("Deploy implementation v1", async () => {
      await deployer.deploy(impl_1_ByteCode);
      implAddress = await deployer.getImplAddress()
      let im = Im.attach(implAddress);
      expect(await im.v()).to.equal(1);
    })

    it("Destroy implementation contract", async () => {
      let im = Im.attach(implAddress);
      await im.destroy();
      expect(await provider.getCode(implAddress)).to.equal('0x');
    })

    it("Deploy implementation v2 with different bytecode", async () => {
      await deployer.deploy(impl_2_ByteCode);
      let im = Im.attach(implAddress);
      expect(await im.v()).to.equal(2);
    })
    
    })




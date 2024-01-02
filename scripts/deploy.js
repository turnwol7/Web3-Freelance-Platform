// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
import hre from "hardhat";

async function main() {

const Freelance = await hre.ethers.getContractFactory("Freelance");
const freelance = await Freelance.deploy();

await freelance.deployed();

console.log(
  `Freelance deployed to ' ${freelance.address} `
  );

}


main().catch((error) => {
  console.error(error);
  process.exitcode = 1;
});
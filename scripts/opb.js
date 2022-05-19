const hre = require("hardhat");

async function main() {

  const Opb = await hre.ethers.getContractFactory("OldPopcatBasterds");
  const opb = await Opb.deploy();

  await opb.deployed();

  console.log("OldPopcatBasterds deployed to:", opb.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

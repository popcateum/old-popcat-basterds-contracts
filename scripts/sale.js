const hre = require("hardhat");
// address _opb,
// 		address _signer,
// 		address _c1,
// 		address _c2,
// 		address _c3,
// 		address _c4
async function main() {
  const opbCA = '0x7150bFb3affd8c0c81380Ba45b399d34DC5C8892'
  const signer = '0xD973d77f6fb8bee7308E1eBDC830A0d5a817E9Eb'
  const c1 = '0xD973d77f6fb8bee7308E1eBDC830A0d5a817E9Eb'
  const c2 = '0xD973d77f6fb8bee7308E1eBDC830A0d5a817E9Eb'
  const c3 = '0xD973d77f6fb8bee7308E1eBDC830A0d5a817E9Eb'
  const c4 = '0xD973d77f6fb8bee7308E1eBDC830A0d5a817E9Eb'

  const Sale = await hre.ethers.getContractFactory("Sale");
  const sale = await Sale.deploy(opbCA, signer, c1, c2, c3, c4);

  await sale.deployed();

  console.log("Sale deployed to:", sale.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

const ItemContract = artifacts.require("ItemContract");
const SupplyContract = artifacts.require("SupplyContract");
const AuctionContract = artifacts.require("AuctionContract");
const SupplyManagingContract = artifacts.require("SupplyManagingContract"); // (구) rwSupplyData
const OwnerDataContract = artifacts.require("OwnerDataContract");
var OwnerDataAddress;
var SupplyManagingAddress;

module.exports = async function (deployer) {
  await deployer.deploy(SupplyContract);

  await deployer.deploy(SupplyManagingContract);
  console.log("SupplyManaging", SupplyManagingContract.address);

  //console.log(deployer.deployed.address)

  await deployer.deploy(OwnerDataContract);
  console.log("OwnerData", OwnerDataContract.address);
  


  await deployer.deploy(ItemContract, OwnerDataContract.address, SupplyManagingContract.address);
  await deployer.deploy(AuctionContract, OwnerDataContract.address, SupplyManagingContract.address);
};
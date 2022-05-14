// const Contract = artifacts.require("./Contract.sol");
const Contract = artifacts.require("Contract");

module.exports = function(deployer) {
  deployer.deploy(Contract);
};
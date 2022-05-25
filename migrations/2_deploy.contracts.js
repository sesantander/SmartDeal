const Contract = artifacts.require("ContractSC");
const Proposal = artifacts.require("ProposalSC");
const Invoice = artifacts.require("InvoiceSC");
const Transaction = artifacts.require("TransactionSC");

module.exports = function(deployer) {
  deployer.deploy(Contract);
  deployer.deploy(Transaction);
  deployer.deploy(Proposal);
  deployer.deploy(Invoice);
};
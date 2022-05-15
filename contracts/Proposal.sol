// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract ProposalSC {
    uint256 public proposalCount = 0;

    struct Proposal {
        uint256 proposal_id;
        int256 payment_rate;
        string currency;
        string description;
        string scope_of_work;
        string payment_frequency;
        string status;
        uint256 employer_id;
        uint256 contractor_id;
    }

    // event ProposalStatus(uint256 contract_id);

    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(
        uint256 proposal_id,
        int256 payment_rate,
        string currency,
        string description,
        string scope_of_work,
        string payment_frequency,
        string status,
        uint256 employer_id,
        uint256 contractor_id
    );

    constructor() public {
        createProposal(
            2000,
            "USD",
            "Description",
            "3 endpoints",
            "Monthly",
            "Waiting response",
            1,
            1
        );
    }

    function createProposal(
        int256 payment_rate,
        string memory currency,
        string memory description,
        string memory scope_of_work,
        string memory payment_frequency,
        string memory status,
        uint256 employer_id,
        uint256 contractor_id
    ) public {
        proposalCount++;
        Proposal memory proposalInfo;

        proposalInfo.proposal_id = proposalCount;
        proposalInfo.payment_rate = payment_rate;
        proposalInfo.currency = currency;
        proposalInfo.description = description;
        proposalInfo.scope_of_work = scope_of_work;
        proposalInfo.payment_frequency = payment_frequency;
        proposalInfo.status = status;
        proposalInfo.employer_id = employer_id;
        proposalInfo.contractor_id = contractor_id;

        proposals[proposalCount] = proposalInfo;
        emit ProposalCreated(
            proposalCount,
            payment_rate,
            currency,
            description,
            scope_of_work,
            payment_frequency,
            status,
            employer_id,
            contractor_id
        );
    }

    function showBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

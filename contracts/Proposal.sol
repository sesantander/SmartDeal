// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract ProposalSC {
    uint256 public proposalCount = 0;

    struct Proposal {
        uint256 proposal_id;
        int256 payment_rate;
        string scope_of_work;
        string payment_frequency;
        uint256 employer_id;
        uint256 contractor_id;
        string start_date;
        string end_date;
        string contract_type;
    }

    // event ProposalStatus(uint256 contract_id);

    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(
        uint256 proposal_id,
        int256 payment_rate,
        string scope_of_work,
        string payment_frequency,
        uint256 employer_id,
        uint256 contractor_id,
        string start_date,
        string end_date,
        string contract_type
    );

    constructor() public {
        createProposal(
            2000,
            "3 endpoints",
            "Monthly",
            1,
            1,
            "22/05/2022",
            "23/05/2022",
            "Fixed Rate"
        );
    }

    function createProposal(
        int256 payment_rate,
        string memory scope_of_work,
        string memory payment_frequency,
        uint256 employer_id,
        uint256 contractor_id,
        string memory start_date,
        string memory end_date,
        string memory contract_type
    ) public {
        proposalCount++;
        Proposal memory proposalInfo;

        proposalInfo.proposal_id = proposalCount;
        proposalInfo.payment_rate = payment_rate;
        proposalInfo.scope_of_work = scope_of_work;
        proposalInfo.payment_frequency = payment_frequency;
        proposalInfo.employer_id = employer_id;
        proposalInfo.contractor_id = contractor_id;
        proposalInfo.start_date = start_date;
        proposalInfo.end_date = end_date;
        proposalInfo.contract_type = contract_type;

        proposals[proposalCount] = proposalInfo;
        emit ProposalCreated(
            proposalCount,
            payment_rate,
            scope_of_work,
            payment_frequency,
            employer_id,
            contractor_id,
            start_date,
            end_date,
            contract_type
        );
    }

    function showBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

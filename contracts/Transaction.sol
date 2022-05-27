// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract TransactionSC {
    uint256 public transactionCount = 0;

    struct Transaction {
        uint256 transaction_id;
        string withdrawal_date;
        string estimated_arrival;
        string method;
        int256 amount;
        uint256 contract_id;
        string status;
    }

    mapping(uint256 => Transaction) public transactions;

    event TransactionCreated(
        uint256 transaction_id,
        string withdrawal_date,
        string estimated_arrival,
        string method,
        int256 amount,
        uint256 contract_id,
        string status
    );

    constructor() public {
        createTransaction(
            "15/05/2022",
            "15/05/2022",
            "Local Bank",
            300,
            1,
            "Success"
        );
    }

    function createTransaction(
        string memory withdrawal_date,
        string memory estimated_arrival,
        string memory method,
        int256 amount,
        uint256 contract_id,
        string memory status
    ) public {
        transactionCount++;
        Transaction memory transactionInfo;

        transactionInfo.transaction_id = transactionCount;
        transactionInfo.withdrawal_date = withdrawal_date;
        transactionInfo.estimated_arrival = estimated_arrival;
        transactionInfo.method = method;
        transactionInfo.amount = amount;
        transactionInfo.contract_id = contract_id;
        transactionInfo.status = status;

        transactions[transactionCount] = transactionInfo;
        emit TransactionCreated(
            transactionCount,
            withdrawal_date,
            estimated_arrival,
            method,
            amount,
            contract_id,
            status
        );
    }

    function showBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getAddress() external view returns (address) {
        return address(this);
    }
}

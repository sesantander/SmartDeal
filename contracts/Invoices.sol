// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract InvoiceSC {
    uint256 public invoiceCount = 0;

    struct Invoice {
        uint256 invoice_id;
        string bill_from;
        string bill_to;
        string status;
        string due_date;
        string paid_date;
        string description;
        int256 amount;
        uint256 transaction_id;
    }

    mapping(uint256 => Invoice) public invoices;

    event InvoiceCreated(
        uint256 invoice_id,
        string bill_from,
        string bill_to,
        string status,
        string due_date,
        string paid_date,
        string description,
        int256 amount,
        uint256 transaction_id
    );

    constructor() public {
        createInvoice(
            "Jamar",
            "Jesus Romero",
            "Transfered",
            "30/05/2022",
            "30/05/2022",
            "",
            1800000,
            1
        );
    }

    function createInvoice(
        string memory bill_from,
        string memory bill_to,
        string memory status,
        string memory due_date,
        string memory paid_date,
        string memory description,
        int256 amount,
        uint256 transaction_id
    ) public {
        invoiceCount++;
        Invoice memory invoiceInfo;

        invoiceInfo.invoice_id = invoiceCount;
        invoiceInfo.bill_from = bill_from;
        invoiceInfo.bill_to = bill_to;
        invoiceInfo.status = status;
        invoiceInfo.due_date = due_date;
        invoiceInfo.paid_date = paid_date;
        invoiceInfo.description = description;
        invoiceInfo.amount = amount;
        invoiceInfo.transaction_id = transaction_id;

        invoices[invoiceCount] = invoiceInfo;
        emit InvoiceCreated(
            invoiceCount,
            bill_from,
            bill_to,
            status,
            due_date,
            paid_date,
            description,
            amount,
            transaction_id
        );
    }

    function showBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Contract {
    uint256 public contractCount = 0;

    struct Contract{
       uint256 contract_id;
       string contract_type;
       string contract_name;
       string job_title;
       string status;
       string scope_of_work;
       string start_date;
       string end_date;
    }

    struct ContractDetails{
       uint256 contract_id;
       string currency;
       int256 payment_rate;
       string payment_frequency;
       string payment_due;
       uint256 employer_id;
       uint256 contractor_id;
       uint256 proposal_id;
    }

    event ContractCompleted(uint256 contract_id);

    mapping(uint256 => Contract) public contracts;
    mapping(uint256 => ContractDetails) public contracts_details;

    event ContractCreated(
        uint256 contract_id,
        string contract_type,
        string contract_name,
        string job_title,
        string status,
        string scope_of_work,
        string start_date,
        string end_date
      );

    event ContractDetailsCreated(
        uint256 contract_id,
        string currency,
        int256 payment_rate,
        string payment_frequency,
        string payment_due,
        uint256 employer_id,
        uint256 contractor_id,
        uint256 proposal_id
    );

    constructor() public {
        createContract("Contractor", "Test Contract","Backend Developer","Both parties agreed","5 endpoints","15/05/2022","20/05/2022");
        createContractDetails("COP", 1800000, "Monthly", "30", 1, 1, 1);
    }

    function createContract(
        string memory contract_type,
        string memory contract_name,
        string memory job_title,
        string memory status,
        string memory scope_of_work,
        string memory start_date,
        string memory end_date       
        ) public {
        contractCount++;
        Contract memory contractInfo;
     
        contractInfo.contract_id = contractCount;
        contractInfo.contract_type = contract_type;
        contractInfo.contract_name = contract_name;
        contractInfo.job_title = job_title;
        contractInfo.status = status;
        contractInfo.scope_of_work = scope_of_work;
        contractInfo.start_date = start_date;
        contractInfo.end_date = end_date;

        contracts[contractCount] = contractInfo;
        emit ContractCreated(contractCount, contract_type, contract_name, job_title ,status,scope_of_work,start_date,end_date);
    }

    function createContractDetails(
        string memory currency,
        int256 payment_rate,
        string memory payment_frequency,
        string memory payment_due,
        uint256 employer_id,
        uint256 contractor_id,
        uint256 proposal_id
        ) public {
      
        ContractDetails memory contractDetails;

        contractDetails.contract_id = contractCount;
        contractDetails.currency = currency;
        contractDetails.payment_rate = payment_rate;
        contractDetails.payment_frequency = payment_frequency;
        contractDetails.payment_due = payment_due;
        contractDetails.employer_id = employer_id;
        contractDetails.contractor_id = contractor_id;
        contractDetails.proposal_id = proposal_id;

        contracts_details[contractCount]= contractDetails;
        emit ContractDetailsCreated(contractCount, currency, payment_rate, payment_frequency ,payment_due, employer_id, contractor_id, proposal_id);
    }

    // funcion para para marcar como completa una tarea
    // function markCompleted(uint256 _id) public {
    //   Contract memory _task = tasks[_id];
    //   _task.completed = !_task.completed;
    //   tasks[_id] = _task;
    //   emit ContractCompleted(_id, _task.completed);
    // }

    // funcion para enviar ether del contrato hacia una direccion
    // function sendEther(address payable recipient, uint reward) external {
    //   uint money = reward * 1 ether;
    //   recipient.transfer(money);
    // }

    // funcion para obtener el valor de la recompensa de cada task
    // function getTaskReward(uint256 _id) external view returns(uint){
    //   Task memory _task = tasks[_id];
    //   return _task.reward;
    // }

    // funcion para depositar ether en el smart contract
    function() external payable {}

    // funcion para mostrar cuanto ether tiene este smart contract
    function showBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

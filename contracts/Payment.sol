// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Payment contract for handling escrow and fund transactions
contract Payment {
    // Mapping to store the amount of funds in escrow for each job
    mapping(uint256 => uint256) public escrow;

    // Event emitted when funds are deposited into escrow
    event FundsDeposited(uint256 jobId, address indexed payer, uint256 amount);

    // Function to allow the buyer to deposit funds into escrow for a specific job
    function depositFunds(uint256 jobId) external payable {
        // Require that the deposited amount is greater than 0
        require(msg.value > 0, "Deposit amount must be greater than 0");
        
        // Add the deposited amount to the escrow for the specified job
        escrow[jobId] += msg.value;

        // Emit an event to log the funds deposit
        emit FundsDeposited(jobId, msg.sender, msg.value);
    }

    // Function to release funds from escrow to a specified recipient (e.g., service provider)
    function releaseFunds(uint256 jobId, address payable recipient) external {
        // Require that there are funds in escrow for the specified job
        require(escrow[jobId] > 0, "No funds in escrow");

        // Retrieve the amount of funds in escrow for the specified job
        uint256 amount = escrow[jobId];

        // Reset the escrow amount for the specified job to 0
        escrow[jobId] = 0;

        // Transfer the funds from escrow to the specified recipient
        recipient.transfer(amount);
    }
}

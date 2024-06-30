// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract EtherManager {
address public immutable contractOwner;

event FundsReceived(address indexed sender, uint256 amount);
event FundsWithdrawn(address indexed recipient, uint256 amount);

modifier onlyOwner() {
require(msg.sender == contractOwner, "Caller is not the owner");
_;
}

constructor() payable {
contractOwner = msg.sender;
if (msg.value > 0) {
emit FundsReceived(msg.sender, msg.value);
}
}

// Fallback function to handle unexpected calls and receive Ether
fallback() external payable {
emit FundsReceived(msg.sender, msg.value);
}

// Function to receive Ether directly
receive() external payable {
emit FundsReceived(msg.sender, msg.value);
}

// Function to withdraw specified amount of Ether from the contract
function withdraw(uint256 amount) external onlyOwner {
require(address(this).balance >= amount, "Insufficient contract balance");
payable(contractOwner).transfer(amount);
emit FundsWithdrawn(contractOwner, amount);
}

// Function to check the current balance of the contract
function getContractBalance() external view returns (uint256) {
return address(this).balance;
}

// Function to deposit Ether with a minimum required amount
function depositWithMinimum(uint256 minimum) external payable {
require(msg.value >= minimum, "Deposit amount is less than the minimum required");
emit FundsReceived(msg.sender, msg.value);
}

// Function to demonstrate the use of assert
function toggleState(bool currentState) view external onlyOwner {
bool newState = !currentState;
assert(newState != currentState); // This should always be true
}

// Function to demonstrate the use of revert
function conditionalRevert(bool condition) external pure {
if (condition) {
revert("Condition met, transaction reverted");
}
}
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ExpenseManagerContract {
    uint256 public balance;

    // Mapping to keep track of balances by account
    mapping(address => uint256) public accountsBalance;

    // Deposit function to increase balance of the contract
    function setDeposit(address sender) public payable {
        accountsBalance[sender] += msg.value;
        balance += msg.value;
    }

    // Get the balance of the contract
    function getBalance() public view returns (uint256) {
        return balance;
    }

    // Transfer funds between two addresses
    function transfer(address sender, address recipient, uint256 amount) public {
        require(accountsBalance[sender] >= amount, "Insufficient balance");
        accountsBalance[sender] -= amount;
        accountsBalance[recipient] += amount;
    }

    // Get the balance of a specific account
    function getAccountBalance(address account) public view returns (uint256) {
        return accountsBalance[account];
    }
}

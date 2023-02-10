// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AntiSnipe {
    uint256 public totalSupply;
    uint256 public minimumBlockTime;
    mapping(address => uint256) public balances;
    mapping(address => bool) public blacklist;
    mapping(address => uint256) public timestamps;


    constructor() {
        totalSupply = 0;
        minimumBlockTime=16;
    }

    function buy() public payable {
        require(!blacklist[msg.sender], "You are blacklisted!");
        if (
            timestamps[msg.sender] != 0 ||
            block.timestamp - timestamps[msg.sender] <= 16
        ) {
            blacklist[msg.sender] = true;
            require(
                block.timestamp - timestamps[msg.sender] > 16,
                "You are blacklisted."
            );
        }

        uint256 amount = msg.value / 1 ether;
        require(amount > 0, "Amount must be greater than zero.");

        totalSupply += amount;
        balances[msg.sender] += amount;
        timestamps[msg.sender] = block.timestamp;
    }

    function blacklistAddress(address _address) public {
        blacklist[_address] = true;
    }
}

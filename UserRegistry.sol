// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract UserRegistry {
    mapping(address => string) users;

    function registerUser(string memory _name) public {
        users[msg.sender] = _name;
    }

    function getUser(address _userAddress) public view returns (string memory) {
        return users[_userAddress];
    }
}

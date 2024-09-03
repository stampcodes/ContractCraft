// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract AccessControl {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function setOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function restrictedAction() public view onlyOwner returns (string memory) {
        return "azione eseguita!";
    }
}

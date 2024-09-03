// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract SimpleToken {
    uint public totalSupply;
    mapping(address => uint) balances;
    address public admin;

    event Transfer(address indexed from, address indexed to, uint amount);
    event Mint(address indexed admin, uint amount);
    event TokensAssigned(address indexed to, uint amount);

    constructor(uint _totalSupply) {
        admin = msg.sender;
        totalSupply = _totalSupply;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "You are not the admin");
        _;
    }

    function mint(uint _addToken) public onlyAdmin {
        totalSupply += _addToken;
        emit Mint(msg.sender, _addToken);
    }

    function giveToken(
        address _userAddress,
        uint _amountOfToken
    ) public onlyAdmin {
        require(totalSupply >= _amountOfToken, "Not enough tokens available");
        totalSupply -= _amountOfToken;
        balances[_userAddress] += _amountOfToken;
        emit TokensAssigned(_userAddress, _amountOfToken);
    }

    function transfer(address _userAddress, uint _amountOfToken) public {
        require(balances[msg.sender] >= _amountOfToken, "Not enough token");
        require(_userAddress != address(0), "the address doesn't exist");
        balances[msg.sender] -= _amountOfToken;
        balances[_userAddress] += _amountOfToken;
        emit Transfer(msg.sender, _userAddress, _amountOfToken);
    }

    function balanceOf(address _userAddress) public view returns (uint) {
        return balances[_userAddress];
    }
}

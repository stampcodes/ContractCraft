// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract WeightedVoting {
    uint public totalShares = 1000;
    mapping(address => uint) public shares;
    address public admin;

    struct Proposal {
        address whoMadeTheProposal;
        string description;
        uint count;
        uint weightedVoteCount;
        mapping(address => bool) hasVoted;
    }
    mapping(uint => Proposal) public proposals;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    modifier idNotRegistered(uint _proposalsId) {
        require(
            proposals[_proposalsId].whoMadeTheProposal == address(0),
            "The Id is already taken"
        );
        _;
    }

    modifier idRegistered(uint _proposalsId) {
        require(
            proposals[_proposalsId].whoMadeTheProposal != address(0),
            "The Id doesn't exist"
        );
        _;
    }

    function addShares(uint _howManyShares) public onlyAdmin {
        totalShares += _howManyShares;
    }

    function removeShares(uint _howManyShares) public onlyAdmin {
        totalShares -= _howManyShares;
    }

    function giveShares(
        address _userAddress,
        uint _amountOfShares
    ) public onlyAdmin {
        require(totalShares > 0, "the shares is finished");
        require(_amountOfShares <= totalShares, "not enough shares available");
        shares[_userAddress] += _amountOfShares;
        totalShares -= _amountOfShares;
    }

    // function addProposal (uint _newProposalId, string memory _description) public idNotRegistered(_newProposalId) {
    //     proposals[_newProposalId] = Proposal(msg.sender, _description, 0, 0);
    // }

    function addProposal(
        uint _newProposalId,
        string memory _description
    ) public idNotRegistered(_newProposalId) {
        Proposal storage newProposal = proposals[_newProposalId];
        newProposal.whoMadeTheProposal = msg.sender;
        newProposal.description = _description;
        newProposal.count = 0;
        newProposal.weightedVoteCount = 0;
    }

    function vote(uint _proposalId) public idRegistered(_proposalId) {
        require(
            !proposals[_proposalId].hasVoted[msg.sender],
            "You have already voted."
        );
        require(shares[msg.sender] > 0, "You have no shares to vote with.");
        proposals[_proposalId].hasVoted[msg.sender] = true;
        proposals[_proposalId].count++;
        proposals[_proposalId].weightedVoteCount += shares[msg.sender];
    }

    function result(uint _proposalId) public view returns (uint, uint) {
        return (
            proposals[_proposalId].count,
            proposals[_proposalId].weightedVoteCount
        );
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract SimpleDAO {
    enum Role {
        None,
        Member,
        Admin,
        Moderator
    }
    mapping(address => Role) public roles;

    struct Proposal {
        address whoMadeTheProposal;
        string description;
        uint count;
        mapping(address => bool) hasVoted;
        uint deadline;
    }

    mapping(uint => Proposal) proposals;

    constructor() {
        roles[msg.sender] = Role.Admin;
    }

    modifier onlyAdmin() {
        require(roles[msg.sender] == Role.Admin, "You are not the Admin");
        _;
    }

    modifier onlyMemberOrHigher() {
        require(
            roles[msg.sender] == Role.Member ||
                roles[msg.sender] == Role.Admin ||
                roles[msg.sender] == Role.Moderator,
            "You do not have the correct role"
        );
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

    function addMember(address _newMember) public onlyAdmin {
        roles[_newMember] = Role.Member;
    }

    function addModerator(address _newModerator) public onlyAdmin {
        roles[_newModerator] = Role.Moderator;
    }

    function removeMember(address _removedMember) public onlyAdmin {
        roles[_removedMember] = Role.None;
    }

    function removeModerator(address _removedModerator) public onlyAdmin {
        roles[_removedModerator] = Role.None;
    }

    function addProposal(
        uint _newProposalId,
        string memory _description
    ) public onlyMemberOrHigher idNotRegistered(_newProposalId) {
        Proposal storage newProposal = proposals[_newProposalId];
        newProposal.whoMadeTheProposal = msg.sender;
        newProposal.description = _description;
        newProposal.count = 0;
        newProposal.deadline = block.timestamp + (15 * 60);
    }

    function vote(
        uint _proposalId
    ) public onlyMemberOrHigher idRegistered(_proposalId) {
        require(
            !proposals[_proposalId].hasVoted[msg.sender],
            "You have already voted."
        );
        require(
            block.timestamp < proposals[_proposalId].deadline,
            "The vote time is finished"
        );
        proposals[_proposalId].hasVoted[msg.sender] = true;
        proposals[_proposalId].count++;
    }

    function result(uint _proposalId) public view returns (uint) {
        return (proposals[_proposalId].count);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract ProposalManager {
    struct Proposal {
        address whoMadeTheProposal;
        string description;
        int count;
        mapping(address => bool) hasVoted;
    }

    mapping(uint => Proposal) proposals;

    function createProposal(
        uint _proposalId,
        string memory _description
    ) public {
        Proposal storage newProposal = proposals[_proposalId];
        newProposal.whoMadeTheProposal = msg.sender;
        newProposal.description = _description;
        newProposal.count = 0;
    }

    function voteOnProposal(uint _proposalId) public {
        require(
            !proposals[_proposalId].hasVoted[msg.sender],
            "You have already voted."
        );
        proposals[_proposalId].hasVoted[msg.sender] = true;
        proposals[_proposalId].count++;
    }
}

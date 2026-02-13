// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GrantDAO Contract
/// @notice DAO-based grant distribution system.
contract GrantDAO {

    struct Proposal {
        address recipient;
        uint256 amount;
        uint256 votes;
        bool executed;
    }
    
    Proposal[] public proposals;
    mapping(uint256 => mapping(address => bool)) public voted;
    
    function propose(address _recipient, uint256 _amount) external {
        proposals.push(Proposal({
            recipient: _recipient,
            amount: _amount,
            votes: 0,
            executed: false
        }));
    }
    
    function vote(uint256 _id) external {
        require(!voted[_id][msg.sender], "Voted");
        voted[_id][msg.sender] = true;
        proposals[_id].votes++;
    }
    
    function execute(uint256 _id) external {
        Proposal storage p = proposals[_id];
        require(!p.executed, "Executed");
        require(p.votes > 5, "Not enough votes"); // Simplified quorum
        
        p.executed = true;
        payable(p.recipient).transfer(p.amount);
    }
    
    receive() external payable {}

}

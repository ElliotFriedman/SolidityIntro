pragma solidity ^0.4.24;

contract Vote
{
	mapping (address => bool) public hasVoted;

	uint public partyA;
	uint public partyB;

	modifier hasNotVoted()
	{
		require(!hasVoted[msg.sender]);
		hasVoted[msg.sender] = true;
		_;
	}
	
	function voteA() public hasNotVoted
	{
		partyA++;
	}

	function voteB() public hasNotVoted
	{
		partyB++;
	}

	function whoWon() public view returns (string)
	{
		if (partyA > partyB)
			return ("Party A Won");
		if (partyA < partyB)
			return ("Party B Won");
		return ("Tie, neither party won");
	}

}


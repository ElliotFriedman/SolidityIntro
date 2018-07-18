solidity ^0.4.24;

contract Month {
	/*
	   integrate with an address to check that the creattor
	   can't drain the contract

	 */


	uint8 private find;
	uint256 private amt = 1 ether;
	event GuessCorrect(string answer);

	constructor() public payable
	{
		if (msg.value == (amt)){
			find = 5;
		}
		else
			revert();
	}

	function guess (uint8 guessa) public payable
	{
		if (msg.value == amt/10 && guessa == find)
		{
			msg.sender.transfer(amt/10);
			emit GuessCorrect("Correct");
		}
		else if (msg.value == amt/10)
			emit GuessCorrect("Incorrect");
		else
			emit GuessCorrect("improper funds transffered");
	}


	function returnBalance() public view returns (uint256){
		return address(this).balance;
	}
}

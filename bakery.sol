pragma solidity ^0.4.24;

contract Cake {
	string public flavor;

	constructor (string nflav) public {
		flavor = nflav;
	}

	function getter () public view returns (string) {
		return flavor;
	}

	function cAddress() public view returns (address) 
	{
		return address(this);
	}
}

contract BakeryFactory 
{
	mapping (address => address) cakeOwner;
	event verify(address cowner, address contractcake);

	function create_cake(string flavor) public payable
	{
		require(msg.value == 10000000000000000 && cakeOwner[msg.sender] == 0);
		cakeOwner[msg.sender] = new Cake(flavor);
	}

	function getCake() public returns (address)
	{
		require(cakeOwner[msg.sender] != 0);
		emit verify(msg.sender, cakeOwner[msg.sender]);
		return cakeOwner[msg.sender];
	}
	function sendCake(address to) public returns (bool)
	{
		if (cakeOwner[msg.sender] != 0)
		{
			cakeOwner[to] = cakeOwner[msg.sender];
			cakeOwner[msg.sender] = 0;
			return true;
		}
		return false;
	}
}

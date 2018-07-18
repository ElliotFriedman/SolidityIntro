pragma solidity ^0.4.24;

contract Addition {

	uint public sum;

	function add(uint a, uint b) public returns (uint) {
		sum = a + b;
		return sum;
	}
}

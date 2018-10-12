pragma solidity ^0.4.24;

library SafeMath
{
	function add(uint a, uint b) public pure returns (uint)
	{
		uint ret = a + b;
		require(ret >= a);
		return ret;
	}

	function subtract(uint a, uint b) public pure returns (uint)
	{
		require(a >= b);
		return a - b;
	}

	//don't need modulus, subtraction, or multiplilcation in
	//our contract, so don't need to pay gas to deploy
}

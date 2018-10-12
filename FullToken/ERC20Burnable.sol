pragma solidity ^0.4.24;

import "./SafeMath.sol";

contract ERC20Burnable
{
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
  event Transfer(address indexed from, address indexed to, uint tokens);

  using SafeMath for uint;
	//create a mapping to hold a user's address
	mapping (address => uint) public tokens;

	//control who can receive coins
	mapping (address => bool) public receiver;

	//authorize people to send tokens on your behalf
	mapping (address => mapping (address => uint)) authorize;

	//owner
	address public owner;

	//the total amount of tokens
	uint tokenAmt = 10000000;

	string public tokenName = "Badium";
	string public symbol = "BDM";

	address[] public allAddresses;
	uint avail = 10000000;

	constructor () public
	{
		//define the owner
		owner = msg.sender;
		//give the owner all 10,000,000 tokens
		tokens[owner] = tokenAmt;
		//owner is authorized to receive funds
		receiver[owner] = true;
		//owner is an address of someone who owns tokens
		allAddresses.push(owner);
	}

	function approve(address spender, uint amt) public returns (bool)
	{
		authorize[msg.sender][spender] = amt;
		emit Approval(msg.sender, spender, amt);
		return true;
	}

	//get an allowance for a person
	function allowance(address tokenOwner, address delegate) public view returns (uint)
	{
		return authorize[tokenOwner][delegate];
	}

	//make an onlyowner modifier, we only want the owner to be able to access certain functions
	modifier onlyOwner()
	{
		require(msg.sender == owner);
		_;
	}

	function allowNewReceiver(address allowed) external onlyOwner
    {
        //this person can now receive tokens
        receiver[allowed] = true;
    }

    function disallowReceiver(address disallowed) external onlyOwner
    {
        //this person can no longer receive tokens
        receiver[disallowed] = false;
    }

	//burn function
	function burnAddress(address burn) external onlyOwner
	{
	    //subtract this amount of tokens from the total supply
	    tokenAmt = tokenAmt.subtract(tokens[burn]);
		tokens[burn] = 0;
	}

	//iterate all addresses that have tokens, and zero out their balances
	function burnAll() external onlyOwner
	{
		for (uint i = 0; i < allAddresses.length; i++)
		{
			tokens[allAddresses[i]] = 0;
		}
		//token amount is now 0
		tokenAmt = 0;
	}

	//owner can mint an infinite amount of new tokens
	function mint(uint amt) external onlyOwner
	{
		tokens[owner] = tokens[owner].add(amt);
		//make sure that we update total token amount to reflect changes made by minting these new tokens
		tokenAmt = tokenAmt.add(amt);
	}

	//get the total supply
	function totalSupply() public view returns (uint256)
	{
		return tokenAmt;
	}
}

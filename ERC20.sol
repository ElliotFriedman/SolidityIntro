solidity ^0.4.24;

contract ERC20
{
	string public TokenName = "eCoin";
	mapping (address => uint256) public tokenOwner;
	address public creator;
	uint256 public token;
	uint256 public avail;

	event transferstatus(string yn);

	constructor (uint256 init) public
	{
		token = init;
		avail = init;
		tokenOwner[msg.sender] = token;
		creator = msg.sender;
	}

	modifier onlyOwner 
	{
		require(msg.sender == creator);
		_;
	}

	function withdrawEth(uint weiAmt) onlyOwner external payable
	{
		require(this.balance >= weiAmt);
		msg.sender.transfer(weiAmt);
	}

	//for external and non ICO transfers
	function transfer(address sendto, uint amt) public
	{
		require(tokenOwner[msg.sender] >= amt);
		tokenOwner[msg.sender] -= amt;
		tokenOwner[sendto] += amt;
		emit transferstatus("success");
	}

	//has to be internal
	function transferTokens(address sendfrom, address sendto, uint amt) internal
	{
		require(tokenOwner[sendfrom] >= amt);
		tokenOwner[sendfrom] -= amt;
		tokenOwner[sendto] += amt;
		//check if avail is ruining it
		avail -= amt;
	}

	function buyTokens() public payable
	{
		//need to guard against division by 0
		require(msg.value >= 1000000000000000);
		uint256 amt = msg.value / 1000000000000000;
		require(msg.value != 0 && tokenOwner[creator] >= amt && amt < avail);
		transferTokens(creator, msg.sender, amt);
	}

	function get_tokenamt() view public returns (uint)
	{
		return (tokenOwner[msg.sender]);
	}
}

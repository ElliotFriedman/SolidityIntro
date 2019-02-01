pragma solidity ^0.5.1;

contract simpleTCR {
    
    uint256 depositPrice;
    uint8 constant totalListings = 10;
    mapping (uint8 => bool) indexFree;
    
    mapping (address => uint256) public tokenBalance;
    mapping (address => uint256) public tokenDeposited;
    mapping (uint8 => Listing) listed;
    
    struct Listing {
        string  businessName;
        string  businessAddress;
        int40   phoneNumber;
        bool    isListed;
        address businessOwner;
    }
    
    constructor() public
    {
        tokenBalance[address(0)] = 1000000000000000000;
        depositPrice = 100;
    }

    function sendTokens(address sendto, uint amt) public
	{
		require(tokenBalance[msg.sender] >= amt);
		tokenBalance[msg.sender] -= amt;
		tokenBalance[sendto] += amt;
	}

    function transferTokens(address sendfrom, address sendto, uint amt) internal
	{
		require(tokenBalance[sendfrom] >= amt);
		tokenBalance[sendfrom] -= amt;
		tokenBalance[sendto] += amt;
	}
    
    function buyTokens() public payable
	{
		require(msg.value >= 1000000000000000);
		uint256 amt = msg.value / 1000000000000000;
		require(msg.value != 0 && tokenBalance[address(0)] >= amt);
		transferTokens(address(0), msg.sender, amt);
	}

    function createListing(string memory _businessName, string memory _businessAddress, int40 _phoneNumber) public
    {
        //if there isn't a free index we revert
        uint8 index = getFreeIndex();
        require(index < totalListings);
        require(!indexFree[index]);
        require(tokenBalance[msg.sender] >= depositPrice);
        
        //set the current index to being used and withdraw tokens from person
        indexFree[index] = true;
        tokenBalance[msg.sender] -= depositPrice;
        tokenDeposited[msg.sender] += depositPrice;
        
        listed[index] = Listing({businessName: _businessName,
           businessAddress: _businessAddress,
            phoneNumber: _phoneNumber, 
            isListed: true, 
            businessOwner: msg.sender});
    }
    
    function getFreeIndex() public view returns (uint8)
    {
        for (uint8 i = 0; i < 10; i++)
        {
            if (indexFree[i] == false)
                return i;
        }
        //error code
        require(false, "Error, no free slots");
        return 255;
    }
    
    function destroyListing(uint8 index) public
    {
        require(index < totalListings);
        
        require(listed[index].businessOwner == msg.sender);
        require(listed[index].isListed == true);

        indexFree[index] = false;
    }
    
    function getBusiness(uint8 index) public view returns (string memory, string memory, int40, bool, address)
    {
        return (listed[index].businessName,
            listed[index].businessAddress,
            listed[index].phoneNumber,
            listed[index].isListed,
            listed[index].businessOwner);
    }
 
}

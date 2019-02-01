pragma solidity ^0.5.1;

contract simpleTCR {
    
    uint256 depositPrice;
    uint8 constant totalListings = 10;
    uint8 currentListingIndex;
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
        require(currentListingIndex < totalListings);
        require(!indexFree[currentListingIndex]);
        require(tokenBalance[msg.sender] >= depositPrice);
        
        indexFree[currentListingIndex] = true;
        tokenBalance[msg.sender] -= depositPrice;
        tokenDeposited[msg.sender] += depositPrice;
        
        listed[currentListingIndex] = Listing({businessName: _businessName,
        businessAddress: _businessAddress,
        phoneNumber: _phoneNumber, 
        isListed: true, 
        businessOwner: msg.sender});
        
        currentListingIndex++;
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

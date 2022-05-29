// ---------------- CityCoin-ctc -----------------------
//
//   This is the white list of wallets that supported CityCoin.
//
//       We are grateful for all support
//
//           https://citycoin-ctc.com/
//
//
// ------------------------------------------------------

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Whitelist {

    address owner;
    address[] list;

    mapping(address => bool)  whitelistedAddresses;

    constructor() {
      owner = msg.sender;
    }

    modifier onlyOwner() {
      require(msg.sender == owner, "Ownable: caller is not the owner");
      _;
    }

    modifier isWhitelisted(address _address) {
      require(whitelistedAddresses[_address], "Whitelist: You need to be whitelisted");
      _;
    }
    
    // deployed contract address 0x7e940B066d850927eA086f795597A5Ff197D8e62

    function addUser(address _addressToWhitelist) public onlyOwner {
      require(whitelistedAddresses[_addressToWhitelist]==false, "this address already exists");
      whitelistedAddresses[_addressToWhitelist] = true;
      list.push(_addressToWhitelist);
    }

    function deployList() public view returns (address[] memory) {
        return list;
    }

    function verifyUser(address _whitelistedAddress) public view returns(bool) {
      bool userIsWhitelisted = whitelistedAddresses[_whitelistedAddress];
      return userIsWhitelisted;
    }    

    function verifyMyWallet() public view isWhitelisted(msg.sender) returns(bool){
      return (true);
    }

}

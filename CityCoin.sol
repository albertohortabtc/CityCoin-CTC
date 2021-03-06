// ---------------- CityCoin-ctc -----------------------
//
//    CityCoin the city of the future.
//    CTC is the official currency of 
//    CityCoin with a Maximum of 
//      21,000,000 coins
//   
//           
//       https://citycoin-ctc.com/
//
// ------------------------------------------------------

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract CityCoin is ERC20, ERC20Burnable, ERC20Permit, ERC20Votes {
    
    address constant main_wallet = 0xaC79f551016e82Ba620c3a948Ec948a407Ace10e;


    constructor() ERC20("CityCoin", "CTC") ERC20Permit("CityCoin") {
        _mint(main_wallet, 21000000 * 10 ** decimals());
    }

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
}

// address contract 0xc7D495D8BA942d62e69ba5c617A8575beA35717a

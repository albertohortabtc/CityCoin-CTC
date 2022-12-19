// ---------------- CityCoin-ctc -----------------------
//
//           Reward CityBot Founder Pass Palladium
//
//  Founders who got NFT palladium pass, will be rewarded
//   with profit from our services on this smart contract
//   
//    Pälladium NFT Contract  0x0862f60Bb7C9c0B8d81388676ED1430F62D1cA6c
//           
//       https://citycoin-ctc.com/
//
//       Date: 07/20/2022
// ------------------------------------------------------

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract FoundersRewards_CityCoin {
    IERC20 public stakingToken;
    IERC721  founderPassPalladium_721;
    ERC721Enumerable  founderPassPalladium_enum;
    
    address public owner;
    uint256  reward;
    uint256  spare;


    
    bool public isAvailable = true;
    
    mapping(address => uint)  rewards;

    constructor(address _stakingToken,address _founderPassPalladium) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);     
        founderPassPalladium_721 = IERC721(_founderPassPalladium);
        founderPassPalladium_enum= ERC721Enumerable(_founderPassPalladium);
    }

    function rewardFounder(address _wallet) public view returns (uint256) {

        uint256 global_balance = 0;
        for (uint i = 0; i < founderPassPalladium_enum.totalSupply(); i++) {            
                 global_balance+=rewards[founderPassPalladium_721.ownerOf(i)];              
        }
        global_balance+=spare;

        if((global_balance==0)&&(stakingToken.balanceOf(address(this))==0))
        {
           return 0;
        }
        
         if(stakingToken.balanceOf(address(this))>global_balance)
        {
            uint256 balance_reward= (((stakingToken.balanceOf(address(this))-global_balance)/founderPassPalladium_enum.totalSupply())*founderPassPalladium_721.balanceOf(_wallet))+rewards[_wallet];
            return balance_reward;
        }
        

        if(rewards[_wallet]>0){
                return rewards[_wallet];  
        }      
        return 0;
           
    }


    function claimReward() public{    
         require(isAvailable == true, "The Payment is Paused"); 
        reward=0;

        for (uint i = 0; i < founderPassPalladium_enum.totalSupply(); i++) {
            reward+=rewards[founderPassPalladium_721.ownerOf(i)];
        }
        reward+=spare;

        if(stakingToken.balanceOf(address(this))>(reward+spare)){
            uint256 pay =(stakingToken.balanceOf(address(this))-reward)/founderPassPalladium_enum.totalSupply(); 
                for (uint i = 0; i < founderPassPalladium_enum.totalSupply(); i++) {
                rewards[founderPassPalladium_721.ownerOf(i)] += pay;
                reward+=pay;
            }
            spare=stakingToken.balanceOf(address(this))-reward;
        }
        uint256 payment = rewards[msg.sender];
        reward -=payment;
        rewards[msg.sender]=0;
        stakingToken.transfer(msg.sender,payment);        
        
    }



    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership(address _newOwner) external onlyOwner{
        owner = _newOwner;
    }
    function pause() public onlyOwner{
        isAvailable = false;
    }
    function unpause() public onlyOwner{
        isAvailable = true;
    }
}

interface ERC721Enumerable  {
    function totalSupply() external view returns (uint256);
}

// Contract Address:  0x7Aa1990Ba16CCbdC737d3B71752C22F03140cEa4

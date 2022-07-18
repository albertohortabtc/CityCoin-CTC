// ---------------- CityCoin-ctc -----------------------
//
//          Stake Reward System
//
// The staking system is designed to receive rewards for 
// keeping your CityCoin within the contract and if you 
// are a holder of a palladium pass the reward is X2
//   
//           
//       https://citycoin-ctc.com/
//
// ------------------------------------------------------

// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract StakingRewards_CityCoin {
    IERC20 public stakingToken;
    IERC20 public rewardsToken;
    IERC20 public founderPassPalladium;
    
    uint public rewardRate = 2;
    uint public lastUpdateTime;
    uint public rewardPerTokenStored;
    
    address public owner;
    
    bool public isAvailable = true;
    
    mapping(address => uint) public userRewardPerTokenPaid;
    mapping(address => uint) public rewards;
    mapping(address => uint) public stakeStart;

    uint public _totalSupply;
    mapping(address => uint) public _balances;
    
    
    event StartStaked(address indexed owner, uint _amount, uint _time);
    event WitdrawStaked(address indexed owner, uint _amount, uint _time, bool _withPenalty);
    event WitdrawRewards(address indexed owner, uint _amount, uint _time, bool _withPenalty);
    
    
    constructor(address _stakingToken, address _rewardsToken, address _founderPassPalladium) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
        founderPassPalladium = IERC20(_founderPassPalladium);
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

    // ------------------       Program main() ----------------------------------------------
    
    function rewardPerToken() public view returns (uint) {
         if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
          rewardPerTokenStored + (((block.timestamp - lastUpdateTime)*rewardRate  * 1e18)/(2592000*100));    //2592000 sec month and 100 div percentage     
    } 

    function earned(address account) public view returns (uint) {    
          if((founderPassPalladium.balanceOf(account))>0)
           {
               return
                    (((_balances[account] * (rewardPerToken() - userRewardPerTokenPaid[account]))*2*founderPassPalladium.balanceOf(account)) /1e18) +  rewards[account];

           }else{
                return
                  ((_balances[account] * (rewardPerToken() - userRewardPerTokenPaid[account])) /1e18) +  rewards[account];

           }  
    }
    
    modifier updateReward(address account) {

        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;

        rewards[account] = earned(account);
        userRewardPerTokenPaid[account] = rewardPerTokenStored;
        _;
    }
    
    function changeRate(uint _newRate) public onlyOwner{
        rewardRate = _newRate;
    }
    
    function stake(uint _amount) external updateReward(msg.sender) {
        require(isAvailable == true, "The Staking is Paused");
        _totalSupply += _amount;
        _balances[msg.sender] += _amount;
        stakeStart[msg.sender] = block.timestamp;
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        
        emit StartStaked(msg.sender, _amount, block.timestamp);
    }
    
    function withdraw(uint256 _amount) external updateReward(msg.sender) {
        require(_balances[msg.sender] > 0, "You don't have any tokens Staked");
        require(_balances[msg.sender] >= _amount, "You don't have enought tokens in Staking");       
     
            _totalSupply -= _amount;
            _balances[msg.sender] -= _amount;
            stakingToken.transfer(msg.sender, _amount);          
            emit WitdrawStaked(msg.sender, _amount, block.timestamp, false);       
    }

    function getReward() external updateReward(msg.sender) {     
      
            uint reward = rewards[msg.sender];
            rewards[msg.sender] = 0;   
            stakingToken.transferFrom(address(rewardsToken), msg.sender,reward);         
            emit WitdrawRewards(address(rewardsToken), reward, block.timestamp, false);    
        
    }   
    
    
    function getStaked(address _account) external view returns(uint){
        return _balances[_account];
    }
    
    
}


interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

// Contract Address 0x24ee2948b2fc148f50fedcd827f522a3611b1e50

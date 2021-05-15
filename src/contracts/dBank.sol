// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {

  Token private token;

  //add mappings (= python dictionary)
  mapping(address => uint) public etherBalanceOf;
  mapping(address => uint) public depositStart;
  mapping(address => bool) public isDeposited;

  //add events
  event Deposit(address indexed user, uint etherAmount, uint timeStart);
  event Withdraw(address indexed user, uint userBalance, uint depositTime, uint interest);

  //pass as constructor argument deployed Token contract
  constructor(Token _token) public {
    token = _token;
  }
 
  function deposit() payable public {
    require(isDeposited[msg.sender] == false, 'Error, deposit is already active');
    require(msg.value >= 1e16, 'Error, deposit amount should be greater than 0.01 ETH');

    etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;
    depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;
    isDeposited[msg.sender] = true;

    emit Deposit(msg.sender, msg.value, block.timestamp);
  }

  function withdraw() public {
    require(isDeposited[msg.sender] == true, 'Error, there is no previous deposit');
    uint userBalance = etherBalanceOf[msg.sender];

    uint depositTime = block.timestamp - depositStart[msg.sender];

    //calc accrued interest
    uint interestPerSecond = 31668017 * (userBalance / 1e16);
    uint interest = interestPerSecond * depositTime;

    msg.sender.transfer(userBalance);
    token.mint(msg.sender, interest);

    //reset depositer data
    etherBalanceOf[msg.sender] = 0;
    depositStart[msg.sender] = 0;
    isDeposited[msg.sender] = false;
    
    //emit event
    emit Withdraw(msg.sender, userBalance, depositTime, interest);
  }

  function borrow() payable public {
    //check if collateral is >= than 0.01 ETH
    //check if user doesn't have active loan

    //add msg.value to ether collateral

    //calc tokens amount to mint, 50% of msg.value

    //mint&send tokens to user

    //activate borrower's loan status

    //emit event
  }

  function payOff() public {
    //check if loan is active
    //transfer tokens from user back to the contract

    //calc fee

    //send user's collateral minus fee

    //reset borrower's data

    //emit event
  }
}
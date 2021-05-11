// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
  address public minter;

  // can be pushed notification
  event MinterChanged(address indexed from, address to);

  constructor() public payable ERC20("Decentralized Bank Currency", "ICK") {
    minter = msg.sender;
  }

  function passMinterRole(address bank) public returns (bool) {
    require(msg.sender == minter, 'Error, only deployer/owner can change alter minter role or transfer role to the bank');
    minter = bank;

    emit MinterChanged(msg.sender, bank);
    return true;
  }

  // Total supply of token will increase when it is called
  function mint(address account, uint256 amount) public {
    require(msg.sender == minter, 'Error, this msg.sender is not allowed to minter');
		_mint(account, amount);
	}
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract TokenSale{
  IERC20 token;
  uint256 tokenPrice = 10 ** 17; // 0.1 eths
  address payable owner;
  constructor(address _token) {
    token = IERC20(_token);
    owner = payable(msg.sender);
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner is allowed");
    _;
  }

  event Purchase(address indexed buyer, uint256 amount);

  function purchase() public payable{
    require(msg.value >= tokenPrice, "not enough money to sent");
    uint256 tokensToTransfer = msg.value * (10 ** 18) / tokenPrice;
    require(token.balanceOf(address(this)) >= tokensToTransfer, "Not enough tokens in contract");
    token.transfer(msg.sender, tokensToTransfer);
    uint256 remainder = msg.value - (tokensToTransfer * tokenPrice) / (10 ** 18);
    if(remainder > 0) {
      payable(msg.sender).transfer(remainder);
    }
    emit Purchase(msg.sender, tokensToTransfer);
  }

  function withdrawEtherFromContract() external onlyOwner {
    payable(owner).transfer(address(this).balance);
  }
}
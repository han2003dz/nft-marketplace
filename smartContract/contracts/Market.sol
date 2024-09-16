// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Market {
  address public owner;
  uint256 public listingFeePercentage;
  uint256 public listingFeeDecimal;

  IERC721 private nft;
  IERC20 private erc20Token;
  IERC1155 private erc1155Token;

  struct Item {
    bool isNFT;
    address seller;
    uint256 amount;
    uint256 price;
  }

  struct Offer {
    address buyer;
    uint256 amount;
    uint256 price;
    bool isActive;
  }

  struct Auction {
    bool isNFT;
    bool isActive;
    address seller;
    uint256 amount;
    uint256 startTime;
    uint256 endTime;
    uint256 startingPrice;
    address lastBider;
    uint256 highestBid;  
    address highestBidder;
  }

  mapping(uint256 => Item) public marketItemsNFT;
  mapping(uint256 => mapping(address => Item)) public marketItemsERC1155;

  mapping(uint256 => Offer[]) public offersNFT;
  mapping(uint256 => mapping(address => Offer[])) public offersERC1155;

  mapping(uint256 => Auction) public auctionsNFT;
  mapping(uint256 => mapping(address => Auction)) public auctionERC1155;

  mapping(uint256 => address) public claimsNFT;
  mapping(uint256 => mapping(address => uint256)) public claimsERC1155;

  constructor(address _erc20Token, address _nft, address _erc1155Token, uint256 _listingFeePercentage, uint256 _listingFeeDecimal) {
    owner = msg.sender;
    nft = IERC721(_nft);
    erc20Token = IERC20(_erc20Token);
    erc1155Token = IERC1155(_erc1155Token);
    listingFeePercentage = _listingFeePercentage;
    listingFeeDecimal = _listingFeeDecimal;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "");
    _;
  }

  function transferOwnerShip(address newOwner) external onlyOwner {
    require(newOwner != address(0), "Invalid new owner");
    owner = newOwner;
  }

  function setListingFee(uint256 _listingFeePercentage, uint256 _listingFeeDecimal) external onlyOwner{
    listingFeePercentage = _listingFeePercentage;
    listingFeeDecimal = _listingFeeDecimal;
  }
}
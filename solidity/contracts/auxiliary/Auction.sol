// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import './AccessControl.sol';
import '../libraries/AuctionLibrary.sol';

abstract contract Auction {
    event AuctionCreated(uint256 tokenId, uint256 price, uint256 duration, address seller);
    event AuctionCancelled(uint256 tokenId);
    event AuctionSuccessful(uint256 tokenId, uint256 price, address seller, address buyer);

    mapping (uint256 => AuctionLibrary.Auction) internal tokenIdToAuction;

    uint256 internal startingPrice = 1000;
    uint256 internal auctionFeePercent = 45; // equals to 4.5%

    function getStartingPrice() external view virtual returns (string memory) {
        return string.concat(Strings.toString(startingPrice), " Sashi");
    }

    function setAuctionFeePercent(uint256 _fee) external virtual {
        require (_fee > 0 && _fee < 999, "Invalid fee!");
        auctionFeePercent = _fee;
    }

    function setStartingPrice(uint256 _price) external virtual {
        // require max is uint256
        startingPrice = _price;
    }
}
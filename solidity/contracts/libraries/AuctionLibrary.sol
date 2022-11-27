// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library AuctionLibrary {
    struct Auction {
        uint256 tokenId;
        uint128 price;
        uint64 duration;
        address seller;
        bool onAuction;
    }
}
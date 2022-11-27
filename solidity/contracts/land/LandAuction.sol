// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import './LandMinting.sol';
import '../auxiliary/Auction.sol';
import '../libraries/AuctionLibrary.sol';

contract LandAuction is LandMinting, Auction {
    function createAuction(
        uint256 _tokenId,
        uint256 _price,
        uint256 _duration
    )
        public
        whenNotPaused
    {
       _createAuction(_tokenId, _price, _duration, msg.sender);
    }

    function cancelAuction(uint256 _tokenId) external whenNotPaused {
        AuctionLibrary.Auction storage _auction = tokenIdToAuction[_tokenId];
        require(msg.sender == _auction.seller, "This address is not the owner of the item!");

        _transfer(address(this), _auction.seller, _tokenId);
        delete tokenIdToAuction[_tokenId];

        emit AuctionCancelled(_tokenId);
    }

    function bid(uint256 _tokenId, uint256 _amount) external payable whenNotPaused {
        AuctionLibrary.Auction storage _auction = tokenIdToAuction[_tokenId];
        require (_auction.onAuction == true, "The item is not on auction!");
        require (_amount >= _auction.price, "The item price is higher than the bid!");

        uint16 calcFee = uint16(SafeMath.div(SafeMath.mul(_amount, auctionFeePercent), 1000));
        token.transferFrom(msg.sender, _auction.seller, _amount - calcFee);
        token.transferFrom(msg.sender, address(this), calcFee);
        
        delete tokenIdToAuction[_tokenId];
        _transfer(address(this), msg.sender, _tokenId);

        emit AuctionSuccessful(_tokenId, _auction.price, _auction.seller, msg.sender);
    }

    function _createAuction(
        uint256 _tokenId,
        uint256 _price,
        uint256 _duration,
        address _seller
    )
        internal
        whenNotPaused
    {
       // validation checks
        require(ownerOf(_tokenId) == _seller, "This address is not the owner of the item or the item is not listed on an auction!");

        AuctionLibrary.Auction memory _auction = AuctionLibrary.Auction({
            tokenId: _tokenId,
            price: uint128(_price),
            duration: uint64(_duration),
            seller: _seller,
            onAuction: true
        });

        _approve(address(this), _tokenId);
        safeTransferFrom(_seller, address(this), _tokenId);
        tokenIdToAuction[_tokenId] = _auction;

        emit AuctionCreated(
            _tokenId,
            _price,
            _duration,
            _seller
        );
    }

    function getStartingPrice() external view override onlyAdmin returns (string memory) {
        return string.concat(Strings.toString(startingPrice), " Sashi");
    }

    function setAuctionFeePercent(uint256 _fee) external override onlyAdmin {
        require (_fee > 0 && _fee < 999, "Invalid fee!");
        auctionFeePercent = _fee;
    }

    function setStartingPrice(uint256 _price) external override onlyAdmin {
        // require max is uint256
        startingPrice = _price;
    }
}
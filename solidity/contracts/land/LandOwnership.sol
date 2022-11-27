// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './LandBase.sol';
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract LandOwnership is LandBase, ERC721, ERC721Holder {

    constructor() ERC721("Land", "LND") {}

    function _mintLand(
        string memory _name,
        uint256 _kind,
        uint16 _magicChance,
        address _owner
    )
        internal
        onlyAdmin
        returns (uint)
    {
        // проверка на данните и сложи максимален брой герои и проверка дали не е минат

        Land memory _land = Land({
            name: _name,
            createTime: uint64(block.timestamp),
            kind: _kind,
            magicChance: uint16(_magicChance)
        });

        lands.push(_land);
        uint256 newLandId = lands.length - 1;

        _safeMint(_owner, newLandId);
        emit Mint(_owner, newLandId);

        return newLandId;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "Land: ";
    }
}
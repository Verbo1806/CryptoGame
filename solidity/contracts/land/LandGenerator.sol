// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import '../libraries/LandLibrary.sol';
import '../auxiliary/AccessControl.sol';

contract LandGenerator is AccessControl {
    bool public isLandGenerator = true;
    uint8 constant NAME_SIZE = 10;

    string[NAME_SIZE] private adjectives;
    string[NAME_SIZE] private nouns;

    constructor() {
        adminAddress = msg.sender;

        adjectives = [
            "Sentinel", "The Holy", "The Fantastic",
            "The Dark", "The Golden", "The Lost",
            "Legendary", "Rift", "Outpost",
            "The Spiritual"
        ];

        nouns = [
            "Lands", "Village", "Ruins",
            "Grocery", "Gate", "Throat",
            "Entry", "Housing", "Bath",
            "Area"
        ];
    }

    fallback() external payable {}
    receive() external payable {}

    function generateLandName() public view returns (string memory) {
        uint adjectiveCount = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % NAME_SIZE;
        uint nounCount = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % NAME_SIZE;

        return string.concat(adjectives[adjectiveCount], " ", nouns[nounCount]);
    }

    function generateMagicChance() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp))) % LandLibrary.MAGIC_CHANCE_MAX_VALUE;
    }

    function withdrawBalance() external onlyAdmin {
        payable(adminAddress).transfer(address(this).balance);
    }
}
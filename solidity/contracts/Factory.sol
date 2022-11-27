// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './auxiliary/AccessControl.sol';
import './auxiliary/GameObject.sol';
import './land/Land.sol';
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Factory is AccessControl {
    IERC20 internal token;

    GameObject private land;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function getLandAddress() external view onlyAdmin returns (address) {
        return address(land);
    }

    function setLand(GameObject _land) external onlyAdmin {
        require (address(_land) != address(0), "Land cannot be the 0 address!");
        land = _land;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import './AccessControl.sol';

abstract contract GameObject is AccessControl {
    event Mint(address owner, uint256 itemId);

    uint32 public maxCount;
    IERC20 internal token;

    function getTokenAddress() external view onlyAdmin returns (address) {
        return address(token);
    }

    function setMaxCount(uint32 _max) external onlyAdmin {
        // require max is uint32
        maxCount = _max;
    }

    fallback() external payable {}
    receive() external payable {}

    function withdrawETHBalance() external onlyAdmin {
        payable(adminAddress).transfer(address(this).balance);
    }

    function withdrawTokenBalance() external onlyAdmin {
        token.transfer(address(adminAddress), token.balanceOf(address(this)));
    }

    function destructor() public override onlyAdmin whenPaused {
        token.transfer(address(adminAddress), token.balanceOf(address(this)));
        selfdestruct(payable(adminAddress));
    }
}
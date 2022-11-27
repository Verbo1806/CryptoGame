// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import '../libraries/LandLibrary.sol';
import './LandAuction.sol';
import '../token/Verba.sol';

contract Land is LandAuction {

    constructor(address _generator, address _token) {
        paused = true;
        adminAddress = msg.sender;
        generator = LandGenerator(payable(_generator));
        token = IERC20(_token);

        maxCount = 33000000;

        _mintLand("There", 0, LandLibrary.MAGIC_CHANCE_MAX_VALUE, msg.sender);
    }

    function mintAndAddToAuction(uint256 _kind, uint256 _price) external onlyAdmin whenNotPaused {
        uint256 landId = mintLand(_kind);

        _createAuction(
            landId,
            _price,
            0,
            msg.sender
        );
    }

    function unpause() override public onlyAdmin whenPaused {
        require(adminAddress != address(0));
        require(address(generator) != address(0));
        require(address(token) != address(0));

        super.unpause();
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './LandOwnership.sol';
import './LandGenerator.sol';

contract LandMinting is LandOwnership {
    LandGenerator internal generator;

    function mintLand(uint256 _kind) public onlyAdmin returns (uint256) {
        // проверка на данните и сложи максимален брой герои и проверка дали не е минат

        return _mintLand(
            generator.generateLandName(),
            _kind,
            uint16(generator.generateMagicChance()),
            msg.sender
        );
    }

    function getGeneratorAddress() external view onlyAdmin returns (address) {
        return address(generator);
    }

    function setGeneratorAddress(address _genAddr) external onlyAdmin {
        LandGenerator _generator = LandGenerator(payable(_genAddr));
        require(_generator.isLandGenerator());

        generator = _generator;
        emit ContractUpgrade(_genAddr);
    }
}
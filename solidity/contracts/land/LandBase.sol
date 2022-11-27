// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import '../auxiliary/GameObject.sol';

contract LandBase is GameObject {
    struct Land {
        string name;
        uint64 createTime;
        uint256 kind; // type uint256?
        uint16 magicChance;
    }

    Land[] internal lands;

    function get(uint256 _id)
        external
        view
    returns (
        string memory name,
        uint64 createTime,
        uint256 kind,
        uint16 magicChance
    ) {
        Land storage _land = lands[_id];

        name = _land.name;
        createTime = uint64(_land.createTime);
        kind = _land.kind;
        magicChance = uint16(_land.magicChance);
    }
}
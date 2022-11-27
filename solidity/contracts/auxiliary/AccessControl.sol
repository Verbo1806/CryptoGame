// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

abstract contract AccessControl {
    event ContractUpgrade(address newContract);

    address public adminAddress;

    bool public paused = false;

    modifier onlyAdmin() {
        require(msg.sender == adminAddress, "Forbidden: Only Admin can call this function!");
        _;
    }

    function setAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0));

        adminAddress = _newAdmin;
    }

    modifier whenNotPaused() {
        require(!paused, "This action cannot be done when the contract is paused!");
        _;
    }

    modifier whenPaused {
        require(paused, "This action cannot be done when the contract is not paused!");
        _;
    }

    function pause() external onlyAdmin whenNotPaused {
        paused = true;
    }

    function unpause() public virtual onlyAdmin whenPaused {
        paused = false;
    }

    function destructor() public virtual onlyAdmin whenPaused {
        selfdestruct(payable(adminAddress));
    }
}
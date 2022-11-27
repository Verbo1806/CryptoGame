// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VerbaICO is Ownable {
    IERC20 token;

    uint256 public constant WEIS_IN_SZABO = 1000000000000;
    uint256 public constant GOAL = 335000; // 335000 Verbas

    uint256 public constant START = 1669896000; // 01.12.2022 @ 12:00 GMT
    uint256 public constant DAYS = 90; // 90 Days
    
    uint256 public constant initialTokens = GOAL * 10 ** 4; // Initial number of tokens available
    bool public initialized = false;
    uint256 public raisedAmount = 0;
    
    event BoughtTokens(address indexed to, uint256 value);
    event ICOSuccessful ();

    modifier whenSaleIsActive() {
        assert(isActive());
        _;
    }
    
    constructor(address _tokenAddr) {
        require(address(_tokenAddr) != address(0));
        token = IERC20(_tokenAddr);
    }
    
    function initialize() public onlyOwner {
        require(initialized == false);
        require(tokensAvailable() >= initialTokens);
        initialized = true;
    }

    function isActive() public view returns (bool) {
        return (
            initialized == true &&
            block.timestamp >= START &&
            block.timestamp <= START + (DAYS * 1 days) &&
            goalReached() == false
        );
    }

    function goalReached() public view returns (bool) {
        return (raisedAmount >= GOAL);
    }

    fallback() external payable {
        buyTokens();
    }

    receive() external payable {
        buyTokens();
    }

    function buyTokens() public payable whenSaleIsActive {
        uint256 tokens = toTokens(msg.value);
        require(tokensAvailable() > tokens, "Not enough tokens available in the protocol!");
        
        emit BoughtTokens(msg.sender, tokens);
        raisedAmount = SafeMath.add(raisedAmount, tokens);
        token.transfer(msg.sender, tokens);
        
        payable(owner()).transfer(msg.value);

        if (goalReached()) {
            emit ICOSuccessful();
        }
    }

    function tokensAvailable() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function destroy() public onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        assert(balance > 0);

        token.transfer(owner(), balance);
        selfdestruct(payable(owner()));
    }

    function toTokens(uint256 weiValue) private view returns(uint256) {
        return weiValue / (WEIS_IN_SZABO * getTokenPrice());
    }

    function getTokenPrice() private view returns(uint256) {
        if (raisedAmount < 100000) {
            return 150; // 1 Verba == 150 Szabo
        } else if (raisedAmount < 200000) {
            return 300; // 1 Verba == 300 Szabo
        } else {
            return 400; // 1 Verba == 400 Szabo
        }
    }
}
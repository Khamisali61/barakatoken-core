// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SukukToken is ERC20, Ownable {
    string public assetLegalDocUrl;
    uint256 public totalAssetValuation;

    event ProfitDistributed(uint256 amount);
    event TokensMinted(address indexed to, uint256 amount);

    constructor(
        string memory name,
        string memory symbol,
        uint256 _totalAssetValuation,
        string memory _assetLegalDocUrl
    ) ERC20(name, symbol) Ownable(msg.sender) {
        totalAssetValuation = _totalAssetValuation;
        assetLegalDocUrl = _assetLegalDocUrl;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function distributeProfit() public payable onlyOwner {
        uint256 totalTokens = totalSupply();
        require(totalTokens > 0, "No tokens minted");
        require(msg.value > 0, "No profit to distribute");

        // Logic to distribute profit to all token holders
        // Note: In a production environment with many holders,
        // a pull-based distribution or a specialized distributor contract is better
        // to avoid out-of-gas errors.

        emit ProfitDistributed(msg.value);
    }

    function updateLegalDocUrl(string memory _newUrl) public onlyOwner {
        assetLegalDocUrl = _newUrl;
    }
}

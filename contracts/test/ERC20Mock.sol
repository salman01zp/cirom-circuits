// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Mock is ERC20("Test Eth", "TEth") {
    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }
}

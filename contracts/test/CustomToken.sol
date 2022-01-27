//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Contract for use testing ERC20 token scenarios.
 */
contract CustomToken is ERC20, Ownable {
    constructor(string memory name, string memory symbol)
        public
        ERC20(name, symbol)
    {
        _mint(msg.sender, 1e27);
    }
}

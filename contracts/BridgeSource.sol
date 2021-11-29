//SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;
pragma abicoder v2;

import "./lib/Types.sol";

contract BridgeSource {
    uint256 public immutable contractFeeBasisPoints;

    uint256 public nextTransferID = 0;

    constructor(uint256 _contractFeeBasisPoints) {
        contractFeeBasisPoints = _contractFeeBasisPoints;
    }

    function withdraw(Types.TransferData calldata transferData) external {
        require(false, "TODO Implement");
    }
}
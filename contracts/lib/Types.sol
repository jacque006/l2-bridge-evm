//SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;
pragma abicoder v2;

library Types {
    struct TransferData {
        address tokenAddress;
        address destination;
        uint256 amount;
        uint256 fee;
        uint256 startTime;
        uint256 feeRampup;
    }
}
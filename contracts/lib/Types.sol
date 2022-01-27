//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

library Types {
    struct TransferData {
        address tokenAddress;
        address destination;
        uint256 amount;
        uint256 fee;
        uint256 startTime;
        uint256 feeRampup;
    }

    function keccakEncode(TransferData memory transfer)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(
            transfer.tokenAddress,
            transfer.destination,
            transfer.amount,
            transfer.fee,
            transfer.startTime,
            transfer.feeRampup
        ));
    }

    struct TransferInitiated {
        TransferData transfer;
        address sourceBridge;
        uint256 transferID;
    }

    function keccakEncode(TransferInitiated memory transferInitiated)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(
            keccakEncode(transferInitiated.transfer),
            transferInitiated.sourceBridge,
            transferInitiated.transferID
        ));
    }
}
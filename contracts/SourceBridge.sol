//SPDX-License-Identifier: MIT
pragma solidity >=0.8.16;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./lib/Constants.sol";
import "./lib/Types.sol";
import "./lib/MerkleTree.sol";
// TODO debug, remove
import "hardhat/console.sol";

contract SourceBridge is MerkleTree {

    // TODO Need event for transfer initiated

    uint256 public immutable contractFeeBasisPoints;

    uint256 public nextTransferID = 0;

    constructor(uint256 _contractFeeBasisPoints) {
        contractFeeBasisPoints = _contractFeeBasisPoints;
    }

    function takeTokens(address tokenAddress, uint256 amount) internal {
        if (tokenAddress == Constants.ETHER_ADDRESS) {
            require(msg.value == amount, "msg.value != transfer amount + contractFeeBasisPoints");
            (bool received, bytes memory _data) = address(this).call{value: msg.value}("");
            require(received, "failed to receive ether");
            return;
        }

        require(IERC20(tokenAddress).allowance(msg.sender, address(this)) >= amount, "BridgeSource: token allowance too low");
        bool received = IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
        require(received, "failed to receive tokens");
    }

    function withdraw(Types.TransferData calldata transfer) external payable {
        // TODO Require checks on validity of transfer data i.e:
        // Is a non-zero amount required?
        // Start time required?

        uint256 amountPlusFee = (transfer.amount * (10000 + contractFeeBasisPoints)) / 10000;
        takeTokens(transfer.tokenAddress, amountPlusFee);

        insert(Types.keccakEncode(Types.TransferInitiated(transfer, address(this), nextTransferID)));

        nextTransferID += 1;

        // TODO Add bounty pool for contract fee.
    }
}
//SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;
pragma abicoder v2;

import "./lib/Types.sol";

contract BridgeDestination {
    // (transferData, transferID) => address owner
    // TODO Type key correctly
    mapping(uint256 => address) public transferOwners;
    // stateRoot -> bool
    mapping(bytes32 => bool) public validatedStateRoots;

    function changeOwner(Types.TransferData calldata transferData, uint256 transferID, address newOwner) external {
        require(false, "TODO Implement");        
    }

    function buy(Types.TransferData calldata transferData, uint256 transferID) external {
        require(false, "TODO Implement");
    }

    // TODO Type proofs correctly
    function withdraw(Types.TransferData calldata transferData, uint256 transferID, bytes32 stateRootProof, bytes32 stateRoot, bytes32 recordProof) external {
        require(false, "TODO Implement");
    }

/*
    def getLPFee(transferData, currentTime) -> uint256:
        if currentTime < startTime:
            return 0
        elif currentTime >= startTime + feeRampup:
            return fee
        else:
            # Note: this clause is unreachable if feeRampup == 0
            return fee * (currentTime - startTime) // feeRampup
*/
}
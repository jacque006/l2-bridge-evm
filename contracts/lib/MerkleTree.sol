//SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;
pragma abicoder v2;
// TODO debug, remove
import "hardhat/console.sol";

// Based on https://github.com/ethereum/consensus-specs/blob/dev/solidity_deposit_contract/deposit_contract.sol
// TODO May want to go deeper on this and try and implement more generic SSZ spec (https://github.com/protolambda/eth2.0-ssz/)
abstract contract MerkleTree {
    // TODO Do these need to be adjustable?
    uint256 public constant DEPTH = 32;
    uint256 constant MAX_ITEM_COUNT = 2 ** DEPTH - 1;

    bytes32[DEPTH] zeroHashes;
    bytes32[DEPTH] branch;
    uint256 itemCount;

    constructor() {
        // Compute hashes in empty sparse Merkle tree
        // TODO Hubble tree uses pre-computed zero hashes, consider using here as well.
        for (uint height = 0; height < DEPTH - 1; height++)
            zeroHashes[height + 1] = keccak256(abi.encodePacked(zeroHashes[height], zeroHashes[height]));
    }

    function getRoot() external view returns (bytes32) {
        bytes32 node;
        uint size = itemCount;
        for (uint height = 0; height < DEPTH; height++) {
            if ((size & 1) == 1)
                node = keccak256(abi.encodePacked(branch[height], node));
            else
                node = keccak256(abi.encodePacked(node, zeroHashes[height]));
            size /= 2;
        }
        return node;
    }

    function insert(bytes32 keccakEncodedItem) internal {
        require(itemCount < MAX_ITEM_COUNT, "MerkleTree: tree full");
        itemCount += 1;

        uint size = itemCount;
        bytes32 node = keccakEncodedItem;
        for (uint height = 0; height < DEPTH; height++) {
            if ((size & 1) == 1) {
                branch[height] = node;
                return;
            }
            node = keccak256(abi.encodePacked(branch[height], node));
            size /= 2;
        }
        // Should not be reached.
        assert(false);
    }
}
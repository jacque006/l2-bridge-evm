import { expect } from "chai";
import { BigNumberish, utils } from "ethers";
import { ethers } from "hardhat";
import { MerkleTree } from "merkletreejs";
import keccak256 from "keccak256";
import {
  CustomToken,
  CustomToken__factory,
  SourceBridge,
  SourceBridge__factory,
} from "../typechain-types";
import { TransferDataStruct } from "../typechain-types/BridgeSource";

type TransferInitiated = {
  transfer: TransferDataStruct;
  sourceBridge: string;
  transferID: BigNumberish;
};

const keccakEncodeTransfer = (transfer: TransferDataStruct): string => {
  return utils.solidityKeccak256(
    ["address", "address", "uint256", "uint256", "uint256", "uint256"],
    [
      transfer.tokenAddress,
      transfer.destination,
      transfer.amount,
      transfer.fee,
      transfer.startTime,
      transfer.feeRampup,
    ]
  );
};

const encodeTransferInitiated = (
  transferInitiated: TransferInitiated
): string => {
  return utils.solidityPack(
    ["bytes", "address", "uint256"],
    [
      keccakEncodeTransfer(transferInitiated.transfer),
      transferInitiated.sourceBridge,
      transferInitiated.transferID,
    ]
  );
};

describe("integration", () => {
  let testToken: CustomToken;
  let sourceBridge: SourceBridge;

  let destinationAddress: string;
  let tree: MerkleTree;

  before(async function () {
    const [signer, destinationSigner] = await ethers.getSigners();
    destinationAddress = destinationSigner.address;
    tree = new MerkleTree([], keccak256, { hashLeaves: true, sortPairs: true });

    testToken = await new CustomToken__factory(signer).deploy("London", "LON");
    sourceBridge = await new SourceBridge__factory(signer).deploy(5);
    await testToken.approve(
      sourceBridge.address,
      await testToken.totalSupply()
    );
  });

  it("transfers from source bridge to destination bridge successfully", async function () {
    const amount = utils.parseUnits("100");
    const transfer: TransferDataStruct = {
      tokenAddress: testToken.address,
      destination: destinationAddress,
      amount,
      // TODO Test these.
      fee: 0,
      startTime: 0,
      feeRampup: 0,
    };
    const transferInitiated: TransferInitiated = {
      transfer,
      sourceBridge: sourceBridge.address,
      transferID: 0,
    };
    tree.addLeaf(Buffer.from(encodeTransferInitiated(transferInitiated)));
    // TODO Remove
    MerkleTree.print(tree);

    await sourceBridge.withdraw(transfer);

    expect(await sourceBridge.getRoot()).to.equal(tree.getHexRoot());
  });
});

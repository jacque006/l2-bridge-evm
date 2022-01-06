import {
  Tree,
  LeafNode,
  zeroNode,
  toGindex,
} from "@chainsafe/persistent-merkle-tree";
import { expect } from "chai";
import { utils } from "ethers";
import { ethers } from "hardhat";
import {
  CustomToken,
  CustomToken__factory,
  SourceBridge,
  SourceBridge__factory,
} from "../typechain-types";

// TODO update
type TransferDataStruct = any;
type TransferInitiated = any;

describe("integration", () => {
  let testToken: CustomToken;
  let sourceBridge: SourceBridge;

  let destinationAddress: string;
  let treeDepth: number;
  let tree: Tree;

  before(async function () {
    const [signer, destinationSigner] = await ethers.getSigners();
    destinationAddress = destinationSigner.address;

    testToken = await new CustomToken__factory(signer).deploy("London", "LON");
    sourceBridge = await new SourceBridge__factory(signer).deploy(5);
    await testToken.approve(
      sourceBridge.address,
      await testToken.totalSupply()
    );

    treeDepth = (await sourceBridge.DEPTH()).toNumber();
    tree = new Tree(zeroNode(treeDepth));
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
    const nodeIdx = toGindex(treeDepth, 0n);

    console.warn(
      "?".repeat(10),
      keccakEncodeTransferInitiated(transferInitiated).length
    );

    tree.setNode(
      nodeIdx,
      new LeafNode(
        Buffer.from(keccakEncodeTransferInitiated(transferInitiated))
      )
    );

    await sourceBridge.withdraw(transfer);

    expect(await sourceBridge.getRoot()).to.equal(tree.root.toString());
  });
});

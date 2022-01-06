import {
  NumberUintType,
  ByteVector,
  ByteVectorType,
  ContainerType,
} from "@chainsafe/ssz";

const bufferHex = (x: string): Buffer => Buffer.from(x, 'hex');

const Uint256Type = new NumberUintType({
  byteLength: 8,
});
const AddressType = new ByteVectorType({
  length: 40,
});

const TransferSSZ = new ContainerType({
  fields: {
    tokenAddress: AddressType,
    destination: AddressType,
    amount: Uint256Type,
    fee: Uint256Type,
    startTime: Uint256Type,
    feeRampup: Uint256Type,
  },
});

interface Transfer {
  tokenAddress: ByteVector;
  destination: ByteVector;
  amount: Number;
  fee: Number;
  startTime: Number;
  feeRampup: Number;
}

// TODO Figure out ethers interface type.
const transferToSSZ = (): Transfer => ({

});

const TransferInitiatedSSZ = new ContainerType({
  fields: {
    // TODO Is such a thing even possible?
    transfer: TransferSSZ,
    sourceBridge: AddressType,
    transferID: Uint256Type,
  },
});

interface TransferInitiatedSSZ {
  transferHash: ByteVector;
  sourceBridge: ByteVector;
  transferID: Number;
}

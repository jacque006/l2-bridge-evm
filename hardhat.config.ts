import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";

const config: HardhatUserConfig = {
  solidity: "0.8.11",
  gasReporter: {
    enabled: true,
  },
  mocha: {
    timeout: 120000,
  },
};

export default config;

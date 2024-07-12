// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

contract TheRun is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }
}

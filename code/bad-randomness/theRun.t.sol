// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.20;

// import "forge-std/Test.sol";
// import "./theRun.sol";

// contract TheRunTest is Test {
//     theRun public run;

//     function setUp() public {
//         run = new theRun();
//     }

//     function testRandomness() public {
//         uint256 result1 = run.testRandom(100);
//         uint256 result2 = run.testRandom(100);
//         assertNotEq(result1, result2, "Random numbers should not be the same");
//     }
// }
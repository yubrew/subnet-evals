// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/TheRun-fixed.sol";

contract TheRunTest is Test {
    TheRun public run;

    function setUp() public {
        console.log("Setting up test...");
        run = new TheRun();
        console.log("Contract deployed at:", address(run));
    }

    function testSimple() public {
        console.log("Starting testSimple...");
        uint256 result = run.testRandom(100);
        console.log("Result:", result);
        console.log("testSimple completed successfully");
    }

    function testRandom() public {
        uint256 result1 = run.testRandom(100);
        uint256 result2 = run.testRandom(100);
    
        assertTrue(result1 > 0 && result1 <= 100, "First result out of range");
        assertTrue(result2 > 0 && result2 <= 100, "Second result out of range");
        assertNotEq(result1, result2, "Random numbers should not be the same");
    }
}
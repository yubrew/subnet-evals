// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/TheRun-fixed.sol";

contract TheRunTest is Test {
    TheRun public run;
    address constant VRF_COORDINATOR = address(0x1);
    address constant LINK_TOKEN = address(0x2);
    bytes32 constant KEY_HASH = keccak256("key_hash");
    uint256 constant FEE = 0.1 ether;

    function setUp() public {
        console.log("Setting up test...");
        run = new TheRun(VRF_COORDINATOR, LINK_TOKEN, KEY_HASH, FEE);
        console.log("Contract deployed at:", address(run));
        
        // Fund the contract with LINK tokens
        vm.deal(address(this), 100 ether);
        (bool success, ) = LINK_TOKEN.call{value: 10 ether}("");
        require(success, "Failed to fund contract with LINK");
    }

    function testParticipate() public {
        console.log("Starting testParticipate...");
        uint256 initialBalance = address(run).balance;
        run.participate{value: 1 ether}();
        assertEq(address(run).balance, initialBalance + 1 ether, "Contract balance should increase");
        console.log("testParticipate completed successfully");
    }

    function testRandomnessRequest() public {
        console.log("Starting testRandomnessRequest...");
        run.participate{value: 2 ether}();
        
        // Simulate VRF Coordinator callback
        uint256 randomness = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao)));
        vm.prank(VRF_COORDINATOR);
        run.rawFulfillRandomness(KEY_HASH, randomness);

        assertNotEq(run.randomResult(), 0, "Random result should be set");
        console.log("testRandomnessRequest completed successfully");
    }

    function testPayouts() public {
    console.log("Starting testPayouts...");
    address player1 = address(0x3);
    address player2 = address(0x4);

    vm.deal(player1, 5 ether);
    vm.deal(player2, 5 ether);

    vm.prank(player1);
    run.participate{value: 1 ether}();

    vm.prank(player2);
    run.participate{value: 1 ether}();

    // Record initial balances
    uint256 initialBalance1 = player1.balance;
    uint256 initialBalance2 = player2.balance;
    uint256 initialContractBalance = address(run).balance;

    // Simulate some time passing and contract gaining funds
    vm.deal(address(run), initialContractBalance + 10 ether);

    // Participate again to trigger payouts
    address player3 = address(0x5);
    vm.deal(player3, 5 ether);
    vm.prank(player3);
    run.participate{value: 1 ether}();

    // Check if the contract balance decreased
    assertTrue(address(run).balance < initialContractBalance + 11 ether, "Contract should have paid out some funds");

    // Check if at least one player received a payout
    (,, bool paid1) = run.playerInfo(0);
    (,, bool paid2) = run.playerInfo(1);
    assertTrue(paid1 || paid2, "At least one player should have been paid");

    console.log("testPayouts completed successfully");
}

    receive() external payable {}
}
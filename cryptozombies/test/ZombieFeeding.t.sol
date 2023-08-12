
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.21;

import "forge-std/Test.sol";
import "src/ZombieFeeding.sol";

contract ZombieFeedingTest is Test {
    ZombieFeeding public zombieFeeding;
    address private deployer;
    address private ckMainNetAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;

    function setUp() public {
        deployer = vm.addr(0x4321);
        vm.startPrank(deployer);
        zombieFeeding = new ZombieFeeding();
        zombieFeeding.setKittyContractAddress(ckMainNetAddress);
    }

    function testFeedOnKitty_ShouldSuccessFeedOnKitty_WhenCallFeedOnKitty(string memory _name) public {
        //setUp
        zombieFeeding.createRandomZombie(_name);
        //execution
        vm.warp(block.timestamp + 1 days);
        zombieFeeding.feedOnKitty(0,1);
        //assert
    }
}
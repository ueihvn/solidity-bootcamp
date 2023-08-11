// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/Script.sol";
import "src/ZombieFactory.sol";

contract ZombieFactoryScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        new ZombieFactory();
    }
}

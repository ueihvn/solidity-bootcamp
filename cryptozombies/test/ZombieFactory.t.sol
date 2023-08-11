// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.21;

import "forge-std/Test.sol";
import "src/ZombieFactory.sol";

contract ZombieFactoryTest is Test {
    ZombieFactory public zombieFactory;

    function setUp() public {
        zombieFactory = new ZombieFactory();
    }

    function testCreateRandomZombie_ShouldSuccessCreateZombie_WhenCallCreateRandomZombie(string memory name) public {
        //setUp
        //execution
        zombieFactory.createRandomZombie(name);
        //assert
    }
}
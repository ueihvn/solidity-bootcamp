// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.21;

import "src/ZombieHelper.sol";
import "openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "src/SafeMath.sol";

contract ZombieAttack is ZombieHelper {
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    uint randomNonce = 0;

    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns (uint) {
        randomNonce = randomNonce.add(1);
        return
            uint(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randomNonce)
                )
            ) % _modulus;
    }

    function attack(uint _zombieId, uint _targetId) external {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);
        if (rand <= attackVictoryProbability) {
            myZombie.winCount = myZombie.winCount.add(1);
            myZombie.level = myZombie.level.add(1);
            enemyZombie.lossCount = enemyZombie.lossCount.add(1);
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount = myZombie.lossCount.add(1);
            enemyZombie.winCount = enemyZombie.winCount.add(1);
            _triggerCooldown(myZombie);
        }
    }
}

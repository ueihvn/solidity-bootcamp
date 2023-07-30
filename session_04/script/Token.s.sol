// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "forge-std/Script.sol";
import {Token} from "src/Token.sol";

contract TokenScript is Script {
    Token vbiToken;

    uint256 private constant _decimals = 10 ** 18;
    uint256 private constant _totalSupply = 10 ** 8 * _decimals;

    address private deployer;

    function setUp() public {
    }
    function run() public {
        vm.broadcast();
        vbiToken = new Token("VBI Token", "VBI", _totalSupply);
    }
}

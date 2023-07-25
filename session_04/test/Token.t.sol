// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "forge-std/Test.sol";

import {Token} from "src/Token.sol";

contract TokenTest is Test {
    Token vbiToken;

    uint256 private constant _decimals = 10 ** 18;
    uint256 private constant _totalSupply = 10 ** 8 * _decimals;

    address private deployer;
    address private _vbiAddress;

    function setUp() public {
        deployer = vm.addr(0x1234);
        // use deployer address for sc call
        vm.startPrank(deployer);
        vbiToken = new Token("VBI Token", "VBI", _totalSupply);
        _vbiAddress = address(vbiToken);
    }

    function testTotalSupply_ShouldReturnTS_WhenGetTS() public {
        //execution
        uint256 totalSupply = vbiToken.totalSupply();

        //assert
        assertEqUint(totalSupply, _totalSupply);
    }

    function testBalance_ShouldREturnDeployerBalance_WhenCallToBalance()
        public
    {
        uint256 deployerBalance = vbiToken.balanceOf(deployer);
        assertEqUint(deployerBalance, _totalSupply);
    }

    function testTransfer_ShouldSuccess_WhenTransferToAlice() public {
        //setUp
        address alice = vm.addr(0x4321);
        //execution
        bool isSuccess = vbiToken.transfer(alice, 111 * _decimals);
        require(isSuccess);
        uint256 taxFee = (111 * _decimals * 10 ** 2) / 10 ** 5; // 100 / 1000 = 0
        //assert
        uint256 acliceBalance = vbiToken.balanceOf(alice);
        uint256 senderBalance = vbiToken.balanceOf(deployer);
        assertEqUint(acliceBalance, 111 * _decimals - taxFee);
        assertEqUint(senderBalance, _totalSupply - 111 * _decimals + taxFee);
    }

    event Transfer(address indexed from, address indexed to, uint256 amount);

    // Fuzzing test
    function testTransfer_ShouldSuccess_WhenTransferToAliceFuzz(
        uint256 amount
    ) public {
        vm.assume(amount > 0);
        vm.assume(amount <= 999);
        //setUp
        address alice = vm.addr(0x4321);
        vm.expectEmit();
        emit Transfer(deployer, alice, amount);
        //execution
        bool isSuccess = vbiToken.transfer(alice, amount);
        require(isSuccess);
        uint256 taxFee = (amount * 10 ** 2) / 10 ** 5; // 100 / 1000 = 0
        //assert

        uint256 acliceBalance = vbiToken.balanceOf(alice);
        uint256 senderBalance = vbiToken.balanceOf(deployer);
        assertEqUint(acliceBalance, amount - taxFee);
        assertEqUint(senderBalance, _totalSupply - amount + taxFee);

        // Slither -> static
        // Echidna -> dynamic
    }
}

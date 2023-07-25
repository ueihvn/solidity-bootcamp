// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "./IERC20.sol";

abstract contract MyERC20 is IERC20 {
    uint256 _totalSupply;
    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowances;
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }
    function transfer(address to, uint256 amount) external returns (bool) {
        return _transfer(msg.sender,to,amount);
    }
    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) external returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 senderAllowance = _allowances[from][msg.sender];
        require(senderAllowance >= amount, 'sender allowance not enough');
        bool ok = _transfer(from,to,amount);
        if (!ok) {
            return false;
        }
        emit Transfer(from, to, amount);
        return true;
    }

    function _transfer(address from,address to, uint256 amount) internal returns (bool) {
        require((type(uint256).max - _balances[to]) <= amount,'overflow amount is too large');
        require((_balances[from] - amount) >= 0,'underflow - sender balance is not enough');
        _balances[from] -= amount;
        _balances[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }
}
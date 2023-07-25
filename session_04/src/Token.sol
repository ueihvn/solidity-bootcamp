// SPDX-License-Identifier: MIT

/**
 * @author Lunar
 */

pragma solidity 0.8.21;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

// contract Token2 is ERC20 {
//     constructor(
//         string memory name_,
//         string memory symbol_,
//         uint256 totalSupply_
//     ) {}
// }

contract Token is IERC20 {
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    string private _name;
    string private _symbol;

    address private _owner;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 totalSupply_
    ) {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = totalSupply_;
        _balances[msg.sender] = totalSupply_;
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function changOwner(address newOwner) public returns (bool) {
        require(msg.sender == _owner, "Token: not owner");
        _owner = newOwner;
        return true;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(
        address account
    ) external view override returns (uint256) {
        return _balances[account];
    }

    /**
     * Normal tokens
     * Fee on Transfer tokens -> rất khó xử lí
     * Rebase tokens
     */

    function transfer(
        address to,
        uint256 amount
    ) external override returns (bool) {
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        require(amount > 0, "Amount must be greater than 0");

        _balances[msg.sender] -= amount;
        // tax = 0.1% * amount; => tax = amount / 10^3 = amount * 10^-3
        uint256 tax = (amount * 10 ** 2) / 10 ** 5; // 100 / 1000 = 0
        // -> cần nhân tử số to lên trước khi chia
        _balances[to] += amount - tax;

        _balances[_owner] += tax;

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function allowance(
        address owner_,
        address spender_
    ) external view override returns (uint256) {
        return _allowances[owner_][spender_];
    }

    // Hay approve tối đa type(uint256).max
    // -> spender có quyền tiêu hết token trong tài khoảng của approver
    function approve(
        address spender,
        uint256 amount
    ) external override returns (bool) {
        _allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override returns (bool) {
        require(_balances[from] >= amount, "Insufficient balance");
        require(amount > 0, "Amount must be greater than 0");
        require(_allowances[from][to] >= amount, "Insufficient allowance");
        require(
            _balances[to] >= type(uint256).max - amount,
            "Ballance is too large"
        );

        _balances[from] -= amount;
        _balances[to] += amount;
        _allowances[from][to] -= amount;

        emit Transfer(from, to, amount);

        return true;
    }
}

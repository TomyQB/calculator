// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Calculator {
    error DivisionByZero();
    error Unauthorized();

    event Addition(int256 a_, int256 b_, int256 result_);
    event Subtraction(int256 a_, int256 b_, int256 result_);
    event Multiplication(int256 a_, int256 b_, int256 result_);
    event Division(int256 a_, int256 b_, int256 result_);

    address public admin;

    modifier onlyAdmin() {
        _checkAdmin();
        _;
    }

    constructor(address admin_) {
        admin = admin_;
    }

    function _checkAdmin() internal view {
        if (msg.sender != admin) revert Unauthorized();
    }

    function add(int256 a, int256 b) external returns (int256 result_) {
        result_ = a + b;
        emit Addition(a, b, result_);
    }

    function subtract(int256 a, int256 b) external returns (int256 result_) {
        result_ = a - b;
        emit Subtraction(a, b, result_);
    }

    function multiply(int256 a, int256 b) external returns (int256 result_) {
        result_ = a * b;
        emit Multiplication(a, b, result_);
    }

    function divide(int256 a, int256 b) external onlyAdmin returns (int256 result_) {
        if (b == 0) revert DivisionByZero();
        result_ = a / b;
        emit Division(a, b, result_);
    }
}


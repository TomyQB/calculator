// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {Calculator} from "../src/Calculator.sol";

contract CalculatorTest is Test {
    Calculator internal calculator;

    address internal admin = vm.addr(1);
    address internal user = vm.addr(2);
    address internal attacker = vm.addr(3);

    function setUp() public {
        calculator = new Calculator(admin);
    }

    // ---------------------------------------------------------------
    // ADD
    // ---------------------------------------------------------------

    function test_add() public {
        vm.prank(user);
        assertEq(calculator.add(2, 3), 5);
    }

    function test_add_overflow_reverts() public {
        vm.prank(user);
        vm.expectRevert();
        calculator.add(type(int256).max, 1);
    }

    function test_add_emitsEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Calculator.Addition(2, 3, 5);
        vm.prank(user);
        calculator.add(2, 3);
    }

    function testFuzz_add(int128 a, int128 b) public {
        // int128 range avoids overflow so we test pure arithmetic
        int256 expected = int256(a) + int256(b);
        vm.prank(user);
        assertEq(calculator.add(int256(a), int256(b)), expected);
    }

    // ---------------------------------------------------------------
    // SUBTRACT
    // ---------------------------------------------------------------

    function test_subtract() public {
        vm.prank(user);
        assertEq(calculator.subtract(10, 4), 6);
    }

    function test_subtract_overflow_reverts() public {
        vm.prank(user);
        vm.expectRevert();
        calculator.subtract(type(int256).min, 1);
    }

    function test_subtract_emitsEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Calculator.Subtraction(10, 4, 6);
        vm.prank(user);
        calculator.subtract(10, 4);
    }

    function testFuzz_subtract(int128 a, int128 b) public {
        int256 expected = int256(a) - int256(b);
        vm.prank(user);
        assertEq(calculator.subtract(int256(a), int256(b)), expected);
    }

    // ---------------------------------------------------------------
    // MULTIPLY
    // ---------------------------------------------------------------

    function test_multiply() public {
        vm.prank(user);
        assertEq(calculator.multiply(3, 7), 21);
    }

    function test_multiply_overflow_reverts() public {
        vm.prank(user);
        vm.expectRevert();
        calculator.multiply(type(int256).max, 2);
    }

    function test_multiply_emitsEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Calculator.Multiplication(3, 7, 21);
        vm.prank(user);
        calculator.multiply(3, 7);
    }

    function testFuzz_multiply(int128 a, int128 b) public {
        int256 expected = int256(a) * int256(b);
        vm.prank(user);
        assertEq(calculator.multiply(int256(a), int256(b)), expected);
    }

    // ---------------------------------------------------------------
    // DIVIDE
    // ---------------------------------------------------------------

    function test_divide() public {
        vm.prank(admin);
        assertEq(calculator.divide(10, 2), 5);
    }

    function test_divide_byZero_reverts() public {
        vm.prank(admin);
        vm.expectRevert(Calculator.DivisionByZero.selector);
        calculator.divide(1, 0);
    }

    function test_divide_minByNegativeOne_reverts() public {
        vm.prank(admin);
        vm.expectRevert();
        calculator.divide(type(int256).min, -1);
    }

    function test_divide_emitsEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Calculator.Division(10, 2, 5);
        vm.prank(admin);
        calculator.divide(10, 2);
    }

    function testFuzz_divide(int128 a, int128 b) public {
        vm.assume(b != 0);
        int256 expected = int256(a) / int256(b);
        vm.prank(admin);
        assertEq(calculator.divide(int256(a), int256(b)), expected);
    }

    // ---------------------------------------------------------------
    // ACCESS CONTROL
    // ---------------------------------------------------------------

    function test_divide_nonAdmin_reverts() public {
        vm.prank(attacker);
        vm.expectRevert(Calculator.Unauthorized.selector);
        calculator.divide(10, 2);
    }

    function test_admin_isConstructorParam() public view {
        assertEq(calculator.admin(), admin);
    }
}

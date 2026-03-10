<div align="center">

![Solidity](https://img.shields.io/badge/Solidity-^0.8.28-363636?style=for-the-badge&logo=solidity&logoColor=white)
![Foundry](https://img.shields.io/badge/Foundry-Forge-DEA584?style=for-the-badge&logo=ethereum&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

# Solidity Calculator

Arithmetic calculator smart contract built with Foundry. Implements addition, subtraction, multiplication, and division with event logging, custom errors, and admin-based access control.

</div>

## Features

- **Four operations**: `add`, `subtract`, `multiply`, `divide` using `int256` (signed integers)
- **Event logging**: Every operation emits an event with operands and result
- **Access control**: Division restricted to admin address via `onlyAdmin` modifier
- **Custom errors**: Gas-efficient `DivisionByZero()` and `Unauthorized()` errors
- **Overflow protection**: Solidity 0.8.28 built-in checked arithmetic

## Contract Interface

| Function | Access | Description |
|---|---|---|
| `add(int256 a, int256 b)` | Public | Returns `a + b` |
| `subtract(int256 a, int256 b)` | Public | Returns `a - b` |
| `multiply(int256 a, int256 b)` | Public | Returns `a * b` |
| `divide(int256 a, int256 b)` | Admin only | Returns `a / b`, reverts on zero divisor |

## Project Structure

```
src/
  Calculator.sol       # Main contract
test/
  Calculator.t.sol     # Unit + fuzz tests (19 tests)
lib/
  forge-std/           # Foundry standard library
```

## Requirements

- [Foundry](https://book.getfoundry.sh/getting-started/installation)

## Usage

```shell
# Build
forge build

# Run tests
forge test

# Run tests with verbose output
forge test -vvv

# Format code
forge fmt

# Check formatting
forge fmt --check
```

## Testing

The test suite includes **15 deterministic tests** and **4 fuzz tests** (256 random iterations each):

- Happy path for each operation
- Overflow/underflow revert cases
- Event emission verification
- Division by zero revert
- Admin access control enforcement
- Fuzz testing with random `int128` inputs across all operations

```shell
# Run with gas report
forge test --gas-report
```

## License

MIT

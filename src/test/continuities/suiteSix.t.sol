pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "../setup/setup.sol";

import "../setup/methods.sol";

contract ContinuitySuiteSix is Setup, DSTest {

    using LoihiMethods for Loihi;

    Loihi l;
    Loihi l2;

    function setUp() public {

        l = getLoihiSuiteSix();
        l2 = getLoihiSuiteSixClone();

    }

    function doubleDeposit (
        address w, uint256 wAmt,
        address x, uint256 xAmt,
        address y, uint256 yAmt,
        address z, uint256 zAmt
    ) public {

        l.deposit(w, wAmt, x, xAmt, y, yAmt, z, zAmt);
        l2.deposit(w, wAmt, x, xAmt, y, yAmt, z, zAmt);

    }

    function test_s6_selectiveDeposit_continuity_noSlippage_noAntiSlippage () public {

        uint256 shellsOfTenTenTenAndTwoPFive = l.deposit(
            address(dai), 10e18,
            address(usdc), 10e6,
            address(usdt), 10e6,
            address(susd), 2.5e18
        );

        uint256 shellsOfFiveFiveFiveAndOnePTwoFiveTwice = l2.deposit(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 5e6,
            address(susd), 1.25e18
        );

        shellsOfFiveFiveFiveAndOnePTwoFiveTwice += l2.deposit(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 5e6,
            address(susd), 1.25e18
        );

        assertEq(
            shellsOfTenTenTenAndTwoPFive / 1e12,
            shellsOfFiveFiveFiveAndOnePTwoFiveTwice / 1e12 + 1
        );

    }

    function test_s6_selectiveDeposit_continuity_slippage () public {

        doubleDeposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        uint256 shellsOfTen = l.deposit(address(dai), 10e18);

        uint256 shellsOfFiveAndFive = l2.deposit(address(dai), 5e18);

        shellsOfFiveAndFive += l2.deposit(address(dai), 5e18);

        assertEq(
            shellsOfTen / 1e12,
            shellsOfFiveAndFive / 1e12
        );

    }

    function test_s6_selectiveDeposit_continuity_antiSlippage () public {

        doubleDeposit(
            address(dai), 45e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        uint256 shellsOfTen = l.deposit(address(dai), 10e18);

        uint256 shellsOfFiveAndFive = l2.deposit(address(dai), 5e18);
        shellsOfFiveAndFive += l2.deposit(address(dai), 5e18);

        assertEq(
            shellsOfTen / 1e12,
            shellsOfFiveAndFive / 1e12
        );

    }

    function test_s6_selectiveDeposit_continuity_slippage_reversal () public {

        l.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 depositedShells = l.deposit(address(dai), 5e18);

        uint256 withdrawnShells = l.withdraw(address(dai), 5e18);

        assertEq(depositedShells / 1e5, withdrawnShells / 1e5);

    }

    function test_s6_selectiveWithdraw_continuity_slippage_reversal () public {

        l.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 withdrawnShells = l.withdraw(address(usdt), 5e6);

        uint256 depositedShells = l.deposit(address(usdt), 5e6);

        assertEq(withdrawnShells / 1e5, depositedShells / 1e5);

    }

    // TODO: this one.
    function test_s6_selectiveWithdraw_continuity_antiSlippage_reversal () public {
 
        l.deposit(
            address(dai), 135e18,
            address(usdc), 90e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 withdrawnShells = l.withdraw(address(dai), 5e18);

        uint256 depositedShells = l.deposit(address(dai), 5e18);

        assertEq(withdrawnShells / 1e5, depositedShells / 1e5);

    }

    // TODO: this one.
    function test_s6_selectiveDeposit_continuity_antiSlippage_reversal () public {

        l.deposit(
            address(dai), 130e18,
            address(usdc), 90e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 depositedShells = l.deposit(address(usdt), 5e6);

        uint256 withdrawnShells = l.withdraw(address(usdt), 5e6);

        assertEq(withdrawnShells / 1e5, depositedShells / 1e5);

    }


    function test_s6_continuity_swap_slippage_reversals () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 targetAmount = l.originSwap(
            address(usdc),
            address(usdt),
            5e6
        );

        uint256 originAmount = l.originSwap(
            address(usdt),
            address(usdc),
            targetAmount
        );

        assertEq(originAmount, 5e6 - 1);

    }

    function test_s6_continuity_swap_antiSlippage_reversals () public {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 targetAmount = l.originSwap(
            address(usdt),
            address(usdc),
            5e6
        );

        uint256 originAmount = l.targetSwap(
            address(usdc),
            address(usdt),
            5e6
        );

        assertEq(originAmount, targetAmount);

    }

    function test_s6_continuity_synthesizedOriginSwap_slippage () public {

        doubleDeposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 targetAmount = l.originSwap(
            address(usdc),
            address(usdt),
            5e6
        );

        uint256 depositShells = l2.deposit(address(usdc), 5e6);

        uint256 withdrawShells = l2.withdraw(address(usdt), targetAmount);

        assertEq(depositShells / 1e13, withdrawShells / 1e13);

    }

    function test_s6_continuity_synthesizedOriginSwap_antiSlippage () public {

        doubleDeposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 targetAmount = l.originSwap(
            address(usdt),
            address(usdc),
            5e6
        );

        uint256 depositShells = l2.deposit(address(usdt), 5e6);

        uint256 withdrawShells = l2.withdraw(address(usdc), targetAmount);

        assertEq(depositShells / 1e13, withdrawShells / 1e13);

    }

    function test_s6_continuity_synthesizedTargetswap_slippage () public {

        doubleDeposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 originAmount = l.targetSwap(
            address(usdc),
            address(usdt),
            5e6
        );

        uint256 depositShells = l2.deposit(address(usdc), originAmount);

        uint256 withdrawShells = l2.withdraw(address(usdt), 5e6);

        assertEq(depositShells / 1e13, withdrawShells / 1e13);

    }

    function test_s6_continuity_synthesizedTargetswap_antiSlippage () public {

        doubleDeposit(
            address(dai), 90e18,
            address(usdc), 135e6,
            address(usdt), 60e6,
            address(susd), 30e18
        );

        uint256 originAmount = l.targetSwap(
            address(usdt),
            address(usdc),
            5e6
        );

        uint256 depositShells = l2.deposit(address(usdt), originAmount);

        uint256 withdrawShells = l2.withdraw(address(usdc), 5e6);

        assertEq(depositShells / 1e13, withdrawShells / 1e13);

    }
}
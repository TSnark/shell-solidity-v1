pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./depositsTemplate.sol";

contract SelectiveDepositSuiteOne is SelectiveDepositTemplate, DSTest {

    function setUp() public {

        l = getLoihiSuiteOne();

    }

    function test_s1_selectiveDeposit_noSlippage_balanced_10DAI_10USDC_10USDT_2p5SUSD () public {

        uint256 newShells = super.noSlippage_balanced_10DAI_10USDC_10USDT_2p5SUSD();

        assertEq(newShells, 32499999216641686631);

    }

    function test_s1_selectiveDeposit_balanced_5DAI_1USDC3_USDT_1SUSD () public {

        uint256 newShells = super.balanced_5DAI_1USDC3_USDT_1SUSD();

        assertEq(newShells, 9999998966167174500);

    }

    function test_s1_selectiveDeposit_partialUpperSlippage_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 newShells = super.partialUpperSlippage_145DAI_90USDC_90USDT_50SUSD();

        assertEq(newShells, 374956943424882834388);

    }

    function test_s1_selectiveDeposit_partialLowerSlippage_95DAI_55USDC_95USDT_15SUSD () public {

        uint256 newShells = super.partialLowerSlippage_95DAI_55USDC_95USDT_15SUSD();

        assertEq(newShells, 259906409242241292207);

    }

    function test_s1_selectiveDeposit_partialUpperSlippage_5DAI_5USDC_70USDT_28SUSD_300Proportional () public {

        uint256 newShells = super.partialUpperSlippage_5DAI_5USDC_70USDT_28SUSD_300Proportional();

        assertEq(newShells, 107839868987150692242);

    }

    function test_s1_selectiveDeposit_partialLowerSlippage_moderatelyUnbalanced_1DAI_51USDC_51USDT_1SUSD () public {

        uint256 newShells = super.partialLowerSlippage_moderatelyUnbalanced_1DAI_51USDC_51USDT_1SUSD();

        assertEq(newShells, 103803800870238866890);

    }

    function test_s1_selectiveDeposit_partialLowerSlippage_balanced_0p001DAI_90USDC_90USDT () public {

        uint256 newShells = super.partialLowerSlippage_balanced_0p001DAI_90USDC_90USDT();

        assertEq(newShells, 179701018321068682614);

    }

    function test_s1_selectiveDeposit_partialUpperAntiSlippage_46USDC_53USDT_into_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 newShells = super.partialUpperAntiSlippage_46USDC_53USDT_into_145DAI_90USDC_90USDT_50SUSD();

        assertEq(newShells, 99008609844270035541);

    }

    function test_s1_selectiveDeposit_partialUpperAntiSlippage_unbalanced_1DAI_46USDC_53USDT_1SUSD_into_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 newShells = super.partialUpperAntiSlippage_unbalanced_1DAI_46USDC_53USDT_1SUSD_into_145DAI_90USDC_90USDT_50SUSD();

        assertEq(newShells, 101008609838582174525);

    }

    function test_s1_selectiveDeposit_noSlippage_36CHAI_into_300Proportional () public {

        uint256 shellsMinted = super.noSlippage_36CHAI_into_300Proportional();

        assertEq(shellsMinted, 35991000233367100000);

    }

    function test_s1_selectiveDeposit_partialLowerAntiSlippage_36CUSDC_18ASUSD_into_95DAI_55USDC_95USDT_15SUSD () public {

        uint256 newShells = super.partialLowerAntiSlippage_36CUSDC_18ASUSD_into_95DAI_55USDC_95USDT_15SUSD();

        assertEq(newShells,  53991711756245652892);

    }

    function test_s1_selectiveDeposit_partialLowerAntiSlippage_36USDC_18SUSD_into_95DAI_55USDC_95USDT_15SUSD () public {

        uint256 newShells = super.partialLowerAntiSlippage_36USDC_18SUSD_into_95DAI_55USDC_95USDT_15SUSD();

        assertEq(newShells, 54018716739832990695);

    }

    function test_s1_selectiveDeposit_fullUpperSlippage_5USDC_3SUSD_into_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 newShells = super.fullUpperSlippage_5USDC_3SUSD_into_90DAI_145USDC_90USDT_50SUSD();

        assertEq(newShells, 7939105448732499106);

    }

    function test_s1_selectiveDeposit_fullLowerSlippage_12DAI_12USDC_1USDT_1SUSD_into_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 newShells = super.fullLowerSlippage_12DAI_12USDC_1USDT_1SUSD_into_95DAI_95USDC_55USDT_15SUSD();

        assertEq(newShells, 25908472086895042433);

    }

    function test_s1_selectiveDeposit_fullLowerSlippage_9DAI_9USDC_into_95DAI_95USDC_55USDT_15SUSD () public {

        uint256 newShells = super.fullLowerSlippage_9DAI_9USDC_into_95DAI_95USDC_55USDT_15SUSD();

        assertEq(newShells, 17902137819144617096);

    }

    function test_s1_selectiveDeposit_fullUpperAntiSlippage_5CHAI_5USDC_into_90DAI_90USDC_145USDT_50SUSD () public {

        uint256 newShells = super.fullUpperAntiSlippage_5CHAI_5USDC_into_90DAI_90USDC_145USDT_50SUSD();

        assertEq(newShells, 10001714411049177790);

    }

    function test_s1_selectiveDeposit_fullUpperAntiSlippage_5DAI_5USDC_into_90DAI_90USDC_145USDT_50SUSD () public {

        uint256 newShells = super.fullUpperAntiSlippage_5DAI_5USDC_into_90DAI_90USDC_145USDT_50SUSD();

        assertEq(newShells, 10006716145229473334);

    }

    function test_s1_selectiveDeposit_fullUpperAntiSlippage_8DAI_12USDC_10USDT_2SUSD_into_145DAI_90USDC_90USDT_50SUSD () public {

        uint256 newShells = super.fullUpperAntiSlippage_8DAI_12USDC_10USDT_2SUSD_into_145DAI_90USDC_90USDT_50SUSD();

        assertEq(newShells, 32007965048728686700);

    }

    function test_s1_selectiveDeposit_fullLowerAntiSlippage_5DAI_5USDC_5USDT_2SUSD_into_55DAI_95USDC_95USDT_15SUSD  () public {

        uint256 newShells = super.fullLowerAntiSlippage_5DAI_5USDC_5USDT_2SUSD_into_55DAI_95USDC_95USDT_15SUSD();

        assertEq(newShells, 17007126629845201617);

    }

    function test_s1_selectiveDeposit_noSlippage_36CDAI_into_300Proportional () public {

        uint256 shellsMinted = super.noSlippage_36CDAI_into_300Proportional();

        assertEq(shellsMinted, 35991000239800010000);

    }

    function test_s1_selectiveDeposit_noSlippage_36DAI_from_300Proportional () public {

        uint256 shellsMinted = super.noSlippage_36DAI_from_300Proportional();

        assertEq(shellsMinted, 36000000233425481370);

    }

    function test_s1_selectiveDeposit_upperSlippage_36Point001Dai_into_300Proportional () public {

        uint256 shellsMinted = super.upperSlippage_36Point001Dai_into_300Proportional();

        assertEq(shellsMinted, 36001000238070333757);

    }

    function test_s1_selectiveDeposit_megaDepositDirectLowerToUpper_105DAI_37SUSD_from_55DAI_95USDC_95USDT_15SUSD () public {

        uint256 newShells = super.megaDepositDirectLowerToUpper_105DAI_37SUSD_from_55DAI_95USDC_95USDT_15SUSD();

        assertEq(newShells, 142003004834841080526);

    }

    function test_s1_selectiveDeposit_megaDepositIndirectUpperToLower_165DAI_165USDT_into_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 newShells = super.megaDepositIndirectUpperToLower_165DAI_165USDT_into_90DAI_145USDC_90USDT_50SUSD();

        assertEq(newShells, 329943557873174181881);

    }

    function test_s1_selectiveDeposit_megaDepositIndirectUpperLower_165CDAI_0p0001CUSDC_165USDT_0p5SUSD_into_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 newShells = super.megaDepositIndirectUpperLower_165CDAI_0p0001CUSDC_165USDT_0p5SUSD_into_90DAI_145USDC_90USDT_50SUSD();

        assertEq(newShells, 33028053905716828894);

    }

    function test_s1_selectiveDeposit_megaDepositIndirectUpperToLower_165DAI_0p0001USDC_165USDT_0p5SUSD_from_90DAI_145USDC_90USDT_50SUSD () public {

        uint256 newShells = super.megaDepositIndirectUpperToLower_165DAI_0p0001USDC_165USDT_0p5SUSD_from_90DAI_145USDC_90USDT_50SUSD();

        assertEq(newShells, 330445739346952556280);

    }

    function testFailSelectiveDepositUpperHaltCheck30Pct () public {

        l.proportionalDeposit(300e18);

        l.deposit(address(dai), 100e18);

    }

    function testFailSelectiveDepositLowerHaltCheck30Pct () public {

        l.proportionalDeposit(300e18);

        l.deposit(
            address(dai), 300e18,
            address(usdt), 300e6,
            address(susd), 100e18
        );

    }

    function testFailSelectiveDepositDepostUpperHaltCheck10Pct () public {

        l.proportionalDeposit(300e18);

        l.deposit(address(susd), 500e18);

    }

    function testFailSelectiveDepositLowerHaltCheck10Pct () public {

        l.proportionalDeposit(300e18);

        l.deposit(
            address(dai), 200e18,
            address(usdc), 200e6,
            address(usdt), 200e6
        );

    }

    function testExecuteProportionalDepositIntoAnUnbalancedShell () public {

        uint256[] memory deposits = super.proportionalDeposit_unbalancedShell();

        assertEq(deposits[0], 21891891950913103706);
        assertEq(deposits[1], 21891891000000000000);
        assertEq(deposits[2], 34054054000000000000);
        assertEq(deposits[3], 12162162195035371650);

    }

    function testExecuteProportionalDepositIntoSlightlyUnbalancedShell () public {

        uint256[] memory deposits = super.proportionalDeposit_slightlyUnbalancedShell();

        assertEq(deposits[0], 29999999900039235636);
        assertEq(deposits[1], 27000000000000000000);
        assertEq(deposits[2], 23999999000000000000);
        assertEq(deposits[3], 8999999970001503300);

    }

    function testExecuteProportionalDepositIntoWidelyUnbalancedShell () public {

        uint256[] memory deposits = super.proportionalDeposit_heavilyUnbalancedShell();

        assertEq(deposits[0], 27000000089910320148);
        assertEq(deposits[1], 37499999000000000000);
        assertEq(deposits[2], 16500000000000000000);
        assertEq(deposits[3], 9000000030002282550);

    }

    function test_s1_selectiveDeposit_smartHalt_upper_outOfBounds_to_outOfBounds () public {

        bool success = super.smartHalt_upper_outOfBounds_to_outOfBounds();

        assertTrue(success);

    }

    function test_s1_selectiveDeposit_smartHalt_upper_outOfBounds_to_inBounds () public {

        bool success = super.smartHalt_upper_outOfBounds_to_inBounds();

        assertTrue(success);

    }
    function test_s1_selectiveDeposit_smartHalt_upper_outOfBounds_exacerbated () public {

        bool success = super.smartHalt_upper_outOfBounds_exacerbated();

        assertTrue(!success);

    }

    function test_s1_selectiveDeposit_smartHalt_lower_outOfBounds_to_outOfBounds () public {

        bool success = super.smartHalt_lower_outOfBounds_to_outOfBounds();

        assertTrue(success);

    }

    function test_s1_selectiveDeposit_smartHalt_lower_outOfBounds_to_inBounds () public {

        bool success = super.smartHalt_lower_outOfBounds_to_inBounds();

        assertTrue(success);

    }

    function test_s1_selectiveDeposit_smartHalt_lower_unrelated () public {

        bool success = super.smartHalt_lower_unrelated();

        assertTrue(!success);

    }
}
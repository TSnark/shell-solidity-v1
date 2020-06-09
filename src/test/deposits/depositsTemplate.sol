pragma solidity ^0.5.0;

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../interfaces/IAssimilator.sol";

import "../setup/setup.sol";

import "../setup/methods.sol";

contract SelectiveDepositTemplate is Setup {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using LoihiMethods for Loihi;

    Loihi l;

    function noSlippage_balanced_10DAI_10USDC_10USDT_2p5SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.proportionalDeposit(300e18);

        shellsMinted_ = l.deposit(
            address(dai), 10e18,
            address(usdc), 10e6,
            address(usdt), 10e6,
            address(susd), 2.5e18
        );

    }

    function balanced_5DAI_1USDC3_USDT_1SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 85e6,
            address(susd), 35e18
        );

        shellsMinted_ = l.deposit(
            address(dai), 5e18,
            address(usdc), 1e6,
            address(usdt), 3e6,
            address(susd), 1e18
        );

    }

    function partialUpperSlippage_145DAI_90USDC_90USDT_50SUSD () public returns (uint256 shellsMinted_) {

        shellsMinted_ = l.deposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

    }

    function partialLowerSlippage_95DAI_55USDC_95USDT_15SUSD () public returns (uint256 shellsMinted_) {

        shellsMinted_ = l.deposit(
            address(dai), 95e18,
            address(usdc), 55e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

    }

    function partialUpperSlippage_5DAI_5USDC_70USDT_28SUSD_300Proportional () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.proportionalDeposit(300e18);

        shellsMinted_ = l.deposit(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 70e6,
            address(susd), 28e18
        );

    }

    function partialLowerSlippage_moderatelyUnbalanced_1DAI_51USDC_51USDT_1SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 80e18,
            address(usdc), 100e6,
            address(usdt), 100e6,
            address(susd), 23e18
        );

        shellsMinted_ = l.deposit(
            address(dai), 1e18,
            address(usdc), 51e6,
            address(usdt), 51e6,
            address(susd), 1e18
        );

    }

    function partialLowerSlippage_balanced_0p001DAI_90USDC_90USDT () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.proportionalDeposit(300e18);

        shellsMinted_ = l.deposit(
            address(dai), .001e18,
            address(usdc), 90e6,
            address(usdt), 90e6
        );

    }

    function partialUpperAntiSlippage_46USDC_53USDT_into_145DAI_90USDC_90USDT_50SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        shellsMinted_ = l.deposit(
            address(usdc), 46e6,
            address(usdt), 53e6
        );

    }

    function partialUpperAntiSlippage_unbalanced_1DAI_46USDC_53USDT_1SUSD_into_145DAI_90USDC_90USDT_50SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        shellsMinted_ = l.deposit(
            address(dai), 1e18,
            address(usdc), 46e6,
            address(usdt), 53e6,
            address(susd), 1e18
        );

    }

    function noSlippage_36CHAI_into_300Proportional () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.proportionalDeposit(300e18);

        uint256 _chaiOf36Numeraire = chaiAssimilator.viewRawAmount(uint(36e18).divu(1e18));

        shellsMinted_ = l.deposit(address(chai), _chaiOf36Numeraire);

    }

    function partialLowerAntiSlippage_36CUSDC_18ASUSD_into_95DAI_55USDC_95USDT_15SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 55e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        uint256 cusdcOf36Numeraire = cusdcAssimilator.viewRawAmount(uint(36e18).divu(1e18));
        uint256 asusdOf18Numeraire = asusdAssimilator.viewRawAmount(uint(18e18).divu(1e18));

        shellsMinted_ = l.deposit(
            address(cusdc), cusdcOf36Numeraire,
            address(asusd), asusdOf18Numeraire
        );

    }

    function partialLowerAntiSlippage_36USDC_18SUSD_into_95DAI_55USDC_95USDT_15SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 55e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        shellsMinted_ = l.deposit(
            address(usdc), 36e6,
            address(susd), 18e18
        );

    }

    function fullUpperSlippage_5USDC_3SUSD_into_90DAI_145USDC_90USDT_50SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        shellsMinted_ = l.deposit(
            address(usdc), 5e6,
            address(susd), 3e18
        );

    }

    function fullLowerSlippage_12DAI_12USDC_1USDT_1SUSD_into_95DAI_95USDC_55USDT_15SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 95e6,
            address(usdt), 55e6,
            address(susd), 15e18
        );

        shellsMinted_ = l.deposit(
            address(dai), 12e18,
            address(usdc), 12e6,
            address(usdt), 1e6,
            address(susd), 1e18
        );

    }

    function fullLowerSlippage_9DAI_9USDC_into_95DAI_95USDC_55USDT_15SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 95e18,
            address(usdc), 95e6,
            address(usdt), 55e6,
            address(susd), 15e18
        );

        shellsMinted_ = l.deposit(
            address(dai), 9e18,
            address(usdc), 9e6
        );

    }

    function fullUpperAntiSlippage_5CHAI_5USDC_into_90DAI_90USDC_145USDT_50SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 145e6,
            address(susd), 50e18
        );

        uint256 chaiOf5Numeraire = chaiAssimilator.viewRawAmount(uint(5e18).divu(1e18));
        uint256 cusdcOf5Numeraire = cusdcAssimilator.viewRawAmount(uint(5e18).divu(1e18));

        shellsMinted_ = l.deposit(
            address(chai), chaiOf5Numeraire,
            address(cusdc), cusdcOf5Numeraire
        );

    }

    function fullUpperAntiSlippage_5DAI_5USDC_into_90DAI_90USDC_145USDT_50SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 145e6,
            address(susd), 50e18
        );

        shellsMinted_ = l.deposit(
            address(dai), 5e18,
            address(usdc), 5e6
        );

    }

    function fullUpperAntiSlippage_8DAI_12USDC_10USDT_2SUSD_into_145DAI_90USDC_90USDT_50SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 145e18,
            address(usdc), 90e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        shellsMinted_ = l.deposit(
            address(dai), 8e18,
            address(usdc), 12e6,
            address(usdt), 10e6,
            address(susd), 2e18
        );

    }

    function fullLowerAntiSlippage_5DAI_5USDC_5USDT_2SUSD_into_55DAI_95USDC_95USDT_15SUSD  () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 55e18,
            address(usdc), 95e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        shellsMinted_ = l.deposit(
            address(dai), 5e18,
            address(usdc), 5e6,
            address(usdt), 5e6,
            address(susd), 2e18
        );

    }

    function noSlippage_36CDAI_into_300Proportional () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.proportionalDeposit(300e18);

        uint256 cdaiOf36Numeraire = cdaiAssimilator.viewRawAmount(uint(36e18).divu(1e18));

        shellsMinted_ = l.deposit(address(cdai), cdaiOf36Numeraire);

    }

    function noSlippage_36DAI_from_300Proportional () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.proportionalDeposit(300e18);

        shellsMinted_ = l.deposit(address(dai), 36e18);

    }

    function upperSlippage_36Point001Dai_into_300Proportional () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.proportionalDeposit(300e18);

        shellsMinted_ = l.deposit(address(dai), 36.001e18);

    }

    function megaDepositDirectLowerToUpper_105DAI_37SUSD_from_55DAI_95USDC_95USDT_15SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 55e18,
            address(usdc), 95e6,
            address(usdt), 95e6,
            address(susd), 15e18
        );

        shellsMinted_ = l.deposit(
            address(dai), 105e18,
            address(susd), 37e18
        );

    }

    function megaDepositIndirectUpperToLower_165DAI_165USDT_into_90DAI_145USDC_90USDT_50SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        shellsMinted_ = l.deposit(
            address(dai), 165e18,
            address(usdt), 165e6
        );

    }

    function megaDepositIndirectUpperLower_165CDAI_0p0001CUSDC_165USDT_0p5SUSD_into_90DAI_145USDC_90USDT_50SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        uint256 cdaiOf165Numeraire = cdaiAssimilator.viewRawAmount(uint(165e18).divu(1e18));
        uint256 cusdcOf0Point0001Numeraire = cusdcAssimilator.viewRawAmount(uint(0.0001e6).divu(1e6));

        shellsMinted_ = l.deposit(
            address(cdai), cdaiOf165Numeraire,
            address(cusdc), cusdcOf0Point0001Numeraire,
            address(usdt), 165e6,
            address(susd), 5e18
        );

    }

    function megaDepositIndirectUpperToLower_165DAI_0p0001USDC_165USDT_0p5SUSD_from_90DAI_145USDC_90USDT_50SUSD () public returns (uint256 shellsMinted_) {

        uint256 startingShells = l.deposit(
            address(dai), 90e18,
            address(usdc), 145e6,
            address(usdt), 90e6,
            address(susd), 50e18
        );

        shellsMinted_ = l.deposit(
            address(dai), 165e18,
            address(usdc), 0.0001e6,
            address(usdt), 165e6,
            address(susd), .5e18
        );

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

    function proportionalDeposit_unbalancedShell () public returns (uint256[] memory) {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 90e6,
            address(usdt), 140e6,
            address(susd), 50e18
        );

        ( , uint256[] memory _before ) = l.totalReserves();

        l.proportionalDeposit(90e18);

        ( , uint256[] memory after_ ) = l.totalReserves();

        after_[0] = after_[0] - _before[0];
        after_[1] = after_[1] - _before[1];
        after_[2] = after_[2] - _before[2];
        after_[3] = after_[3] - _before[3];

        return after_;

    }

    function proportionalDeposit_slightlyUnbalancedShell () public returns (uint256[] memory) {

        l.deposit(
            address(dai), 100e18,
            address(usdc), 90e6,
            address(usdt), 80e6,
            address(susd), 30e18
        );

        ( , uint256[] memory _before ) = l.totalReserves();

        l.proportionalDeposit(90e18);

        ( , uint256[] memory after_ ) = l.totalReserves();

        after_[0] = after_[0] - _before[0];
        after_[1] = after_[1] - _before[1];
        after_[2] = after_[2] - _before[2];
        after_[3] = after_[3] - _before[3];

        return after_;

    }

    function proportionalDeposit_heavilyUnbalancedShell () public returns (uint256[] memory) {

        l.deposit(
            address(dai), 90e18,
            address(usdc), 125e6,
            address(usdt), 55e6,
            address(susd), 30e18
        );

        ( , uint256[] memory _before ) = l.totalReserves();

        l.proportionalDeposit(90e18);

        ( , uint256[] memory after_ ) = l.totalReserves();

        after_[0] = after_[0] - _before[0];
        after_[1] = after_[1] - _before[1];
        after_[2] = after_[2] - _before[2];
        after_[3] = after_[3] - _before[3];

        return after_;

    }

    function smartHalt_upper_outOfBounds_exacerbated () public returns (bool success_) {

        l.proportionalDeposit(300e18);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(110e18).divu(1e18));

        cusdc.transfer(address(l), _rawCUsdc);
        usdc.transfer(address(l), 110e6);

        success_ = l.depositSuccess(
            address(usdc), 1e6
        );

    }

    function smartHalt_upper_outOfBounds_to_outOfBounds () public returns (bool success_) {

        l.proportionalDeposit(300e18);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(110e18).divu(1e18));

        cusdc.transfer(address(l), _rawCUsdc);
        usdc.transfer(address(l), 110e6);

        success_ = l.depositSuccess(
            address(dai), 1e18,
            address(usdt), 1e6,
            address(susd), 1e18
        );

    }

    function smartHalt_upper_outOfBounds_to_inBounds () public returns (bool success_) {

        l.proportionalDeposit(300e18);

        uint256 _rawCUsdc = cusdcAssimilator.viewRawAmount(uint256(110e18).divu(1e18));

        cusdc.transfer(address(l), _rawCUsdc);
        usdc.transfer(address(l), 110e6);

        success_ = l.depositSuccess(
            address(dai), 110e18,
            address(usdt), 110e6,
            address(susd), 35e18
        );

    }

    function smartHalt_lower_unrelated () public returns (bool success_) {

        l.proportionalDeposit(67e18);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(70e18).divu(1e18));

        cdai.transfer(address(l), _rawCDai);
        dai.transfer(address(l), 70e18);

        usdt.transfer(address(l), 70e6);
        ausdt.transfer(address(l), 70e6);

        susd.transfer(address(l), 23e18);
        asusd.transfer(address(l), 23e18);

        success_ = l.depositSuccess(
            address(dai), 1e18,
            address(usdt), 1e6,
            address(susd), 1e18
        );

    }

    function smartHalt_lower_outOfBounds_to_outOfBounds () public returns (bool success_) {

        l.proportionalDeposit(67e18);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(70e18).divu(1e18));

        cdai.transfer(address(l), _rawCDai);
        dai.transfer(address(l), 70e18);

        usdt.transfer(address(l), 70e6);
        ausdt.transfer(address(l), 70e6);

        susd.transfer(address(l), 23e18);
        asusd.transfer(address(l), 23e18);

        success_ = l.depositSuccess(
            address(usdc), 1e6
        );

    }

    function smartHalt_lower_outOfBounds_to_inBounds () public returns (bool success_) {

        l.proportionalDeposit(67e18);

        uint256 _rawCDai = cdaiAssimilator.viewRawAmount(uint256(70e18).divu(1e18));

        cdai.transfer(address(l), _rawCDai);
        dai.transfer(address(l), 70e18);

        usdt.transfer(address(l), 70e6);
        ausdt.transfer(address(l), 70e6);

        susd.transfer(address(l), 23e18);
        asusd.transfer(address(l), 23e18);

        success_ = l.depositSuccess(
            address(usdc), 50e6
        );

    }


}
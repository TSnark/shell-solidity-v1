pragma solidity ^0.5.12;

import "ds-math/math.sol";

import "./LoihiRoot.sol";
import "./ChaiI.sol";
import "./CTokenI.sol";
import "./ERC20I.sol";
import "./ERC20Token.sol";

contract Loihi is LoihiRoot { 

    constructor() public { }

    function includeAdaptation (address flavor, address adaptation, address reserve, uint256 weight) public {
        flavors[flavor] = Flavor(adaptation, reserve, weight);
    }

    function excludeAdaptation (address flavor) public {
        delete flavors[flavor];
    }

    function dGetNumeraireAmount (address addr, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("getNumeraireAmount(uint256)", amount));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function dGetNumeraireBalance (address addr) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("getNumeraireBalance()"));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function dIntakeRaw (address src, uint256 amount) internal {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("intakeRaw(address, uint256)", src, amount));
        assert(success);
    }

    function dOutput (address dst, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSignature("output(address, uint256)", src, amount));
        assert(success);
        return abi.decode(result, (uint256));
    }

    function swapByTarget (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline) public returns (uint256) {
        return executeTargetTrade(origin, maxOriginAmount, target, targetAmount, deadline, msg.sender);
    }
    function transferByTarget (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline, address recipient) public returns (uint256) {
        return executeTargetTrade(origin, maxOriginAmount, target, targetAmount, deadline, recipient);
    }
    function swapByOrigin (address origin, uint256 originAmount, address target, uint256 minTargetAmount, uint256 deadline) public returns (uint256) {
        return executeOriginTrade(origin, originAmount, target, minTargetAmount, deadline, msg.sender);
    }
    function transferByOrigin (address origin, uint256 originAmount, address target, uint256 minTargetAmount, uint256 deadline, address recipient) public returns (uint256) {
        return executeOriginTrade(origin, originAmount, target, minTargetAmount, deadline, recipient);
    }

    function executeOriginTrade (address origin, uint256 oAmt, address target, uint256 minTargetAmount, uint256 deadline, address recipient) public returns (uint256) {

        Flavor memory o = flavors[origin]; // origin rolodex
        Flavor memory t = flavors[target]; // target rolodex
        uint256 oNAmt; // origin numeraire amount
        uint256 oPool; // origin pool balance
        uint256 tPool; // target pool balance
        uint256 tNAmt; // target numeraire swap amount
        uint256 grossLiq; // total liquidity in all coins

        for (uint i = 0; i < reservesList.length; i++) {
            if (reservesList[i] == o.adapter) {
                oNAmt = dGetNumeraireAmount(o.adapter, oAmt);
                oPool = add(dGetNumeraireBalance(o.adapter, oNAmt);
                grossLiq += oPool;
            } else if (reservesList[i] == t.adapter) {
                tPool = dGetNumeraireBalance(t.adapter);
                grossLiq += tPool;
            } else grossLiq += dGetNumeraireBalance(reservesList[i]);
        }

        require(oPool <= wmul(o.weight, wmul(grossLiq, alpha + WAD)), "origin swap halt check");

        uint256 feeThreshold = wmul(o.weight, wmul(grossLiq, beta + WAD));
        if (oPool < feeThreshold) {
            oNAmt = oNAmt;
        } else if (sub(oPool, oNAmt) >= feeThreshold) {
            uint256 fee = wdiv(oNAmt, wmul(o.weight, grossLiq));
            fee = wmul(fee, feeDerivative);
            oNAmt = wmul(oNAmt, WAD - fee);
        } else {
            uint256 oldBalance = sub(oPool, oNAmt);
            uint256 fee = wmul(feeDerivative, wdiv(
                sub(oPool, feeThreshold),
                wmul(o.weight, grossLiq)
            ));
            oNAmt = add(
                sub(feeThreshold, oldBalance),
                wmul(sub(oPool, feeThreshold), WAD - fee)
            );
        }

        tNAmt = oNAmt;
        require(sub(tPool, tNAmt) >= wmul(t.weight, wmul(grossLiq, WAD - alpha)), "target swap halt check");

        feeThreshold = wmul(t.weight, wmul(grossLiq, WAD - beta));
        if (sub(tPool, tNAmt) > feeThreshold) {
            tNAmt = wmul(tNAmt, WAD - feeBase);
        } else if (tPool <= feeThreshold) {
            uint256 fee = wmul(feeDerivative, wdiv(tNAmt, wmul(t.weight, grossLiq))) - feeBase;
            tNAmt = wmul(tNAmt, WAD - fee);
        } else {
            uint256 fee = wmul(feeDerivative, wdiv(
                sub(feeThreshold, sub(tPool, tNAmt)),
                wmul(t.weight, grossLiq)
            ));
            tNAmt = wmul(add(
                sub(tPool, feeThreshold),
                wmul(sub(feeThreshold, sub(tPool, tNAmt)), WAD - fee)
            ), WAD - feeBase);
        }

        dIntakeRaw(o.adapter, msg.sender, oAmt);
        dOutputNumeraire(t.adapter, recipient, tNAmt);

    }

    function executeTargetTrade (address origin, uint256 maxOriginAmount, address target, uint256 tAmt, uint256 deadline, address recipient) public returns (uint256) {
        require(deadline > now, "transaction deadline has passed");

        Flavor memory t = flavors[target]; // target rolodex
        Flavor memory o = flavors[origin]; // origin rolodex
        uint256 tNAmt; // target numeraire swap amount
        uint256 tPool; // target pool balance
        uint256 oPool; // origin pool balance
        uint256 oNAmt; // origin numeriare swap amount
        uint256 grossLiq; // gross liquidity

        for (uint i = 0; i < reservesList.length; i++) {
            if (reservesList[i] == o.reserve) {
                oPool = dGetBalance(o.reserve);
                grossLiq += oPool;
            } else if (reservesList[i] == t.reserve) {
                tNAmt = dGetNumeraireAmount(t.adaptation, tNAmt);
                tPool = sub(dGetBalance(t.reserve), tNAmt);
                grossLiq += tPool;
            } else grossLiq += dGetBalance(reservesList[i]);
        }

        require(tPool - tNAmt >= wmul(t.weight, wmul(grossLiq, WAD - alpha)), "target halt check");

        uint256 feeThreshold = wmul(t.weight, wmul(grossLiq, WAD - beta));
        if (tPool > feeThreshold) {
            tNAmt = wmul(tNAmt, WAD - feeBase);
        } else if (add(tPool, tNAmt) <= feeThreshold) {
            uint256 fee = wmul(feeDerivative, wdiv(tNAmt, wmul(t.weight, grossLiq))) + feeBase;
            tNAmt = wmul(tNAmt, WAD + fee);
        } else {
            uint256 fee = wmul(feeDerivative, wdiv(
                    sub(feeThreshold, tPool),
                    wmul(t.weight, grossLiq)
            ));
            tNAmt = add(
                sub(add(tPool, tNAmt), feeThreshold),
                wmul(sub(feeThreshold, tPool), WAD + fee)
            );
            tNAmt = wmul(tNAmt, WAD + feeBase);
        }

        oNAmt = tNAmt;
        require(oPool + oNAmt <= wmul(o.weight, wmul(grossLiq, WAD + alpha)));

        feeThreshold = wmul(o.weight, wmul(grossLiq, WAD + beta));
        if (oPool + oNAmt < feeThreshold) { }
        else if (oPool >= feeThreshold) {
            uint256 fee = wmul(feeDerivative, wdiv(o.weight, grossLiq));
            oNAmt = wmul(oNAmt, WAD + fee);
        } else {
            uint256 fee = wmul(feeDerivative, wdiv(
                sub(feeThreshold, oPool),
                wmul(o.weight, grossLiq)
            ));
            oNAmt = add(
                sub(feeThreshold, oPool),
                wmul(sub(add(oPool, oNAmt), feeThreshold), WAD + fee)
            );
        }

        dOutputRaw(t.adapter, recipient, tAmt);
        dIntakeNumeraire(o.adapter, msg.sender, oNAmt);

    }

    function selectiveDeposit (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256) {

        uint256 newSum;
        uint256 newShells;
        uint256[] memory balances = new uint256[](reservesList.length * 3);
        for (uint i = 0; i < _flavors.length; i += 3) {
            Flavor memory rolodex = flavors[_flavors[i]];
            for (uint j = 0; j < reservesList.length; j++) {
                if (reservesList[i] == rolodex.reserve) {
                    if (balances[i] == 0) {
                        balances[i] = dGetNumeraireBalance(rolodex.adapter);
                        balances[i+1] = dGetNumeraireAmount(rolodex.adapter, _amounts[i]);
                        balances[i+2] = rolodex.weight;
                        newSum = add(balances[i+1], newSum);
                    } else {
                        uint256 numeraireDeposit = dGetNumeraireAmount(rolodex.adapter, _amounts[i]);
                        balances[i+1] = add(numeraireDeposit, balances[i+1]);
                        newSum = add(numeraireDeposit, newSum);
                    }
                    break;
        } } }

        for (uint i = 0; i < balances.length; i += 3) {
            uint256 oldBalance = balances[i];
            uint256 depositAmount = balances[i+1];
            uint256 newBalance = add(oldBalance, depositAmount);

            require(newBalance <= wmul(balances[i+2], wmul(newSum, alpha + WAD)), "halt check deposit");

            uint256 feeThreshold = wmul(balances[i+2], wmul(newSum, beta + WAD));
            if (newBalance <= feeThreshold) {
                newShells += depositAmount;
            } else if (oldBalance > feeThreshold) {
                uint256 feePrep = wmul(feeDerivative, wdiv(depositAmount, wmul(balances[i+2], newSum)));
                newShells = add(newShells, WAD - feePrep);
            } else {
                uint256 feePrep = wmul(feeDerivative, wdiv(
                    sub(newBalance, feeThreshold),
                    wmul(balances[i+2], newBalance)
                ));
                newShells += add(
                    sub(feeThreshold, oldBalance),
                    wmul(sub(newBalance, feeThreshold), WAD - feePrep)
                );
        } }

        // adjust shell token amount out of numeraire values into shell token denominations

    }

    function selectiveWithdraw (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256) {

        uint256 newSum;
        uint256 shellsBurned;
        uint256[] memory balances = new uint256[](reservesList.length * 3);
        for (uint i = 0; i < _flavors.length; i += 3) {
            Flavor memory rolodex = flavors[_flavors[i]];
            for (uint j = 0; j < reservesList.length; j++) {
                if (reservesList[i] == rolodex.reserve) {
                    if (balances[i] == 0) {
                        balances[i] = dGetNumeraireBalance(rolodex.adapter);
                        balances[i+1] = dGetNumeraireAmount(rolodex.adapter, _amounts[i]);
                        balances[i+2] = rolodex.weight;
                        newSum = sub(add(newSum, balances[i]), balances[i+1]);
                    } else {
                        uint256 numeraireWithdraw = dGetNumeraireAmount(rolodex.adapter, _amounts[i]);
                        balances[i+1] = add(numeraireWithdraw, balances[i+1]);
                        newSum = sub(newSum, numeraireWithdraw);
                    }
                    break;
        } } }

        for (uint i = 0; i < balances.length; i += 3) {
            uint256 oldBalance = balances[i];
            uint256 withdrawAmount = balances[i+1];
            uint256 newBalance = sub(oldBalance, withdrawAmount);

            bool haltCheck = newBalance >= wmul(balances[i+2], wmul(newBalance, alpha - WAD));
            require(haltCheck, "withdraw halt check");

            uint256 feeThreshold = wmul(balances[i+2], wmul(newBalance, WAD - beta));
            if (newBalance >= feeThreshold) {
                shellsBurned += wmul(withdrawAmount, add(WAD, feeBase));
            } else if (oldBalance < feeThreshold) {
                uint256 feePrep = wdiv(withdrawAmount,
                    wmul(wmul(balances[i+2], newSum), wdiv(feeDerivative, WAD*2))
                ) + feeBase;
                shellsBurned += wmul(withdrawAmount, feePrep + WAD);
            } else {
                uint256 feePrep = wmul(feeDerivative,
                    wdiv(
                        sub(feeThreshold, newBalance),
                        wmul(balances[i+2], newSum)
                    )
                );
                shellsBurned += wmul(add(
                    sub(oldBalance, feeThreshold),
                    wmul(sub(feeThreshold, newBalance), feePrep + WAD)
                ), feeBase + WAD);
        }}

        // adjust shell token amount out of numeraire values into shell token denominations

    }
}
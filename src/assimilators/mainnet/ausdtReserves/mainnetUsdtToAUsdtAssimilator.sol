// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.5.0;

import "../../aaveResources/ILendingPool.sol";

import "../../aaveResources/ILendingPoolAddressesProvider.sol";

import "../../../interfaces/IAToken.sol";

import "../../../interfaces/IERC20.sol";

import "../../../interfaces/IAssimilator.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract MainnetUsdtToAUsdtAssimilator is IAssimilator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
    IERC20 constant usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

    constructor () public { }

    function getAUsdt () public view returns (IAToken) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        (,,,,,,,,,,,address aTokenAddress,) = pool.getReserveData(address(usdt));
        return IAToken(aTokenAddress);

    }

    // takes raw amount, transfers it in, wraps that in aUsdt, returns numeraire amount
    function intakeRaw (uint256 _amount) public returns (int128 amount_) {

        safeTransferFrom(usdt, msg.sender, address(this), _amount);

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        pool.deposit(address(usdt), _amount, 0);

        amount_ = _amount.divu(1e6);

    }

    // takes raw amount, transfers it in, wraps that in aUsdt, returns numeraire amount
    function intakeRawAndGetBalance (uint256 _amount) public returns (int128 amount_, int128 balance_) {

        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        emit log_uint("amount", _amount);
        emit log_uint("allowance", usdt.allowance(msg.sender, address(this)));
        emit log_uint("allowance", usdt.allowance(address(this), address(pool)));


        safeTransferFrom(usdt, msg.sender, address(this), _amount);


        pool.deposit(address(usdt), _amount, 0);

        IAToken _ausdt = getAUsdt();

        uint256 _balance = _ausdt.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    event log_uint(bytes32, uint);

    // takes numeraire amount, calculates raw amount, transfers that in, wraps it in aUsdt, returns raw amount
    function intakeNumeraire (int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        emit log_uint("amount", amount_);

        emit log_uint("allowance", usdt.allowance(msg.sender, address(this)));



        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());

        emit log_uint("allowance of ausdt", usdt.allowance(address(this), address(pool)));

        safeTransferFrom(usdt, msg.sender, address(this), amount_);

        pool.deposit(address(usdt), amount_, 0);

    }

    // takes raw amount, redeems that from aUsdt, transfers it out, returns numeraire amount
    function outputRaw (address _dst, uint256 _amount) public returns (int128 amount_) {

        IAToken _ausdt = getAUsdt();

        _ausdt.redeem(_amount);

        safeTransfer(usdt, _dst, _amount);

        amount_ = _amount.divu(1e6);

    }

    // takes raw amount, redeems that from aUsdt, transfers it out, returns numeraire amount
    function outputRawAndGetBalance (address _dst, uint256 _amount) public returns (int128 amount_, int128 balance_) {

        IAToken _ausdt = getAUsdt();

        _ausdt.redeem(_amount);

        safeTransfer(usdt, _dst, _amount);

        uint256 _balance = _ausdt.balanceOf(address(this));

        amount_ = _amount.divu(1e6);

        balance_ = _balance.divu(1e6);

    }

    // takes numeraire amount, calculates raw amount, redeems that from aUsdt, transfers it out, returns raw amount
    function outputNumeraire (address _dst, int128 _amount) public returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

        IAToken _ausdt = getAUsdt();

        _ausdt.redeem(amount_);

        safeTransfer(usdt, _dst, amount_);

    }

    // takes numeraire amount, returns raw amount
    function viewRawAmount (int128 _amount) public view returns (uint256 amount_) {

        amount_ = _amount.mulu(1e6);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmount (uint256 _amount) public view returns (int128 amount_) {

        amount_ = _amount.divu(1e6);

    }

    // returns numeraire amount of reserve asset, in this case aUSDT
    function viewNumeraireBalance (address _addr) public view returns (int128 balance_) {

        IAToken _ausdt = getAUsdt();

        uint256 _balance = _ausdt.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }

    // takes raw amount, returns numeraire amount
    function viewNumeraireAmountAndBalance (address _addr, uint256 _amount) public view returns (int128 amount_, int128 balance_) {

        amount_ = _amount.divu(1e6);

        IAToken _ausdt = getAUsdt();

        uint256 _balance = _ausdt.balanceOf(_addr);

        balance_ = _balance.divu(1e6);

    }

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function callOptionalReturn(address token, bytes memory data) private {
        (bool success, bytes memory returnData) = token.call(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
    }
}
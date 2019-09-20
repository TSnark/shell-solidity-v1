pragma solidity ^0.5.0;

import "ds-math/math.sol";
import "./Adjusters.sol";
import "./CowriState.sol";
import "./Shell.sol";
import "./ERC20Token.sol";

contract LiquidityMembrane is DSMath, Adjusters, CowriState {

    function depositLiquidity(address _shell, uint amount) public returns (uint256) {

        Shell shell = Shell(_shell);
        address[] memory tokens = shell.getTokens();
        uint capitalDeposited = mul(tokens.length, amount);
        uint256 totalSupply = shell.totalSupply();

        uint liqTokensMinted = totalSupply == 0
            ? capitalDeposited
            : wdiv(
                wmul(totalSupply, capitalDeposited),
                getTotalCapital(_shell)
            );

        for(uint i = 0; i < tokens.length; i++) {

            adjustedTransferFrom(
                ERC20Token(tokens[i]),
                msg.sender,
                amount
            );

            shells[_shell][address(tokens[i])] = add(
                shells[_shell][address(tokens[i])],
                amount
            );

        }

        shell.mint(msg.sender, liqTokensMinted);

        return liqTokensMinted;
    }

    function withdrawLiquidity(address _shell, uint liquidityTokensToBurn) public returns (uint256[] memory) {
        Shell shell = Shell(_shell);

        uint256 totalCapital = getTotalCapital(_shell);
        uint256 capitalWithdrawn = wdiv(
            wmul(totalCapital, liquidityTokensToBurn),
            shell.totalSupply()
        );

        address[] memory tokens = shell.getTokens();
        uint256[] memory amountsWithdrawn = new uint256[](tokens.length);
        for(uint i = 0; i < tokens.length; i++) {

            uint amount = wdiv(
                wmul(capitalWithdrawn, shells[address(shell)][address(tokens[i])]),
                totalCapital
            );

            amountsWithdrawn[i] = adjustedTransfer(
                ERC20Token(tokens[i]),
                msg.sender,
                amount
            );

            shells[_shell][address(tokens[i])] = sub(
                shells[_shell][address(tokens[i])],
                amount
            );

        }

        shell.testBurn(msg.sender, liquidityTokensToBurn);

        return amountsWithdrawn;
    }


    function getTotalCapital(address shell) public view returns (uint totalCapital) {
        address[] memory tokens = Shell(shell).getTokens();
        for (uint i = 0; i < tokens.length; i++) totalCapital = add(totalCapital, shells[shell][tokens[i]]);
        return totalCapital;
    }

}
pragma solidity >=0.5.0 <0.7.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract TokenGenerator is ERC20, ERC20Detailed {
    address account = msg.sender;
    constructor(
        string memory _name, string memory _symbol, uint8 _decimals, uint256 _value
    ) ERC20Detailed(
        _name, _symbol, _decimals
    ) public {
        _mint(account, _value);
    }
}
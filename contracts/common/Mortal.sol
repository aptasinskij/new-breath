pragma solidity 0.4.25;

import './Owned.sol';

contract Mortal is Owned {

    function kill() public onlyOwner {
        selfdestruct(address(0));
    }

}
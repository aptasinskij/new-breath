pragma solidity 0.4.25;

contract Owned {

    address internal _owner;

    modifier onlyOwner {
        require(msg.sender == _owner);
        _;
    }

    constructor () internal {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

}
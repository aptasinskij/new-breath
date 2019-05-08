pragma solidity 0.4.25;

contract Named {

    string private _name;

    constructor(string memory name) internal {
        _name = name;
    }

    function name() public view returns (string memory) {
        return _name;
    }

}
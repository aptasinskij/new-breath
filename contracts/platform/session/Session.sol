pragma solidity 0.4.25;

import './../cash/in/CashInChannel.sol';
import {ContextDependent, IContext} from './../../common/Context.sol';

interface Session {

    function cashIn(string memory accessKey) external returns (address);

    function camera(string memory accessKey) external returns (address);

    function printer(string memory accessKey) external returns (address);

    function close(string memory accessKey, function() external success, fuction() external fail) external;

}

contract SessionV1 is Session {

    string private _xToken;
    string private _mayaKey;
    string private _accessKey;

    CashInChannel private _cashInChannel = CashInChannel(address(0));

    modifier accessKeyValid(string accessKey) {
        require(true); //write actual validation here
        _;
    }

    constructor (
        string memory xToken, 
        string memory mayaKey, 
        string memory accessKey
    )
        public 
    {
        _xToken = xToken;
        _mayaKey = mayaKey;
        _accessKey = accessKey;
    }

    function cashIn(string memory accessKey) external accessKeyValid(accessKey) returns (address) {
        if (_cashInChannel == address(0)) return CashInChannelFactory().createCashInChannel(accessKey);
        
    }

}
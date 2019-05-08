pragma solidity 0.4.25;

import './Named.sol';
import './Owned.sol';
import {Database} from './Database.sol';

contract ContextDatabase is Database {}

library ContextPersistence {
    
    string constant CONTRACT_ADDRESS = 'contract.address';
    
    function setContract(ContextDatabase self, address contractAddress, string memory contractName) internal {
        require(contractAddress != address(0));
        self.setAddressValue(keccak256(abi.encodePacked(CONTRACT_ADDRESS, contractName)), contractAddress);
    }
    
    function getContract(ContextDatabase self, string memory contractName) internal view returns (address) {
        return self.getAddressValue(keccak256(abi.encodePacked(CONTRACT_ADDRESS, contractName)));
    }
    
}

interface IContext {
    
    function register(Named namedContract) external;

    function get(string name) external view returns (address contractAddress);

}

contract Context is IContext, Owned {
    
    using ContextPersistence for ContextDatabase;
    
    ContextDatabase private _contextDatabase;
    
    constructor (address contextDatabase) public {
        require(contextDatabase != address(0));
        _contextDatabase = ContextDatabase(contextDatabase);
    }
    
    function register(Named namedContract) external onlyOwner {
        _contextDatabase.setContract(address(namedContract), namedContract.name());
    }
    
    function get(string name) external view returns (address contractAddress) {
        return _contextDatabase.getContract(name);
    }

    function contextDatabase() public view returns (address) {
        return _contextDatabase;
    }

}
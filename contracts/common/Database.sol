pragma solidity 0.4.25;

import './Owned.sol';

contract Database is Owned {

    /// UINT STORAGE
    mapping(bytes32 => uint256) uintStorage;
     ///STRING STORAGE
    mapping(bytes32 => string) stringStorage;
    ///ADDRESS STORAGE
    mapping(bytes32 => address) addressStorage;
    ///BYTES STORAGE
    mapping(bytes32 => bytes) bytesStorage;
    /// BYTES32 STORAGE
    mapping (bytes32 => bytes32) bytes32Storage;
    ///BOOLEAN STORAGE
    mapping (bytes32 => bool) booleanStorage;
    ///UINT STORAGE
    mapping(bytes32 => int) intStorage;

    address private _repository;

    modifier onlyRepository {
        require(_repository != address(0) && msg.sender == _repository, 'Database: only repository allowed');
        _;
    }

    function setRepository(address repository) public onlyOwner {
        require(repository != address(0), 'Database: repository must not be 0x0');
        _repository = repository;
    }

    function repository() public view returns (address) {
        return _repository;
    }

    constructor () internal {}

    function getUintValue(bytes32 _key) public view returns (uint256) {
        return uintStorage[_key];
    }

    function getStringValue(bytes32 _key) public view returns (string) {
        return stringStorage[_key];
    }

    function getAddressValue(bytes32 _key) public view returns (address) {
        return addressStorage[_key];
    }

    function getBytesValue(bytes32 _key) public view returns (bytes) {
        return bytesStorage[_key];
    }

    function getBytes32Value(bytes32 _key) public view returns (bytes32) {
        return bytes32Storage[_key];
    }

    function getBooleanValue(bytes32 _key) public view returns (bool) {
        return booleanStorage[_key];
    }

    function getIntValue(bytes32 _key) public view returns (int){
        return intStorage[_key];
    }

    /***SET METHODS***/

    function setUintValue(bytes32 _key, uint256 _value) public onlyRepository {
        uintStorage[_key] = _value;
    }

    function setStringValue(bytes32 _key, string _value) public onlyRepository {
        stringStorage[_key] = _value;
    }

    function setAddressValue(bytes32 _key, address _value) public onlyRepository {
        addressStorage[_key] = _value;
    }

    function setBytesValue(bytes32 _key, bytes _value) public onlyRepository {
        bytesStorage[_key] = _value;
    }

    function setBytes32Value(bytes32 _key, bytes32 _value) public onlyRepository {
        bytes32Storage[_key] = _value;
    }

    function setBooleanValue(bytes32 _key, bool _value) public onlyRepository {
        booleanStorage[_key] = _value;
    }

    function setIntValue(bytes32 _key, int _value) public onlyRepository {
        intStorage[_key] = _value;
    }

    /***DELETE METHODS***/

    function deleteUintValue(bytes32 _key) public onlyRepository {
        delete uintStorage[_key];
    }

    function deleteStringValue(bytes32 _key) public onlyRepository {
        delete stringStorage[_key];
    }

    function deleteAddressValue(bytes32 _key) public onlyRepository {
        delete addressStorage[_key];
    }

    function deleteBytesValue(bytes32 _key) public onlyRepository {
        delete bytesStorage[_key];
    }

    function deleteBytes32Value(bytes32 _key) public onlyRepository {
        delete bytes32Storage[_key];
    }

    function deleteBooleanValue(bytes32 _key) public onlyRepository {
        delete booleanStorage[_key];
    }

    function deleteIntValue(bytes32 _key) public onlyRepository {
        delete intStorage[_key];
    }

}
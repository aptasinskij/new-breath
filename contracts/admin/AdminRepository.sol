pragma solidity 0.4.25;

import "./../common/Named.sol";
import "./../common/Mortal.sol";
import "./../common/Database.sol";

contract AdminDatabase is Database {
    
}

library AdminPersistence {
    
    ///ERROR_MESSAGES
    string constant NOT_EXISTS = "AdminPersistence: not exists";
    string constant ALREADY_EXISTS = "AdminPersistence: already exists";

    ///HASH_FIELDS
    string constant INDEX_VALUE = "admin.index";
    bytes32 constant INDEX = keccak256(abi.encode(INDEX_VALUE));

    struct Admin {
        uint index;
    }

    function getAdminsCount(AdminDatabase self) internal view returns (uint) {
        return self.getUintValue(INDEX);
    }

    function getAdminAtIndex(AdminDatabase self, uint index) internal view returns (address) {
        require(getAdminsCount(self) < index, NOT_EXISTS);
        return self.getAddressValue(keccak256(abi.encodePacked(INDEX_VALUE, index)));
    }
    
    function isAdmin(AdminDatabase self, address admin) internal view returns (bool) {
        require(admin != address(0), NOT_EXISTS);
        if (self.getUintValue(INDEX) == 0) return false;
        uint index = self.getUintValue(keccak256(abi.encodePacked(INDEX_VALUE, admin)));
        return self.getAddressValue(keccak256(abi.encodePacked(INDEX_VALUE, index))) == admin;
    }
    
    function insertAdmin(AdminDatabase self, address admin) internal returns (uint index) {
        require(!isAdmin(self, admin), ALREADY_EXISTS);
        index = self.getUintValue(INDEX);
        self.setUintValue(keccak256(abi.encodePacked(INDEX_VALUE, admin)), index);
        self.setAddressValue(keccak256(abi.encodePacked(INDEX_VALUE, index)), admin);
        self.setUintValue(INDEX, index + 1);
        return index;
    }

    function readAdmin(AdminDatabase self, address admin) internal view returns (uint index) {
        require(isAdmin(self, admin), NOT_EXISTS);
        index = self.getUintValue(keccak256(abi.encodePacked(INDEX_VALUE, admin)));
        return index;
    }
    
    function remove(AdminDatabase self, address admin) internal returns (uint) {
        require(isAdmin(self, admin), NOT_EXISTS);
        uint rowToDelete = self.getUintValue(keccak256(abi.encodePacked(INDEX_VALUE, admin)));
        uint index = self.getUintValue(INDEX) - 1;
        address keyToMove = self.getAddressValue(keccak256(abi.encodePacked(INDEX_VALUE, index)));
        self.setAddressValue(keccak256(abi.encodePacked(INDEX_VALUE, rowToDelete)), keyToMove);
        self.setUintValue(keccak256(abi.encodePacked(INDEX_VALUE, keyToMove)), rowToDelete);
        self.setUintValue(INDEX, index);
        return rowToDelete;
    }
    
}

contract IAdminRepository {
    
    function isAdmin(address account) public view returns (bool);

    function insertAdmin(address account) public;

    function renounceAdmin() public;

    function renounceAdminFrom(address account) public;

}

contract AdminRepository is IAdminRepository, Mortal, Named("admin-repository") {
    
    using AdminPersistence for AdminDatabase;

    AdminDatabase private _adminDatabase;

    modifier onlyAdmin {
        require(isAdmin(msg.sender), "Admin: only admin allowed");
        _;
    }

    constructor (address adminDatabase) public {
        require(adminDatabase != address(0), "Empty address not allowed");
        _adminDatabase = AdminDatabase(adminDatabase);
    }

    function initialize() public onlyOwner {
        _insertAdmin(msg.sender);
    }

    function adminDatabase() public view returns (address) {
        return address(_adminDatabase);
    }

    function isAdmin(address account) public view returns (bool) {
        return _adminDatabase.isAdmin(account);
    }

    function insertAdmin(address account) public onlyAdmin {
        _insertAdmin(account);
    }

    function renounceAdmin() public {
        _renounceAdminFrom(msg.sender);
    }

    function renounceAdminFrom(address account) public onlyOwner {
        _renounceAdminFrom(account);
    }

    function _renounceAdminFrom(address account) private {
        _adminDatabase.remove(account);
    }

    function _insertAdmin(address account) private {
        _adminDatabase.insertAdmin(account);
    }

}
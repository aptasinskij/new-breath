pragma solidity 0.4.25;

import './../../common/SafeMath.sol';
import './../../common/Named.sol';
import './../../common/Mortal.sol';
import './../../common/Database.sol';
import './../../access/ControlledByAdmin.sol';

contract TokenDatabase is Database {

}

library TokenPersistence {
    
    string constant BALANCE = "token.balance";
    string constant TOTAL_SUPPLY_VALUE = "token.total-supply";
    string constant ALLOWANCE = "token.allowance";
    bytes32 constant TOTAL_SUPPLY = keccak256(abi.encode(TOTAL_SUPPLY_VALUE));

    using SafeMath for uint;

    function totalSupply(TokenDatabase self) internal view returns (uint) {
        return self.getUintValue(TOTAL_SUPPLY);
    }

    function balanceOf(TokenDatabase self, address owner) internal view returns (uint) {
        return self.getUintValue(keccak256(abi.encodePacked(BALANCE, owner)));
    }

    function allowance(TokenDatabase self, address owner, address spender) internal view returns (uint) {
        return self.getUintValue(keccak256(abi.encodePacked(ALLOWANCE, owner, spender)));
    }

    function transfer(TokenDatabase self, address to, uint value) internal returns (bool) {
        _transfer(self, msg.sender, to, value);
        return true;
    }

    function approve(TokenDatabase self, address spender, uint value) internal returns (bool) {
        _approve(self, msg.sender, spender, value);
        return true;
    }

    function transferFrom(TokenDatabase self, address from, address to, uint value) internal returns (bool) {
        _transfer(self, from, to, value);
        uint senderAllowanceBefore = self.getUintValue(keccak256(abi.encodePacked(ALLOWANCE, from, msg.sender)));
        _approve(self, from, msg.sender, senderAllowanceBefore.sub(value));
    }

    function increaseAllowance(TokenDatabase self, address spender, uint addedValue) internal returns (bool) {
        uint spenderAllowedBefore = self.getUintValue(keccak256(abi.encodePacked(ALLOWANCE, msg.sender, spender)));
        _approve(self, msg.sender, spender, spenderAllowedBefore.add(addedValue));
        return true;
    }

    function decreaseAllowance(TokenDatabase self, address spender, uint subtractedValue) internal returns (bool) {
        uint spenderAllowedBefore = self.getUintValue(keccak256(abi.encodePacked(ALLOWANCE, msg.sender, spender)));
        _approve(self, msg.sender, spender, spenderAllowedBefore.sub(subtractedValue));
        return true;
    }

    function mint(TokenDatabase self, address to, uint value) internal returns (bool) {
        _mint(self, to, value);
        return true;
    }

    function burn(TokenDatabase self, uint value) internal {
        _burn(self, msg.sender, value);
    }

    function burnFrom(TokenDatabase self, address from, uint value) internal {
        _burnFrom(self, from, value);
    }

    function _transfer(TokenDatabase self, address from, address to, uint value) private {
        require(to != address(0), "TokenService: transfer to the zero address");
        require(from != address(0), "TokenService: transfer from the zero address");
        uint fromBeforeBalance = self.getUintValue(keccak256(abi.encodePacked(BALANCE, from)));
        self.setUintValue(keccak256(abi.encodePacked(BALANCE, from)), fromBeforeBalance.sub(value));
        uint toBeforeBalance = self.getUintValue(keccak256(abi.encodePacked(BALANCE, to)));
        self.setUintValue(keccak256(abi.encodePacked(BALANCE, to)), toBeforeBalance.add(value));
    }

    function _mint(TokenDatabase self, address account, uint value) private {
        require(account != address(0), "TokenService: transfer to the zero address");
        self.setUintValue(TOTAL_SUPPLY, totalSupply(self).add(value));
        uint accauntBalanceBefore = self.getUintValue(keccak256(abi.encodePacked(BALANCE, account)));
        self.setUintValue(keccak256(abi.encodePacked(BALANCE, account)), accauntBalanceBefore.add(value));
    }

    function _burn(TokenDatabase self, address account, uint value) private {
        require(account != address(0), "TokenService: burn from the zero account");
        self.setUintValue(TOTAL_SUPPLY, totalSupply(self).sub(value));
        uint accauntBalanceBefore = self.getUintValue(keccak256(abi.encodePacked(BALANCE, account)));
        self.setUintValue(keccak256(abi.encodePacked(BALANCE, account)), accauntBalanceBefore.sub(value));
    }

    function _approve(TokenDatabase self, address owner, address spender, uint value) private {
        require(owner != address(0), "TokenService: approve from the zero account");
        require(spender != address(0), "TokenService: approve to the zero account");
        self.setUintValue(keccak256(abi.encodePacked(ALLOWANCE, owner, spender)), value);
    }

    function _burnFrom(TokenDatabase self, address account, uint value) private {
        _burn(self, account, value);
        uint spenderAllowedBefore = self.getUintValue(keccak256(abi.encodePacked(ALLOWANCE, account, msg.sender)));
        _approve(self, account, msg.sender, spenderAllowedBefore.sub(value));
    }

}

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);

    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);

    function mint(address to, uint256 value) external returns (bool);

    function burn(uint256 value) external;

    function burnFrom(address from, uint256 value) external;

}

contract TokenService is IERC20, Mortal, Named("token-service"), ControlledByAdmin {
    
    using TokenPersistence for TokenDatabase;

    TokenDatabase private _tokenDatabase;

    constructor (IContext context, address tokenDatabase) ControlledByAdmin(context) public {
        require(tokenDatabase != address(0), "TokenService: database must be not the zero address");
        _tokenDatabase = TokenDatabase(tokenDatabase);
    }

    function totalSupply() public view returns (uint256) {
        return _tokenDatabase.totalSupply();
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _tokenDatabase.balanceOf(owner);
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _tokenDatabase.allowance(owner, spender);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        return _tokenDatabase.transfer(to, value);
    }

    function approve(address spender, uint256 value) public returns (bool) {
        return _tokenDatabase.approve(spender, value);
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        return _tokenDatabase.transferFrom(from, to, value);
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        return _tokenDatabase.increaseAllowance(spender, addedValue);
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        return _tokenDatabase.decreaseAllowance(spender, subtractedValue);
    }

    function mint(address to, uint256 value) public onlyAdmin returns (bool) {
        return _tokenDatabase.mint(to, value);
    }

    function burn(uint256 value) public {
        _tokenDatabase.burn(value);
    }

    function burnFrom(address from, uint256 value) public {
        _tokenDatabase.burnFrom(from, value);
    }

}
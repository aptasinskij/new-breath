pragma solidity 0.4.25;

import {IAdminRepository} from './../admin/AdminRepository.sol';
import {IContext} from './../common/Context.sol';

contract ControlledByAdmin {

    string constant ADMIN_REPOSITORY = 'admin-repository';

    IContext private _context;

    modifier onlyAdmin {
        require(
            IAdminRepository(_context.get(ADMIN_REPOSITORY)).isAdmin(msg.sender), 
            'Access: only admin allowed'
        );
        _;
    }

    constructor (IContext context) internal {
        require(context != address(0), 'context can not be address(0)');
        _context = context;
    }

}
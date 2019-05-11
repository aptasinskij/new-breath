pragma solidity 0.4.25;

import {IAdminRepository} from './../admin/AdminRepository.sol';
import {IContext, ContextDependent} from './../common/Context.sol';

contract ControlledByAdmin is ContextDependent {

    string constant ADMIN_REPOSITORY = 'admin-repository';

    modifier onlyAdmin {
        require(
            IAdminRepository(_context.get(ADMIN_REPOSITORY)).isAdmin(msg.sender), 
            'Access: only admin allowed'
        );
        _;
    }

    constructor (IContext context) ContextDependent(context) internal { }

}
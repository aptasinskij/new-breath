const Context = artifacts.require('Context');
const AdminDatabase = artifacts.require('AdminDatabase');
const AdminRepository = artifacts.require('AdminRepository');

module.exports = function (deployer) {
  deployer.deploy(AdminDatabase).then(() => {
    return deployer.deploy(AdminRepository, AdminDatabase.address);
  }).then(() => {
    return AdminDatabase.deployed();
  }).then(adminDatabase => {
    return adminDatabase.setRepository(AdminRepository.address);
  }).then(() => {
    return Context.deployed();
  }).then(context => {
    context.register(AdminRepository.address);
  });
};

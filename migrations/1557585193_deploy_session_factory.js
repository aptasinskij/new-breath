const SessionFactory = artifacts.require('SessionFactory');

module.exports = function(deployer) {
  deployer.deploy(SessionFactory);
};

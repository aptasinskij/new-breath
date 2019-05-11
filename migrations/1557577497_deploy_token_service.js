const Context = artifacts.require('Context');
const TokenDatabase = artifacts.require('TokenDatabase');
const TokenService = artifacts.require('TokenService');

module.exports = function(deployer) {
  deployer.deploy(TokenDatabase).then(() => {
    return deployer.deploy(TokenService, Context.address, TokenDatabase.address);
  }).then(() => {
    return TokenDatabase.deployed();
  }).then(tokenDatabase => {
    return tokenDatabase.setRepository(TokenService.address);
  }).then(() => {
    return Context.deployed();
  }).then(context => {
    return context.register(TokenService.address);
  })
};

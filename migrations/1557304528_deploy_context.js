const ContextDatabase = artifacts.require('ContextDatabase');
const Context = artifacts.require('Context');

module.exports = function(deployer) {
  let contextDatabaseDeployed;
  deployer.deploy(ContextDatabase).then(contextDatabase => {
    contextDatabaseDeployed = contextDatabase;
    return deployer.deploy(Context, contextDatabase.address);
  }).then(contextDeployed => {
    return contextDatabaseDeployed.setRepository(contextDeployed.address);
  })
};

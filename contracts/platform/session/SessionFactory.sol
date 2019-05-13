
pragma solidity 0.4.25;

contract SessionFactory {

    event SessionCreated(address session);

    function createSession(string memory xToken) public returns (address) {
        address session = address(new Session(xToken));
        emit SessionCreated(session);
        return session;
    }

}
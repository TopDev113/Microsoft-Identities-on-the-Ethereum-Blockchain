pragma solidity ^0.4.24;

import "contracts/IdentityInterface.sol";

contract IdentityStore is IdentityInterface {
  
    struct User {
        bytes32 tenantHash;
        uint256 timestamp;
        string tenantId;
    }

    mapping(address => User) private tenantAddressMapping;
    mapping(bytes32 => address) private tenantHashMapping; 

    function setTenant(
        bytes32 _tenantHash,
        address _userAddress,
        uint256 _timestamp,
        string _tenantId) onlyOwner public {

        // Completely new user
        if (!userAddressExists(_userAddress) && !userTenantHashExists(_tenantHash)) {
            
            User memory newUser = User(_tenantHash, _timestamp, _tenantId);
            tenantAddressMapping[_userAddress] = newUser;
            tenantHashMapping[_tenantHash] = _userAddress;
            return;
        }

        // Update user hash.
        if (userAddressExists(_userAddress) && !userTenantHashExists(_tenantHash)) {
            
            bytes32 oldHash = tenantAddressMapping[_userAddress].tenantHash;
            updateHash(oldHash, _tenantHash, _timestamp);
            return;
        }
        
        // Update user address.
        if (userTenantHashExists(_tenantHash) && !userAddressExists(_userAddress)) {
            address oldAddress = tenantHashMapping[_tenantHash];
            updateAddress(oldAddress, _userAddress);
            return;
        }
        
        // Update timestamp
        if (userTenantHashExists(_tenantHash) && userAddressExists(_userAddress)) {
            updateTimestamp(_tenantHash, _timestamp);
            return;
        }
    }

    function isValid(
        string _tenantId, 
        address _userAddress,
        uint256 _minTimestamp) view public returns(bool) {

        // check valid address
        if(!userAddressExists(_userAddress)) {
            return false;
        }

        User memory currentUser = tenantAddressMapping[_userAddress];

        // check valid tenant id
        if(keccak256(currentUser.tenantId) != keccak256(_tenantId)) {
            return false;
        }
        
        // check minimum timestamp
        if(currentUser.timestamp < _minTimestamp) {
            return false;
        }

        return true;
    }

    function isValid(address _userAddress, uint256 _minTimestamp) view public returns(bool) {

        // check valid address
        if(!userAddressExists(_userAddress)) {
            return false;
        }

        User memory currentUser = tenantAddressMapping[_userAddress];

        // check minimum timestamp
        if(currentUser.timestamp < _minTimestamp) {
            return false;
        }

        return true;
    }

    function updateHash(
        bytes32 _oldHash, 
        bytes32 _newHash, 
        uint256 _timestamp) internal {

        require(userTenantHashExists(_oldHash), "Old hash does not exist.");
        require(!userTenantHashExists(_newHash), "New hash is already registered.");
        address currentAddress = tenantHashMapping[_oldHash];
        User memory oldUserInfo = tenantAddressMapping[currentAddress];
        User memory newUserInfo = User(_newHash, _timestamp, oldUserInfo.tenantId);

        // update address mapping to user
        tenantAddressMapping[currentAddress] = newUserInfo;

        // delete old hash mapping to address
        delete tenantHashMapping[_oldHash];

        // add new hash mapping to address
        tenantHashMapping[_newHash] = currentAddress;
    }

    function updateAddress(address oldUserAddress, address newUserAddress) onlyOwner internal {
        User memory existingUser = tenantAddressMapping[oldUserAddress];
        
        require(!userAddressExists(newUserAddress), "There's already an account tied to this address");
        require(userAddressExists(oldUserAddress), "There's no account tied to the address origin");

        tenantHashMapping[existingUser.tenantHash] = newUserAddress;
        tenantAddressMapping[newUserAddress] = existingUser;
        delete tenantAddressMapping[oldUserAddress];
    }

    function updateTimestamp(bytes32 _tenantHash, uint256 _timestamp) onlyOwner internal {
        tenantAddressMapping[tenantHashMapping[_tenantHash]].timestamp = _timestamp;
    }

    function userAddressExists(address userAddress) view internal returns(bool) {       
        if(tenantAddressMapping[userAddress].tenantHash == 0) {
            return false;
        }
        return true;
    }

    function userTenantHashExists(bytes32 tenantHash) view internal returns(bool){
        // pray it be who can find the 0X Address
        if(tenantHashMapping[tenantHash] == 0) {
            return false;
        }
        return true;
    }
}
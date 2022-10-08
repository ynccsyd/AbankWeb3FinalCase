// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract EnergyTrading {

    address SmartUser;

    mapping(address => bool) whitelistedAddresses;
    mapping(address => uint) public EnergyQuantity;
    

    constructor()  {
        SmartUser = msg.sender;
        EnergyQuantity[address(this)] = 1000;
    }

    struct UserType {
        string Username;
        uint ProducedEnergy;
        uint ConsumedEnergy;
        address payable Prosumer;
        address payable Consumer;
    }
    
    UserType[] public users;

    modifier onlyOwner() {
      require(msg.sender == SmartUser, "Ownable: caller is not the owner");
      _;
    }

    modifier isWhitelisted(address _address) {
      require(whitelistedAddresses[_address], " You need to be whitelisted");
      _;
    }


    function AddSmartUser( address _addressToWhitelist) public onlyOwner {
      whitelistedAddresses[_addressToWhitelist] = true;
    }

    function verifyUser(address _whitelistedAddress) public view returns(bool) {
      bool userIsWhitelisted = whitelistedAddresses[_whitelistedAddress];
      return userIsWhitelisted;
    }
    
    function AddProducedEnergy(uint amount) public {
        require(msg.sender == SmartUser, "Only the USERS can change.");
        EnergyQuantity[address(this)] += amount;
    }
     function Purchase(uint amount) public payable {
        require(msg.value >= amount * 1 ether, "Pay 1 eth");
        require(EnergyQuantity[address(this)] >= amount, "Not enough to trade");
        EnergyQuantity[address(this)] -= amount;
        EnergyQuantity[msg.sender] += amount;
    }
    function ShowEnergyQuantity() public view returns (uint) {
        return EnergyQuantity[address(this)];
    }
    

}
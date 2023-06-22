// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./Brta.sol";

contract ELicense{
    struct User{
        string name;
        string licenseNumber;
        string dateOfBirth;
        bool validity;
        string issueingAuthority;
        uint256 grade;
    }

    mapping(string=>User) users;
    BrtaAuthority public brtaContractAddress;

    constructor(address _brtaContractAddress){
        brtaContractAddress=BrtaAuthority(_brtaContractAddress);
    }


    modifier Brta(){
        BrtaAuthority.Brta memory brta=brtaContractAddress.getBrtaOffice(msg.sender);
        require(brta.brtaKey!=address(0),"Only BRTA authority can access");
        _;
    }

    function addLicense(string memory _name, string memory _licenseNumber, string memory _dateOfBirth) external payable Brta{
        BrtaAuthority.Brta memory brta=brtaContractAddress.getBrtaOffice(msg.sender);
        require(bytes(users[_licenseNumber].licenseNumber).length == 0, "User already exists");

        users[_licenseNumber]=User(
            _name,
            _licenseNumber,
            _dateOfBirth,
            true,
            brta.areaName,
            1
        );
    }

    function upgradeLicense(string memory _licenseNumber) external payable Brta{
        require(bytes(users[_licenseNumber].licenseNumber).length != 0, "User already exists");
        users[_licenseNumber].grade=users[_licenseNumber].grade+1;
    }

    function freezeLicense(string memory _licenseNumber) external payable Brta{
        require(bytes(users[_licenseNumber].licenseNumber).length != 0, "User already exists");
        users[_licenseNumber].validity=false;
    }

    function getELicense(string memory _licenseNumber) public view returns(User memory){
        return users[_licenseNumber];
    }

    


}
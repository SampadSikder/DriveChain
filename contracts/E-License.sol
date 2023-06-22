// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "./Brta.sol";

contract ELicense {
    struct User {
        string name;
        string licenseNumber;
        string dateOfBirth;
        bool validity;
        string issueingAuthority;
        uint256 grade;
        address licenseAddress;
    }

    mapping(address => User) users;
    BrtaAuthority public brtaContractAddress;

    constructor(address _brtaContractAddress) {
        brtaContractAddress = BrtaAuthority(_brtaContractAddress);
    }

    modifier Brta() {
        BrtaAuthority.Brta memory brta = brtaContractAddress.getBrtaOffice(
            msg.sender
        );
        require(brta.brtaKey != address(0), "Only BRTA authority can access");
        _;
    }

    function addLicense(
        string memory _name,
        string memory _licenseNumber,
        string memory _dateOfBirth,
        address _licenseAddress
    ) external payable Brta {
        BrtaAuthority.Brta memory brta = brtaContractAddress.getBrtaOffice(
            msg.sender
        );
        require(
            bytes(users[_licenseAddress].licenseNumber).length == 0,
            "User already exists"
        );

        users[_licenseAddress] = User(
            _name,
            _licenseNumber,
            _dateOfBirth,
            true,
            brta.areaName,
            1,
            _licenseAddress
        );
    }

    function upgradeLicense(address _licenseAddress) external payable Brta {
        require(
            bytes(users[_licenseAddress].licenseNumber).length != 0,
            "User already exists"
        );
        users[_licenseAddress].grade = users[_licenseAddress].grade + 1;
    }

    function freezeLicense(address _licenseAddress) external payable Brta {
        require(
            bytes(users[_licenseAddress].licenseNumber).length != 0,
            "User already exists"
        );
        users[_licenseAddress].validity = false;
    }

    function unfreezeLicense(address _licenseAddress) external payable Brta {
        require(
            bytes(users[_licenseAddress].licenseNumber).length != 0,
            "User already exists"
        );
        users[_licenseAddress].validity = true;
    }

    function getELicense() public view returns (User memory) {
        return users[msg.sender];
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract SmartEstate is ERC721URIStorage {
    address owner;
    using Counters for Counters.Counter;
    Counters.Counter private rentIds;

    struct Payment {
        uint256 rentId;
        uint256 amount;
        uint256 date;
    }

    struct RentAggrement {
        uint256 plotId;
        uint256 renterId;
        uint256 startDate;
        uint256 endDate;
        uint256 rentAmount;
        string description;
        string cid;
    }

    struct User {
        uint256 userId;
        address userAdd;
        string name;
        string mobileNo;
        string aadhaar;
        string aadhaarCID;
    }

    struct Plot {
        uint256 id;
        uint256 creatorId;
        string name;
        string realAdd;
        string xCor;
        string yCor;
        uint256 totalQuantity;
        uint256 availableStocks;
        uint256 price;
        bool rented;
        uint256 rentAmount;
    }

    struct Transaction {
        uint256 source;
        uint256 target;
        uint256 quantity;
        uint256 price;
        uint256 timestamp;
        uint256 plotId;
        int8 state; // 0:PENDING / 1:VALIDATED / 2:REJECTED
    }

    struct Stocks {
        address holderAddress;
        uint256 stockId;
        uint256 userId;
        uint256 plotId;
        uint256 quantity;
        uint256 sellable;
        uint256 price;
    }

    uint256 transactionCount;
    uint256 plotCount;
    uint256 plotRequestCount;
    uint256 userCount;
    uint256 userRequestCount;
    uint256 stockCount;
    uint256 paymentCount;

    mapping(uint256 => RentAggrement) rentAggrements;
    mapping(uint256 => Payment) private payments;

    mapping(uint256 => User) users;
    mapping(uint256 => User) userRequests;
    mapping(uint256 => Transaction) transactions;
    mapping(uint256 => Plot) plots;
    mapping(uint256 => Plot) plotRequests;
    mapping(uint256 => Stocks) stocks;
    mapping(address => User) addressToUserMapping;

    mapping(address => uint256) userAddressToIdMapping;

    constructor() ERC721("fdjkls", "jlks") {
        owner = msg.sender;
    }

    function isOwner() public view returns (bool) {
        return owner == msg.sender;
    }

    function checkAvailableStocksForSeller(
        uint256 stockId,
        uint256 sellable
    ) public view returns (bool) {
        if (stocks[stockId].sellable + sellable <= stocks[stockId].quantity)
            return true;
        else return false;
    }

    function checkAvailableStocksForBuyer(
        uint256 stockId,
        uint256 buyable
    ) public view returns (bool) {
        if (stocks[stockId].sellable - buyable >= 0) return true;
        else return false;
    }

    function compareStrings(
        string memory _string1,
        string memory _string2
    ) public pure returns (bool) {
        return (keccak256(abi.encodePacked((_string1))) ==
            keccak256(abi.encodePacked((_string2))));
    }

    function registerUser(
        address userAdd,
        string memory name,
        string memory mobileNo,
        string memory aadhaar,
        string memory aadhaarCID
    ) public {
        userRequests[userRequestCount] = User({
            userId: userRequestCount,
            userAdd: userAdd,
            name: name,
            mobileNo: mobileNo,
            aadhaar: aadhaar,
            aadhaarCID: aadhaarCID
        });
        addressToUserMapping[userAdd] = userRequests[userRequestCount];
        userRequestCount += 1;
        verifyUser(userAdd);
    }

    // FETCH USER FUCNTIONS

    function fetchUserByAddress(
        address addr
    ) public view returns (User memory) {
        // for (uint256 i = 0; i < userCount; i++) {
        //     if (users[i].userAdd == addr) {
        //         return users[i];
        //     }
        // }
        return addressToUserMapping[addr];
        // revert();
    }

    function fetchUserById(uint256 id) public view returns (User memory) {
        for (uint256 i = 0; i < userCount; i++) {
            if (users[i].userId == id) {
                return users[i];
            }
        }
        revert();
    }

    function fetchAllUsers() public view returns (User[] memory) {
        User[] memory userList = new User[](userCount);

        for (uint256 i = 0; i < userCount; i++) {
            User storage tempUser = users[i];
            userList[i] = tempUser;
        }

        return userList;
    }

    
}

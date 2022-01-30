//defend code against denial of service attack with push vs pull mechanism
//instead of pushing ether require caller to pull their eth
// dont make a function that changes sth depends on call function
//separate functions
//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
contract victim{
    address public king;
    uint public balanceOfContract;
    mapping(address => uint) public balancesOfKings;

    constructor() payable{
        king = msg.sender;
        balanceOfContract = msg.value;
        balancesOfKings[msg.sender] = msg.value;
    }
    function changeKing() public payable{
        require(msg.value > balanceOfContract, "money is not enought to change");
        balancesOfKings[king] = balanceOfContract;
        balanceOfContract = msg.value;
        king = msg.sender;
    } 
    function withdraw() public{
        require(msg.sender != king && balancesOfKings[msg.sender] >0, "current king cannot withdraw or balance is not enough");
        uint amount = balancesOfKings[msg.sender];
        balancesOfKings[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "withdraw is failed");
    }
    function getBalance() public view returns(uint){
        return balanceOfContract;
    }
}

contract attacker{
    
    function attack(victim v) public payable{
        v.changeKing{value: msg.value}();
    }
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}
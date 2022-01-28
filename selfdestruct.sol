//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Victim{
    string str = "hello world";

    function start() public view returns (string memory){
        return str;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}

contract Attacker{

    fallback() external payable{

    }
    receive() external payable{

    }

    function attack(Victim victim) public {
        address payable adrs = payable(address(victim));
        selfdestruct(adrs);
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

}
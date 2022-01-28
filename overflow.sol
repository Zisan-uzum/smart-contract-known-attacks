//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract victim{

    event Deposited(address _from, uint _amount, string result);
    event Withdrawed(address _from, uint _amount, string result);

    mapping(address => uint) public balances;
    mapping(address => uint) public time; // now keyword keeps block.timestamp with seconds

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        time[msg.sender] = block.timestamp + 2 weeks;
        emit Deposited(msg.sender, msg.value, "deposit action successful");
    }
    function withdraw(uint _amount) public payable{
        require(balances[msg.sender] >= _amount, "balance is not enough");
        require(block.timestamp >= time[msg.sender], "lock is not opened");
        balances[msg.sender] -= _amount;
        (bool success, )= msg.sender.call{value: _amount}("");
        require(success, "withdraw failed");
        emit Withdrawed(msg.sender, _amount, "withdraw successful");
    }
    function getBalance() public view returns (uint){
        return balances[msg.sender];
    }
    function increase_time(uint _second) public{
        time[msg.sender] += _second;
    }
}
contract attacker{

    victim public Victim;
    
    constructor(address payable _victim_address){
        Victim = victim(_victim_address);
    }
    fallback() external payable{

    }
    receive() external payable{
        
    }
   /* function deposit(uint _amount) public payable{
      (bool success, ) = msg.sender.call{value: _amount}("");
      require(success, "deposited to contract");
    }*/
    function attack() public payable{
        Victim.deposit{value : msg.value}();
        // 2**256 - t = x
       // Victim.increase_time(type(uint).max + 1 - Victim.time(address(this)));
        Victim.withdraw(1 ether); 
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}
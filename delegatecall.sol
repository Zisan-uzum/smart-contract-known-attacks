// there should be same state variables and state vaiables of contract will change in delegated call 

//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

contract called{
    address public adrs;
    uint public value;
    uint public number;

    function change_variables(uint _num) external payable{
        adrs = msg.sender;
        value = msg.value;
        number = _num;
    } 

}
contract caller{

    address public adrs;
    uint public value;
    uint public number;

    function change_variable(called c, uint _num) external payable{
       (bool success, ) = address(c).delegatecall(abi.encodeWithSignature("change_variables(uint256)", _num));
       if(!success){
           revert("failed");
       }
    }
}

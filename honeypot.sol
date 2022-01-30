//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
contract Foo {
    Bar bar;

    constructor(address _adrs) {
        bar = Bar(_adrs); // we can call any contract including malcious code by giving address.
        //bar = new Bar(); if we initialize new contract inside it will be prevented
    }

    function callBar() public {
        bar.log();
    }
}

contract Bar {
    event Log(string message);

    function log() public {
        emit Log("Bar was called");
    }
}

contract Malicious{ // it will be hided
    event Log(string message);

    function log() public {
        emit Log("Mal was called");
    }
}

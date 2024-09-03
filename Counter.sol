// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Counter {
    int public count = 0;

    function increment() public {
        count++;
    }

    function decrement() public {
        count--;
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract kidsFund{
    address owner;

    mapping(address => uint) public balanceOf;
    struct Kid {
        address walletAddress;
        string name;
        uint timestamp;
        bool canWithdraw;
    }

    Kid[] kids;

    constructor(){
        owner = msg.sender;
    }

    function addKid(
        address walletAddress,
        string memory name,
        uint timestamp,
        bool canWithdraw
    ) public returns(bool){
        require(msg.sender == owner, "Only owner can add the kids");
        kids.push(Kid(
            walletAddress,
            name,
            timestamp,
            canWithdraw
        ));
        return true;
    }

    function matchAddress(address walletAddress)private view returns(uint index){
        for(uint i=0; i<kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                return i;
            }
        }
    }

    function getKid(address walletAddress) public view returns(Kid memory){

        uint index = matchAddress(walletAddress);
        return kids[index];
        
    }

    function deposit()public payable returns(bool){
        require(msg.value>= 5 ether);
        return true;
    } 

    function transferToKid(address payable walletAddress, uint value) public returns(bool){
        require(address(this).balance>value,"Contract does'nt have enough balance");
        walletAddress.transfer(value);
        balanceOf[walletAddress]+=value;
        return true;
    }

    function contractBalance() public view returns(uint){
        return address(this).balance;
    }



    function canWithdrawfunds(address walletAddress) public view returns(bool){
        uint index = matchAddress(walletAddress);
        if(kids[index].timestamp<block.timestamp){
            kids[index].canWithdraw ==true;
            return true;
        }
        else return false;
    }

}

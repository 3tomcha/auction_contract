// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Auction {
    // static
    address public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;
    uint public bidIncrement;
    // state
    bool public canceled;
    address public highestBidder;
    mapping(address => uint256) public fundsByBidder;
    uint public highestBindingBid;
    bool ownerHaswWithdrawn;

    function placeBid() public returns (bool success) {}
    function withdraw() public returns (bool success){}
    function cancelAuction() public returns (bool success){}

    event LogBid(address bidder, uint bid, address highestBidder, uint highestBid, uint highestBindingBid);
    event LogWithdrawal(address withdrawer, address withdrawalAccount, uint amount);
    event LogCanceled();
}

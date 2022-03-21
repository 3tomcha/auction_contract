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

    function withdraw() public returns (bool success){}
    function cancelAuction() public returns (bool success){}

    event LogBid(address bidder, uint bid, address highestBidder, uint highestBid, uint highestBindingBid);
    event LogWithdrawal(address withdrawer, address withdrawalAccount, uint amount);
    event LogCanceled();


    constructor(address _owner, uint _bidIncrement, uint  _startBlock, uint _endBlock, string memory _ipfsHash){
        require(_startBlock >= _endBlock);
        require(_startBlock < block.number);

        owner = _owner;
        bidIncrement = _bidIncrement;
        startBlock = _startBlock;
        endBlock = _endBlock;
        ipfsHash = _ipfsHash;
    }

    function min(uint a, uint b) 
        private
        pure
        returns (uint) 
    {
        if (a < b) return a;
        return b;
    }

    function placeBid()
        payable
        onlyAfterStart 
        onlyBeforeEnd
        onlyNotCanceled
        onlyNotOwner
        public returns (bool success)
    {
        require(msg.value != 0); 
        uint newBid = fundsByBidder[msg.sender] + msg.value;
        require(newBid > highestBindingBid);
        uint highestBid = fundsByBidder[highestBidder];

        if (newBid <= highestBid) {
            highestBindingBid = min(newBid + bidIncrement, highestBid);
        } else {
            if (msg.sender != highestBidder) {
                highestBidder = msg.sender;
                highestBindingBid = min(newBid, highestBid + bidIncrement);
            }
            highestBid = newBid;
        }

        emit LogBid(msg.sender, newBid, highestBidder, highestBid, highestBindingBid);
        return true;
    }

    modifier onlyOwner {
        require(
            msg.sender == owner,
            "msg.sender must be owner"
        );
        _;
    }

    modifier onlyNotOwner {
        require(
            msg.sender != owner, 
            "msg.sender must not be owner"
        );
        _;
    }

    modifier onlyAfterStart {
        require(
            block.number > startBlock,
            "start block number must be over current block number"
        );
        _;
    }

    modifier onlyBeforeEnd {
        require(
            block.number < endBlock,
            "end block number must be under current block number"
        );
        _;
    }

    modifier onlyNotCanceled {
        require(
            canceled != true,
            "must not be canceled"
        );
        _;
    }


}

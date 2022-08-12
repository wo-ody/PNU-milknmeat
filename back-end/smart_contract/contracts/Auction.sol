// SPDX-License-Identifier: MIT

pragma solidity >=0.5.16;

import "./OwnerData.sol";
import "./SupplyManaging.sol";

contract AuctionContract{

    OwnerDataContract ownerDataContract;

    SupplyManagingContract supplyManagingContract;

    constructor(address _ownerDataContract, address _supplyManagingContract) {
        ownerDataContract = OwnerDataContract(_ownerDataContract);
        supplyManagingContract = SupplyManagingContract(_supplyManagingContract);
    }

    Auction[] public auctions;

    mapping(uint256 => Bid[] ) public auctionBids;
    mapping(address => uint[]) public auctionOwner;
    mapping(uint256 => bool  ) public itemActive;
            
    struct Bid{
        address payable from;
        uint256 amount;
        string shippingTo;
    }

    struct Auction{
        string name;
        uint256 startTime;
        uint256 blockDeadline;
        uint256 startPrice;
        bool active;
        bool finalized;
        uint256 itemId;
        string shippingFrom; 
        string shippingTo;  
    }

    event AlreadyActive(address _user, uint256 _itemId);
    event EarlyToFinalize(address _user, uint256 timeStamp, uint256  blockDeadline);
    event CancelAuction(address _user, uint256 _auctionId);
    event ItemAlreadyActive(address _user, uint256 _itemId);
    event DeadlineExceeded(address _user, uint256 _auctionId, uint256 _timestamp, uint256 _deadline);
    event AuctionFinalized(address _user, uint256 _auctionId);
    event sendFailed(address _user, uint256 _amount, uint256 _auctionId);


    modifier isOwnerAuc(uint _auctionId) {
        address owner = ownerDataContract.getOwnerByAucId(_auctionId);
        require(owner == msg.sender);
        _;
    }

    function getAllOfAuctions() public view returns(Auction[] memory){
        return auctions;
    }

    function getItemByAuction(uint256 _auctionId) public view returns(uint256){
        return auctions[_auctionId].itemId;
    }

    function getBidsCount(uint _auctionId) public view returns(uint){
        return auctionBids[_auctionId].length;
    }

    function getAuctionsOfOwner(address _owner) public view returns(uint[] memory){
        uint[] memory ownedAuctions = auctionOwner[_owner];
        return ownedAuctions;
    }

    
    function getCurrentBid(uint _auctionId) public view returns(uint256, address, string memory) {
        uint bidsLength =auctionBids[_auctionId].length;

        if(bidsLength > 0){
            Bid memory lastBid = auctionBids[_auctionId][bidsLength - 1];
            return (lastBid.amount, lastBid.from, lastBid.shippingTo);
        }

        return (uint256(0), address(0), string(""));
    }

    function getAuctionOwnerLength(address _owner) public view returns(uint) {
        return auctionOwner[_owner].length;
    }

    function getAuctionById(uint _auctionId) public view returns(
        string memory name,
        uint256 startTime,
        uint256 blockDeadline,
        uint256 startPrice,
        address payable owner,
        bool active,
        bool finalized,
        uint256 itemId,
        string memory shippingFrom,
        string memory shippingTo
    ){
        Auction memory auc = auctions[_auctionId];
        address _owner = ownerDataContract.getOwnerByAucId(_auctionId);
        return (
            auc.name,
            auc.startTime,
            auc.blockDeadline,
            auc.startPrice,
            payable(_owner),
            auc.active,
            auc.finalized,
            auc.itemId,
            auc.shippingFrom,
            auc.shippingTo
        );
    }

    function getAuctionNameByAuctionId(uint256 _auctionId) public view returns(string memory){
        return auctions[_auctionId].name;
    }

    function createAuction(string memory _auctionTitle, uint256 _startPrice, uint256 _itemId, 
       uint256 _startTime,  uint256 _blockDeadline, string memory _shippingFrom) public {

        
        uint256 auctionId = auctions.length;

        Auction memory newAuction;

        if(itemActive[_itemId] == true){
            emit AlreadyActive(msg.sender, _itemId);
            revert();
        }

        newAuction.name = _auctionTitle;
        newAuction.startTime = _startTime;
        newAuction.blockDeadline = _blockDeadline;
        newAuction.startPrice = _startPrice;
        newAuction.active = true;
        newAuction.finalized = false;
        newAuction.itemId = _itemId;
        newAuction.shippingFrom = _shippingFrom;
        newAuction.shippingTo = "none";

        auctions.push(newAuction);
        ownerDataContract.updateAuctionOwner(msg.sender, auctionId);
        itemActive[_itemId] = true;
        //ownerDataContract.updateItemOwner(msg.sender, _itemId);
        //ownerData.pushOwnedBy(msg.sender, _itemId);
    }

    //function restartAuction(uint256 _auctionId, )

    function cancelAuction(uint _auctionId) public isOwnerAuc(_auctionId){
        uint bidsLength = auctionBids[_auctionId].length;

        if(bidsLength > 0){
            Bid memory lastBid = auctionBids[_auctionId][bidsLength -1];
            if(!lastBid.from.send(lastBid.amount)){
                emit sendFailed(msg.sender, lastBid.amount, _auctionId);
                revert();
            }
        }

        emit CancelAuction(msg.sender, _auctionId);
    }

    function finalizeAuction(uint256 _auctionId) public returns(uint256){
        Auction memory myAuction = auctions[_auctionId];
        uint256 _itemId = myAuction.itemId;
        uint256 bidsLength = auctionBids[_auctionId].length;
        uint256 timeStamp = block.timestamp;
        address payable aucOwner = ownerDataContract.getOwnerByAucId(_auctionId);
        

        if(timeStamp < myAuction.blockDeadline){
            emit EarlyToFinalize(msg.sender, timeStamp, myAuction.blockDeadline);
            revert();
        }
        
        if(bidsLength == 0) {
            cancelAuction(_auctionId);
        }else{

            Bid memory lastBid = auctionBids[_auctionId][bidsLength - 1];

            if(!aucOwner.send(lastBid.amount)){
                emit sendFailed(msg.sender, lastBid.amount, _auctionId);
                revert();
            }
            else{
                ownerDataContract.handoverOwnerData(aucOwner, lastBid.from, _itemId, _auctionId);
                supplyManagingContract.setAddrToShippingByItemId(_itemId, aucOwner, lastBid.from, myAuction.shippingFrom, lastBid.shippingTo);
                myAuction.shippingTo = lastBid.shippingTo;
                auctions[_auctionId].finalized = true;
                emit AuctionFinalized(msg.sender, _auctionId);
            }
        }

        auctions[_auctionId].active = false;
        itemActive[_itemId] = false;        
        return 0;
    }


    function bidOnAuction(uint _auctionId, string memory _to) external payable {
        uint256 timestamp = block.timestamp;

        uint256 ethAmountSent = msg.value;
        address aucOwner = ownerDataContract.getOwnerByAucId(_auctionId);
        Auction memory myAuction = auctions[_auctionId];
        uint256 startTime = myAuction.startTime;
        uint256 deadline = myAuction.blockDeadline;

        if(aucOwner == msg.sender){
            revert();
        }

        if( (timestamp > deadline) || (timestamp < startTime) ){
            emit DeadlineExceeded(msg.sender, _auctionId, timestamp, deadline);
            revert();
        }
        
        uint256 bidsLength = auctionBids[_auctionId].length;
        uint256 tempAmount = myAuction.startPrice;
        Bid memory lastBid;
        
        if(ethAmountSent < tempAmount){
            revert();
        }

        if(bidsLength > 0){
            lastBid = auctionBids[_auctionId][bidsLength -1];
            tempAmount = lastBid.amount;

            if(ethAmountSent < tempAmount){
                revert();
            }

            require(lastBid.from.send(lastBid.amount), "failed to refund.");
        }
        
        Bid memory newBid;
        newBid.from = payable(msg.sender);
        newBid.amount = ethAmountSent;
        newBid.shippingTo = _to;
        auctionBids[_auctionId].push(newBid);
    }

    function getActiveByAuctionId(uint256 _auctionId) public view returns(bool){
        return auctions[_auctionId].active;
    }

    function getActiveByItemId(uint256 _itemId) public view returns(bool){
        return itemActive[_itemId];
    }

    function getWinningPrice(uint256 _auctionId) public view returns(uint256){
        uint256 len = auctionBids[_auctionId].length;
        return auctionBids[_auctionId][len-1].amount;
    } // 옥션의 최종 낙찰가를 리턴

    //function getPathLenByItemIdAuc(uint256 _itemId) public view returns(uint256){}

    // 비상용 method, rwData = getRwSupplyData로 productTracing 접근이 안될 때

}


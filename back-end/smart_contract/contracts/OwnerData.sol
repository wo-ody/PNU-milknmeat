// SPDX-License-Identifier: MIT

pragma solidity >=0.5.16;

contract OwnerDataContract {

    mapping(uint256 => address) public itemOwner;       // itemId => 아이템 owner
    mapping(uint256 => address) public auctionOwner;    // auctionId => 옥션 owner

    mapping(address => uint256[]) public itemOwnedBy;   // user => 소유한 아이템 목록
    mapping(uint256 => uint256  ) public toOwnedId;     // itemId => ownedId(itemOwnedBy의 인덱스)
    mapping(address => uint256[]) public auctionOwnedBy; // user => 생성한 옥션 목록
    mapping(address => uint256[]) public winningBids;   // user => 낙찰받은 옥션 목록

    modifier isOwnerAuc(uint256 _auctionId) {
        require(auctionOwner[_auctionId] == msg.sender);
        _;
    }

    event updateItemOwnerSuccess(address _user, uint256 _itemId, uint256 _ownedId, uint256 _check);

    // auctionOwnedBy
    function getOwnerByAucId(uint256 _auctionId) external view returns(address payable){
        return payable(auctionOwner[_auctionId]);
    }

    function getAuctionOwnedByLength(address _owner) public view returns(uint) {
        return auctionOwnedBy[_owner].length;
    }

    function getAuctionOwnedBy(address _owner) public view returns(uint[] memory){
        return auctionOwnedBy[_owner];
    }

    function pushAuctionToOwner(address _user, uint256 _auctionId) public {
        auctionOwnedBy[_user].push(_auctionId);
    }

    function updateAuctionOwner(address _owner, uint256 _auctionId) public {
        auctionOwner[_auctionId] = _owner;
    }

    // winningBids

    function pushWinningBids(address _user, uint256 _auctionId) public{
        winningBids[_user].push(_auctionId);
    }

    function getWinningBids(address _user) public view returns(uint256[] memory){
        return winningBids[_user];
    }


    // itemOwnedBy
    function pushItemOwnedBy(address _user,uint256 _itemId) public {   
        itemOwnedBy[_user].push(_itemId);
    }

    function getItemOwnedBy(address _user) public view returns(uint256[] memory){
        return itemOwnedBy[_user];
    }

    function getOwnedItemByOwnedId(address _user, uint256 _ownedId) public view returns(uint256){
        return itemOwnedBy[_user][_ownedId];
    }

    function getOwendItemByItemId(address _user, uint256 _itemId) public view returns(uint256){
        return itemOwnedBy[_user][toOwnedId[_itemId]];
    }

    // itemOwnedBy 보조 (itemOwner, toOwnedId)
    function getOwnerByItemId(uint256 _itemId) public view returns(address){
        return itemOwner[_itemId];
    }


    function convertIdToOwnedId(uint256 _itemId) external view returns(uint256){
        return toOwnedId[_itemId];
    }

    function updateItemOwner(address _user, uint256 _itemId) public {
        itemOwner[_itemId] = _user;
        itemOwnedBy[_user].push(_itemId);
        toOwnedId[_itemId] = itemOwnedBy[_user].length - 1;
        emit updateItemOwnerSuccess(_user, _itemId, toOwnedId[_itemId], itemOwnedBy[_user][toOwnedId[_itemId]]);
    }

    function deleteOwnerData(address _user, uint256 _itemId) private {
        uint256 ownedId = toOwnedId[_itemId];
        itemOwnedBy[_user][ownedId] = itemOwnedBy[_user][itemOwnedBy[_user].length-1];
        itemOwnedBy[_user].pop();
    }


    // 소유권 이전
    function handoverOwnerData(address _from, address _to, uint256 _itemId, uint256 _auctionId) external {
        deleteOwnerData(_from, _itemId);
        updateItemOwner(_to, _itemId);
        pushWinningBids(_to, _auctionId);
        //ownedBy[_to].push(_itemId);
    }

    

    
}
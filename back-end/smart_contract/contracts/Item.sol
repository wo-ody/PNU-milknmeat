// SPDX-License-Identifier: MIT

import "./OwnerData.sol";
import "./SupplyManaging.sol";

pragma solidity >=0.5.16;

contract ItemContract{
    OwnerDataContract ownerDataContract;
    SupplyManagingContract supplyManagingContract;


    //OwnerDataContract ownerData;

    constructor(address _ownerDataContract, address _supplyManagingContract) {
        ownerDataContract = OwnerDataContract(_ownerDataContract);
        supplyManagingContract = SupplyManagingContract(_supplyManagingContract);

        //ownerData = OwnerDataContract(ownerDataAddress);
    }

    struct Item{
        string name;
        uint256 weight; 
        uint256 stock;     
        address payable producer;
        string origin;  
        uint256 itemId;    
        string[] imgCIDs;
        bool active;
    } 

    function getOwnerDataContract() public view returns(OwnerDataContract odc){
        return ownerDataContract;
    }

    Item[] public items;

    mapping(address => bool             ) public producerCheck;

    event CreateSuccess(address _user, uint256 _itmeId);


    function createItem(string memory _itemTitle, uint256 _weight, uint256 _stock, string memory _origin, string[] memory _imgCID) public {
        
        uint256 _itemId = items.length;

        
        Item memory newItem;
        
        newItem.name = _itemTitle;
        newItem.weight = _weight;
        newItem.stock = _stock;
        newItem.producer = payable(msg.sender); 
        newItem.origin = _origin;
        newItem.itemId = _itemId;
        newItem.imgCIDs = _imgCID;

        items.push(newItem);

        ownerDataContract.updateItemOwner(msg.sender, _itemId);
        supplyManagingContract.constructorSupplyData(_itemId);
        emit CreateSuccess(msg.sender, _itemId);
        //ownerData.setOwnerByItemId(msg.sender, _itemId);
        //ownerData.pushOwnedBy(msg.sender, _itemId);
    }

    function getNewItemId() public view returns(uint256){
        return items.length;
    }
    
    function getStockById(uint256 _itemId) public view returns(uint256){
        return items[_itemId].stock;
    }

    function getAllOfItems() public view returns(Item[] memory){
        return items;
    }
    
    function getProducerCheck(address _user) public view returns(bool){
        bool rtn = producerCheck[_user];
        return rtn;
    }

    function getImageCIDsById(uint256 _itemId) public view returns(string[] memory){
        return items[_itemId].imgCIDs;
    }

    function getOriginById(uint256 _itemId) public view returns(string memory){
        return items[_itemId].origin;
    }    

    function getProducerById(uint256 _itemId) public view returns(address _proudcer){
        return items[_itemId].producer;
    }

    function getItemNameById(uint256 _itemId) public view returns(string memory){
        return items[_itemId].name;
    }

    function getBidOrNotById(uint256 _itemId) public view returns(bool){
        return msg.sender != items[_itemId].producer;
    }

    function viewItemById(uint _itemId) public view returns(
        string memory name,
        uint256 weight,
        uint256 stock,
        address payable producer,
        string memory origin,
        uint256 itemId,
        string[] memory imgCIDs
    ){
        Item memory item = items[_itemId];
        return(
            item.name,
            item.weight,
            item.stock,
            item.producer,
            item.origin,
            item.itemId,
            item.imgCIDs
            );
    }

    function getItemById(uint256 _itemId) public view returns(Item memory){
        return items[_itemId];
    }

    function isProducer() public view returns(bool){
        return producerCheck[msg.sender];
    }
        

    function setUserToProducer(bool flag) public returns(bool){
        producerCheck[msg.sender] = flag;
        return producerCheck[msg.sender];
    }

    event SetOwnerToProducerEvent(bool flag);
    event CreateItemEvent(string _itemTitle, uint256 _weight, uint256 _stock, string _origin);
}
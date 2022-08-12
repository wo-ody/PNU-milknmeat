// SPDX-License-Identifier: MIT
import "./Supply.sol";


pragma solidity >=0.5.16;

contract SupplyManagingContract {

    mapping(uint256 => SupplyContract) public supplyData;

    function constructorSupplyData(uint256 _itemId) public{
        supplyData[_itemId] = new SupplyContract();
    }

    function getPathMaxByItemId(uint256 _itemId) public view returns(string[] memory){
        return supplyData[_itemId].getPathMax();
    }

    function getPathLenByItemId(uint256 _itemId) public view returns(uint256){
        return supplyData[_itemId].getPathLenByAddr(msg.sender);
    }

    function getShippingAddrByItemId(uint256 _itemId, uint256 _idx) public view returns(string memory){
        return supplyData[_itemId].getShippingAddrByIdx(_idx);
    }

    function setAddrToShippingByItemId(uint256 _itemId, address _from, address _to, 
        string memory _fromStr, string memory _toStr) public{
        supplyData[_itemId].setAddrToShippingAddr(_from, _to, _fromStr, _toStr);
    }


    // 배송 온습도 정보
    function pushEnvInformationByItemId(uint256 _itemId, string memory _envInfo) public{
        supplyData[_itemId].pushEnvInformation(_envInfo);
    } // 정보 추가

    function getEnvInformatioByItemId(uint256 _itemId) public view returns(string[] memory){
        return supplyData[_itemId].getEnvInformation();
    } // 정보 조회

}
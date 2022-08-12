// SPDX-License-Identifier: MIT

pragma solidity >=0.5.16;

contract SupplyContract{


    mapping(address => address) public addrTracing;    
    mapping(address => string ) public addrToShippingAddr;
    mapping(address => uint256) public addrToPathIdx;
    mapping(uint256 => address) public pathIdxToAddr;

    string[] public envInformation; // 환경정보, 

    string[] public pathMax;

    function setAddrTracing(address _from, address _to) public {
        addrTracing[_to] = _from;
    }

    function pushEnvInformation(string memory _envInfo) public {
        envInformation.push(_envInfo);
    }

    function getEnvInformation() public view returns(string[] memory){
        return envInformation;
    }

    function getShippingAddrByIdx(uint256 _idx) public view returns(string memory){
        return pathMax[_idx];
    } 

    function getPathLenByAddr(address _user) public view returns(uint256){
        return addrToPathIdx[_user];
    }

    function setAddrToShippingAddr(address _from, address _to, string memory _fromStr, string memory _toStr) public {
        pathIdxToAddr[pathMax.length] = _from;
        pathMax.push(_fromStr);
        addrToPathIdx[_from] = pathMax.length-1;

        pathIdxToAddr[pathMax.length] = _to;
        pathMax.push(_toStr);
        addrToPathIdx[_to] = pathMax.length-1;

    }

    function getPathMax() public view returns(string[] memory){
        return pathMax;
    }

    function productTracing(address _user, address _producer) public view returns(string[] memory){
        
        if(_user == _producer) revert();
        uint256 trlen = 0;
        uint256 fullLen = pathMax.length;

        string[] memory path = new string[](fullLen);

        path[trlen++] = addrToShippingAddr[_user];

        while(true){
            _user = addrTracing[_user];
            if(_user == _producer) break;
            
            path[trlen++] = addrToShippingAddr[_user];
         }
        
        if(trlen < fullLen){
            fullLen -= trlen;

            assembly { mstore(path, sub(mload(path), fullLen)) }
        }

         return path;
    }

    function productTracingFromYou(address _producer) public view returns(string[] memory){
        string[] memory path = productTracing(msg.sender, _producer);
        return path;
    }

    event productTracingCompleted(uint _itemId, address _root);
    event DontWorryBeHappy(uint256 _itemId, address _bidder);

}


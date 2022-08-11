
var Auction_sol;
var Item_sol;
var Supply_sol; 
var rwSupply_sol;
// 페이지 로드될때마다, 컨트랙트랑 연동시켜주기

async function startApp() {
	var AuctionAddress = "0xA242D29E719118bAd373cF72e6949fC22ba1ed1e";
	var ItemAddress = "0x8dcA0733f74924fa5C4fF5c00D5dc3B7E684ACc8";
	var SupplyAddress = "0xC0BF8B8BB56F1591616905506ca3Fa2085122D46";
	var rwSupplyAddress;

	Auction_sol = await new web3.eth.Contract(AuctionABI, AuctionAddress);
	Supply_sol = await new web3.eth.Contract(SupplyABI, SupplyAddress);
	Item_sol = await new web3.eth.Contract(ItemABI, ItemAddress);
	
	rwSupplyAddress = await Auction_sol.methods.getRwSupplyData().call();
	rwSupply_sol = await new web3.eth.Contract(rwSupplyABI, rwSupplyAddress);

}



window.addEventListener('load', function() {
	if (typeof web3 !== 'undefined') {
		web3 = new Web3(window.ethereum);
		console.log(web3)
	}

	//startApp();

	console.log("smart contract , 메타마스크 연결 완료");
	
})

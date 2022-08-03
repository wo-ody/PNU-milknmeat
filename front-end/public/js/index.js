
var Auction_sol;
var Item_sol;
var Supply_sol; 
var rwSupply_sol;
// 페이지 로드될때마다, 컨트랙트랑 연동시켜주기

async function startApp() {
	var AuctionAddress = "0x485889d873FEfd8C39d7FD882Ee009D0AAEE8450";
	var ItemAddress = "0xe75dFd86e5e713DA577612b1a6DdE27917701576";
	var SupplyAddress = "0x6E6EdbAEC3746946fF5E65d47CA332177471D761";
	var rwSupplyAddress;

	Auction_sol = await new web3.eth.Contract(AuctionABI, AuctionAddress);
	Supply_sol = await new web3.eth.Contract(SupplyABI, SupplyAddress);
	Item_sol = await new web3.eth.Contract(ItemABI, ItemAddress);
	
	rwSupplyAddress = await Auction_sol.methods.getRwSupplyData().call();
	rwSupply_sol = await new web3.eth.Contract(rwSupplyABI, rwSupplyAddress);

}



window.addEventListener('load', function() {
	// Web3가 브라우저에 주입되었는지 확인(Mist/MetaMask)
	if (typeof web3 !== 'undefined') {
	// Mist/MetaMask의 프로바이더 사용
		web3 = new Web3(window.ethereum);
		//console.log(web3)
	} else {
	// 사용자가 Metamask를 설치하지 않은 경우에 대해 처리
	// 사용자들에게 Metamask를 설치하라는 등의 메세지를 보여줄 것
	}

	// 이제 자네 앱을 시작하고 web3에 자유롭게 접근할 수 있네:
	startApp();

	console.log("smart contract , 메타마스크 연결 완료");
	
})


var Auction_sol;
var Item_sol;
var Supply_sol; 
var SupplyManaging_sol;
var OwnerData_sol;
// 페이지 로드될때마다, 컨트랙트랑 연동시켜주기

async function startApp() {
	var SupplyAddress = "0x2b356fEDAcf0Fe076202bB52d9123479654ec37D";
	var SupplyManagingAddress = "0x25cAB1e82e3eEEce190384B0C698B77B3232B77f";
	var OwnerDataAddress = "0x3d7BB93886f0ac2BF1985A84549014cad7fBA78b";
	var ItemAddress = "0x74758d5971119B90f2182C49F4AB9c98B85A9c1A";
	var AuctionAddress = "0x9bc17bbb9ef4693910C45E5A0C6F58bD72963C87";
	
	OwnerData_sol = await new web3.eth.Contract(OwnerABI, OwnerDataAddress);
	Auction_sol = await new web3.eth.Contract(AuctionABI, AuctionAddress);
	console.log("Auction Create");
	Supply_sol = await new web3.eth.Contract(SupplyABI, SupplyAddress);
	Item_sol = await new web3.eth.Contract(ItemABI, ItemAddress);
	SupplyManaging_sol = await new web3.eth.Contract(SupplyManagingABI, SupplyManagingAddress);
	console.log("SupplyManaging create")

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

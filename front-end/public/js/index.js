
var Auction_sol;
var Item_sol;
var Supply_sol; 
var SupplyManaging_sol;
var OwnerData_sol;
// 페이지 로드될때마다, 컨트랙트랑 연동시켜주기

async function startApp() {
	var SupplyAddress = "0x6E236eA1Deda8C2bCD72b82b56E3DF793E014abc";
	var SupplyManagingAddress = "0x4e0437AFA03248e8c9945cF42549097C64443e25";
	var OwnerDataAddress = "0x1480A624890BA3621Db68EA64D63425b87A1948c";
	var ItemAddress = "0x83A4944654834EE61a07fC83ccB2678F82329361";
	var AuctionAddress = "0x9aad4966d103Ebd1850022ebBDe92A3712C34703";
	
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

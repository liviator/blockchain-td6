pragma solidity >= 0.6.0 < 0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";


contract ChickenT is ERC721 {

    mapping(address => bool) private Whitelist;
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;
    address internal founder;
    struct poulet{ 
        string plumage;
        string bec;
        string yeux;
        string griffe;      
    }

    struct Auction{
        uint256 bid;
        uint launch;
        address current_winner;
    }
    mapping(uint256 => Auction) public AuctionHouse;
    mapping(uint256 => poulet) public collection;

    struct Bet{
        uint256 id;
        uint256 value;
        address winner;
    }
    mapping(uint => Bet) public wantToFight;
    Counters.Counter private fightId;
    address internal bank;
    
    uint nonce = 0;

    constructor() public ERC721("ChickenT","CT") {
        founder = msg.sender;
    }


    function set_whitelist(address account) public
    {
        require(founder == msg.sender);
        require (Whitelist[msg.sender] != true);
        Whitelist[account] = true;
    }
    function is_whitelisted(address account) public view returns(bool){
        return  Whitelist[account];
    }

    function add_animal(string memory plumage, string memory bec, string memory yeux, string memory griffe) public returns (uint256) {
        require(Whitelist[msg.sender] == true);
        uint256 NID = tokenIds.current();
        _mint(msg.sender,NID);
        collection[NID] = poulet(plumage, bec, yeux, griffe);
        tokenIds.increment();
        return NID;

    }

    function dead(uint Id) public returns(bool) {
        require(ownerOf(Id)== msg.sender);
        delete(collection[Id]);
        _burn(Id);
        return true;
    }

    function breed(uint Ida, uint Idb) public returns(bool) {
        require(ownerOf(Ida)== msg.sender);
        require(ownerOf(Idb)== msg.sender);
        poulet memory animala = collection[Ida];
        poulet memory animalb = collection[Idb];
        uint256 NID = add_animal(animala.plumage,animalb.bec,animala.yeux,animalb.griffe);
        return true;

    }

    function Startauction( uint ID, uint bid) public payable returns(bool){
        require(AuctionHouse[ID].launch == 0);
        require(ownerOf(ID) == msg.sender);
        uint today = block.timestamp;
        AuctionHouse[ID]=  Auction(bid,today,msg.sender);
        return true;
    }

    function Bid(uint ID, uint bid) public payable returns(bool){
        require(AuctionHouse[ID].launch != 0);
        Auction memory auct = AuctionHouse[ID];
        require(bid<msg.sender.balance);
        require(auct.bid <bid);
        require(block.timestamp <= auct.launch + 2 days);
        AuctionHouse[ID] = Auction(bid,auct.launch,msg.sender);
        return true;
    }

    function Claim(uint ID) public payable returns(bool){
        address payable propad = payable(ownerOf(ID));
        require(AuctionHouse[ID].launch != 0);
        Auction memory auct = AuctionHouse[ID];
        require(block.timestamp >= auct.launch + 2 days);
        require(auct.current_winner == msg.sender);
        transferFrom(propad,msg.sender,ID);
        return true;
    }

    function proposeToFight(uint Id) public payable {
        require(bank != address(0), "No bank defined");
        require(ownerOf(Id) == msg.sender, "Your not the owner of this chicken!");
        require(wantToFight[Id].value == 0, "This animal is already registered to fight! Stop SPAM the blockchain pls!");
        wantToFight[Id].value = msg.value;
        fightId.increment();
        wantToFight[Id].id = fightId.current();
        address payable propad = payable(bank);
        propad.transfer(msg.value);
    }

    function agreeToFight(uint IdWantToFightList, uint IdChallenger) public payable {
        require(bank != address(0), "No bank defined");
        require(wantToFight[IdWantToFightList].value != 0, "This chicken isn't on the challengers' list");
        require(ownerOf(IdChallenger) == msg.sender, "Your not the owner of this chicken!");
        require(wantToFight[IdWantToFightList].value >= msg.value - 20000 && wantToFight[IdWantToFightList].value <= msg.value + 20000, "You have to bet around the same amount as your opponent");
        address payable propad = payable(bank);
        propad.transfer(msg.value);
        if (random() % 2 == 0) {
            wantToFight[IdWantToFightList].winner = ownerOf(IdWantToFightList);
        } else {
            wantToFight[IdWantToFightList].winner = ownerOf(IdChallenger);
        }
        
    }

    function random() private returns (uint) {
        uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 100;
        randomnumber = randomnumber + 1;
        nonce++;
        return randomnumber;
    }
}
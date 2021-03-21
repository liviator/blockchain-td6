pragma solidity >= 0.6.0 < 0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

contract NFTA is ERC721 {
    mapping (address => bool) public breeders;
    struct Animal {
        string name;
        string species;
        string color;
        uint dna;
    }
    mapping (uint256 => Animal) public animals;
    Animal token;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(string => bool) hashes;

    constructor() public ERC721("NoFongibleTokenAnimal", "NFTA") {}

    function RegisterBreeder(address breeder) public returns(bool success) {
        if (!breeders[breeder]) {
            breeders[breeder] = true;
            success = true;
        }
    }

    function declareAnimal(string memory name, string memory species, string memory color, uint dna, string memory hash) public returns(uint256) {
        require(breeders[msg.sender]);
        require(!hashes[hash]);
        hashes[hash] = true;
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        token = Animal(name, species, color, dna);
        _mint(msg.sender, newItemId);
        return newItemId;
    }
}
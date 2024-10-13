// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNft is ERC721, Ownable {
    uint256 private _tokenIdCounter;
    mapping(uint256 => string) private _tokenURIs;
    string baseURI;

    constructor(
        string memory _baseURI
    ) ERC721("Laborat", "LB") Ownable(msg.sender) {
        baseURI = _baseURI;
    }

    function mint() public onlyOwner {
        _tokenIdCounter++;
        uint256 newTokenId = _tokenIdCounter;
        _safeMint(msg.sender, newTokenId);

        string memory newTokenURI = string(
            abi.encodePacked(baseURI, Strings.toString(newTokenId), ".json")
        );
        _tokenURIs[newTokenId] = newTokenURI;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(
            ownerOf(tokenId) != address(0),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return _tokenURIs[tokenId];
    }

    function setBaseURI(string memory newBaseURI) public onlyOwner {
        baseURI = newBaseURI;
    }
}

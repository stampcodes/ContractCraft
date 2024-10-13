// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract MyNftMarket is ERC721, Ownable, ReentrancyGuard {
    uint256 private _tokenIdCounter = 0;

    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => uint256) nftPrices;

    string private baseURI;
    uint256 totalNftSupply = 20;

    event NFTPurchased(
        address indexed buyer,
        address indexed seller,
        uint256 tokenId,
        uint256 price
    );

    constructor(
        string memory _baseURI
    ) ERC721("NftCollectionName", "NCN") Ownable(msg.sender) {
        baseURI = _baseURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function mintAllNFTs() public onlyOwner {
        for (uint256 i = 0; i < totalNftSupply; i++) {
            _tokenIdCounter++;
            uint256 currentTokenId = _tokenIdCounter;
            _safeMint(msg.sender, currentTokenId);

            string memory newTokenURI = string(
                abi.encodePacked(
                    baseURI,
                    Strings.toString(currentTokenId),
                    ".json"
                )
            );
            _tokenURIs[currentTokenId] = newTokenURI;
        }
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

    function setNftPrice(uint256 _tokenId, uint256 _price) public {
        require(
            msg.sender == ownerOf(_tokenId),
            "You are not the owner of the NFT"
        );
        require(_price > 0, "Price must be greater than zero");
        nftPrices[_tokenId] = _price * 1 ether;
    }

    function getNftPrice(uint _tokenId) public view returns (uint256) {
        require(ownerOf(_tokenId) != address(0), "Token does not exist");
        return nftPrices[_tokenId] / 1 ether;
    }

    function getNftsForSale() public view returns (uint256[] memory) {
        uint256 totalMinted = _tokenIdCounter;
        uint256 itemCount = 0;

        for (uint256 i = 1; i <= totalMinted; i++) {
            if (nftPrices[i] > 0) {
                itemCount++;
            }
        }

        uint256[] memory nftsForSale = new uint256[](itemCount);
        uint256 currentIndex = 0;
        for (uint256 i = 1; i <= totalMinted; i++) {
            if (nftPrices[i] > 0) {
                nftsForSale[currentIndex] = i;
                currentIndex++;
            }
        }

        return nftsForSale;
    }

    function purchaseNFT(uint _tokenId) public payable nonReentrant {
        address currentNftOwner = ownerOf(_tokenId);
        require(ownerOf(_tokenId) != address(0), "Token does not exist");
        require(msg.sender != currentNftOwner, "NFT is already yours");
        require(
            msg.value >= nftPrices[_tokenId],
            "Enter the correct amount of Ether"
        );
        uint256 nftPrice = nftPrices[_tokenId];
        uint256 excess = msg.value - nftPrice;
        nftPrices[_tokenId] = 0;
        safeTransferFrom(currentNftOwner, msg.sender, _tokenId);
        payable(currentNftOwner).transfer(nftPrice);

        if (excess > 0) {
            payable(msg.sender).transfer(excess);
        }
        emit NFTPurchased(msg.sender, currentNftOwner, _tokenId, nftPrice);
    }
}

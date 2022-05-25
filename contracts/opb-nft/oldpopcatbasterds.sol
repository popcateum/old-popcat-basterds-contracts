// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "../openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../openzeppelin/contracts/security/Pausable.sol";
import "../openzeppelin/contracts/access/Ownable.sol";
import "../openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "../openzeppelin/contracts/utils/Counters.sol";

contract OldPopcatBasterds is ERC721, ERC721Enumerable, Pausable, Ownable, ERC721Burnable {
	using Counters for Counters.Counter;

	Counters.Counter private _tokenIdCounter;
	uint256 public maxAmount;
	string private _baseTokenURI;
	address public minterContract;
	bool private isRevealed = false;

	mapping(uint256 => uint256) public tokenYear;

	constructor(string memory _uri, uint256 _maxAmount) ERC721("OldPopcatBasterds", "OPB") {
		setBaseURI(_uri);
		setMaxAmount(_maxAmount);
	}

	modifier checkMaxAmount() {
		require(maxAmount > _tokenIdCounter.current(), "Maximum number of NFTs reached.");
		_;
	}

	modifier onlyMinter() {
		require(_msgSender() == minterContract);
		_;
	}

	function pause() public onlyOwner {
		_pause();
	}

	function unpause() public onlyOwner {
		_unpause();
	}

	// !! Sale Contract Only mintable
	function saleMint(address to, uint256 _createdAt) external checkMaxAmount onlyMinter {
		_tokenIdCounter.increment();
		uint256 tokenId = _tokenIdCounter.current();
		tokenYear[tokenId] = _createdAt;
		_mint(to, tokenId);
	}

	function tokenURI(uint256 _tokenId) public view override returns (string memory) {
		require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
		if (!isRevealed) {
			return string(abi.encodePacked(_baseURI(), Strings.toString(tokenYear[_tokenId])));
		}
		return string(abi.encodePacked(_baseURI(), Strings.toString(_tokenId)));
	}

	function setBaseURI(string memory _uri) public onlyOwner {
		_baseTokenURI = _uri;
	}

	function setIsReveal(bool _isReveal) external onlyOwner {
		isRevealed = _isReveal;
	}

	function setMinterContract(address saleContract) public onlyOwner {
		minterContract = saleContract;
	}

	function setMaxAmount(uint256 _amount) public onlyOwner {
		maxAmount = _amount;
	}

	function _baseURI() internal view virtual override returns (string memory) {
		return _baseTokenURI;
	}

	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 tokenId
	) internal override(ERC721, ERC721Enumerable) whenNotPaused {
		super._beforeTokenTransfer(from, to, tokenId);
	}

	function _afterTokenTransfer(
		address from,
		address to,
		uint256 tokenId
	) internal override(ERC721) {
		super._afterTokenTransfer(from, to, tokenId);
	}

	function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
		return super.supportsInterface(interfaceId);
	}
}

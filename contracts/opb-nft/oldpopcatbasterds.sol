// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "../openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../openzeppelin/contracts/security/Pausable.sol";
import "../openzeppelin/contracts/access/Ownable.sol";
import "../openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "../openzeppelin/contracts/utils/Counters.sol";
import "../openzeppelin/contracts/mocks/SignatureCheckerMock.sol";
import "../openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";

contract OldPopcatBasterds is ERC721, ERC721Enumerable, Pausable, Ownable, ERC721Burnable, ReentrancyGuard, SignatureCheckerMock, EIP712 {
	using Counters for Counters.Counter;

	Counters.Counter private _2015Counter;
	Counters.Counter private _2016Counter;
	Counters.Counter private _2017Counter;
	Counters.Counter private _2018Counter;
	Counters.Counter private _2019Counter;
	Counters.Counter private _2020Counter;
	Counters.Counter private _2021Counter;
	Counters.Counter private _2022Counter;
	Counters.Counter private _tokenIdCounter;

	address private C1;
	address private C2;
	address private C3;
	address private C4;

	address private wlSigner;
	string private _baseTokenURI;
	uint256 private constant MAX_AMOUNT = 10000;
	bool private isRevealed = false;

	mapping(address => bool) private _isMinted;
	mapping(uint256 => uint256) private _tokenMaximumAmount;
	mapping(uint256 => uint256) public tokenYear;

	constructor(
		address _signer,
		string memory _uri,
		address _c1,
		address _c2,
		address _c3,
		address _c4
	) ERC721("OldPopcatBasterds", "OPB") EIP712("OldPopcatBasterds", "1") {
		C1 = _c1;
		C2 = _c2;
		C3 = _c3;
		C4 = _c4;
		wlSigner = _signer;
		setBaseURI(_uri);
	}

	modifier isNotContract() {
		require(msg.sender == tx.origin, "Sender is not EOA");
		_;
	}

	modifier checkMint(address _address) {
		require(msg.value >= 0.01 ether, "Invalid value.");
		require(msg.sender == _address, "Invalid address.");
		require(_isMinted[msg.sender] == false, "Already minted.");
		_;
	}

	modifier checkMintCount(uint256 _year) {
		require(MAX_AMOUNT > _tokenIdCounter.current(), "Maximum number of NFTs reached.");

		bool _isMint;
		if (_year == 0) {
			_isMint = _tokenMaximumAmount[_year] > _2015Counter.current();
		} else if (_year == 1) {
			_isMint = _tokenMaximumAmount[_year] > _2016Counter.current();
		} else if (_year == 2) {
			_isMint = _tokenMaximumAmount[_year] > _2017Counter.current();
		} else if (_year == 3) {
			_isMint = _tokenMaximumAmount[_year] > _2018Counter.current();
		} else if (_year == 4) {
			_isMint = _tokenMaximumAmount[_year] > _2019Counter.current();
		} else if (_year == 5) {
			_isMint = _tokenMaximumAmount[_year] > _2020Counter.current();
		} else if (_year == 6) {
			_isMint = _tokenMaximumAmount[_year] > _2021Counter.current();
		} else if (_year == 7) {
			_isMint = _tokenMaximumAmount[_year] > _2022Counter.current();
		} else {
			revert("This is not the year that supports minting.");
		}
		require(_isMint, "You have exceeded the maximum number of minting.");

		_;
	}

	modifier checkHashSign(
		address _to,
		uint256 _createdAt,
		bytes32 _hash,
		bytes memory _signature
	) {
		bytes32 veriftyHash = keccak256(abi.encodePacked(_to, _createdAt, address(this)));
		require(_hash == veriftyHash, "Hash does not match.");
		require(isValidSignatureNow(address(wlSigner), _hash, _signature), "Signature does not match.");
		_;
	}

	receive() external payable {}

	function withdraw() public payable onlyOwner {
		uint256 contractBalance = address(this).balance;
		uint256 percentage = contractBalance / 100;

		(bool success1, ) = C1.call{ value: percentage * 30 }("");
		(bool success2, ) = C2.call{ value: percentage * 30 }("");
		(bool success3, ) = C3.call{ value: percentage * 30 }("");
		(bool success4, ) = C4.call{ value: percentage * 10 }("");

		if (!success1 || !success2 || !success3 || !success4) {
			revert("Ether transfer failed");
		}
	}

	function pause() public onlyOwner {
		_pause();
	}

	function unpause() public onlyOwner {
		_unpause();
	}

	function mint(
		address _to,
		uint256 _createdAt,
		bytes32 _hash,
		bytes memory _signature
	) public payable nonReentrant isNotContract checkMintCount(_createdAt) checkHashSign(_to, _createdAt, _hash, _signature) checkMint(_to) {
		_tokenIdCounter.increment();
		uint256 tokenId = _tokenIdCounter.current();
		tokenYear[tokenId] = _createdAt;
		_mintCounter(_createdAt);
		_isMinted[_to] = true;
		_mint(_to, tokenId);
	}

	function setMaximunAmount(uint256[] memory amounts) public onlyOwner {
		for (uint256 i = 0; i < amounts.length; i++) {
			_tokenMaximumAmount[i] = amounts[i];
		}
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

	function _mintCounter(uint256 _year) internal {
		if (_year == 0) {
			_2015Counter.increment();
		} else if (_year == 1) {
			_2016Counter.increment();
		} else if (_year == 2) {
			_2017Counter.increment();
		} else if (_year == 3) {
			_2018Counter.increment();
		} else if (_year == 4) {
			_2019Counter.increment();
		} else if (_year == 5) {
			_2020Counter.increment();
		} else if (_year == 6) {
			_2021Counter.increment();
		} else if (_year == 7) {
			_2022Counter.increment();
		} else {
			revert("This is not the year that supports minting.");
		}
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

	// The following functions are overrides required by Solidity.

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

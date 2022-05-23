// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "../interfaces/Ioldpopcatbasterds.sol";
import "../openzeppelin/contracts/access/Ownable.sol";
import "../openzeppelin/contracts/utils/Counters.sol";
import "../openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";

contract Sale is Ownable, ReentrancyGuard {
	using Counters for Counters.Counter;
	using SignatureChecker for address;
	using ECDSA for bytes32;

	IOldPopcatBasterds public opb;

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
	uint256 private constant MAX_AMOUNT = 10000;

	mapping(address => bool) private _isMinted;
	mapping(uint256 => uint256) private _tokenMaximumAmount;

	modifier isNotContract() {
		require(msg.sender == tx.origin, "Sender is not EOA");
		_;
	}

	modifier checkMint(address _address) {
		require(msg.value >= 0.01 ether, "Invalid value.");
		require(_isMinted[_address] == false, "Already minted.");
		_;
	}

	modifier checkMintCount(uint256 _year) {
		require(MAX_AMOUNT > _tokenIdCounter.current(), "Maximum number of NFTs reached.");

		bool _isMint;
		if (_year == 2015) {
			_isMint = _tokenMaximumAmount[_year] > _2015Counter.current();
		} else if (_year == 2016) {
			_isMint = _tokenMaximumAmount[_year] > _2016Counter.current();
		} else if (_year == 2017) {
			_isMint = _tokenMaximumAmount[_year] > _2017Counter.current();
		} else if (_year == 2018) {
			_isMint = _tokenMaximumAmount[_year] > _2018Counter.current();
		} else if (_year == 2019) {
			_isMint = _tokenMaximumAmount[_year] > _2019Counter.current();
		} else if (_year == 2020) {
			_isMint = _tokenMaximumAmount[_year] > _2020Counter.current();
		} else if (_year == 2021) {
			_isMint = _tokenMaximumAmount[_year] > _2021Counter.current();
		} else if (_year == 2022) {
			_isMint = _tokenMaximumAmount[_year] > _2022Counter.current();
		} else {
			revert("This is not the year that supports minting.");
		}
		require(_isMint, "You have exceeded the maximum number of minting.");

		_;
	}

	constructor(
		address _opb,
		address _signer,
		address _c1,
		address _c2,
		address _c3,
		address _c4
	) {
		opb = IOldPopcatBasterds(_opb);
		wlSigner = _signer;
		C1 = _c1;
		C2 = _c2;
		C3 = _c3;
		C4 = _c4;
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

	function mint(
		uint256 _createdAt,
		bytes32 _hash,
		bytes memory _signature
	) public payable nonReentrant isNotContract checkMintCount(_createdAt) checkMint(msg.sender) {
		// TODO 발행기준을 year로, year인자도 받기. _createdAt === year

		require(isDataValid(_createdAt, _hash, _signature), "Hash does not match.");
		_tokenIdCounter.increment();
		uint256 tokenId = _tokenIdCounter.current();
		_mintCounter(_createdAt);
		_isMinted[msg.sender] = true;
		// WL 서명 유효성 유지를 위하여 다른 사람의 opb를 대신 민팅 불가하게 작성됨
		// unreaveal 상태의 baseURI를 리턴할 수 있게 _createdAt 데이터 전달
		opb.saleMint(msg.sender, tokenId, _createdAt);
	}

	function isDataValid(
		uint256 _createdAt,
		bytes32 _hash,
		bytes memory _signature
	) public view returns (bool) {
		bytes32 signedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash));
		require(signedHash.recover(_signature) == wlSigner, "Invalid signature");

		bytes32 veriftyHash = keccak256(abi.encodePacked(msg.sender, _createdAt, address(this)));
		bytes32 signedVeriftyHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", veriftyHash));

		return signedVeriftyHash == signedHash;
	}

	function setMaximunAmount(uint256[] memory amounts) public onlyOwner {
		for (uint256 i = 0; i < amounts.length; i++) {
			_tokenMaximumAmount[i] = amounts[i];
		}
	}

	function _mintCounter(uint256 _year) internal {
		if (_year == 2015) {
			_2015Counter.increment();
		} else if (_year == 2016) {
			_2016Counter.increment();
		} else if (_year == 2017) {
			_2017Counter.increment();
		} else if (_year == 2018) {
			_2018Counter.increment();
		} else if (_year == 2019) {
			_2019Counter.increment();
		} else if (_year == 2020) {
			_2020Counter.increment();
		} else if (_year == 2021) {
			_2021Counter.increment();
		} else if (_year == 2022) {
			_2022Counter.increment();
		} else {
			revert("This is not the year that supports minting.");
		}
	}
}

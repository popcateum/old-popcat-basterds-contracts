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

	Counters.Counter private _tokenIdCounter;
	Counters.Counter private _2015Counter;
	Counters.Counter private _2016Counter;
	Counters.Counter private _2017Counter;
	Counters.Counter private _2018Counter;
	Counters.Counter private _2019Counter;
	Counters.Counter private _2020Counter;
	Counters.Counter private _2021Counter;
	Counters.Counter private _2022Counter;

	address private wlSigner;
	uint256 private constant MAX_AMOUNT = 10000;

	struct Count {
		uint256 _2015;
		uint256 _2016;
		uint256 _2017;
		uint256 _2018;
		uint256 _2019;
		uint256 _2020;
		uint256 _2021;
		uint256 _2022;
	}

	mapping(address => bool) public isMinted;
	mapping(uint256 => uint256) public tokenMaximumAmount;

	modifier isNotContract() {
		require(msg.sender == tx.origin, "Sender is not EOA");
		_;
	}

	modifier checkMint(address _address) {
		require(isMinted[_address] == false, "Already minted.");
		_;
	}

	modifier checkMintCount(uint256 _year) {
		require(MAX_AMOUNT > _tokenIdCounter.current(), "Maximum number of NFTs reached.");

		bool _isMint;
		if (_year == 2015) {
			_isMint = tokenMaximumAmount[_year] > _2015Counter.current();
		} else if (_year == 2016) {
			_isMint = tokenMaximumAmount[_year] > _2016Counter.current();
		} else if (_year == 2017) {
			_isMint = tokenMaximumAmount[_year] > _2017Counter.current();
		} else if (_year == 2018) {
			_isMint = tokenMaximumAmount[_year] > _2018Counter.current();
		} else if (_year == 2019) {
			_isMint = tokenMaximumAmount[_year] > _2019Counter.current();
		} else if (_year == 2020) {
			_isMint = tokenMaximumAmount[_year] > _2020Counter.current();
		} else if (_year == 2021) {
			_isMint = tokenMaximumAmount[_year] > _2021Counter.current();
		} else if (_year == 2022) {
			_isMint = tokenMaximumAmount[_year] > _2022Counter.current();
		} else {
			revert("This is not the year that supports minting.");
		}
		require(_isMint, "You have exceeded the maximum number of minting.");

		_;
	}

	constructor(address _opb, address _signer) {
		opb = IOldPopcatBasterds(_opb);
		wlSigner = _signer;
	}

	receive() external payable {}

	function mint(
		uint256 _year,
		bytes32 _hash,
		bytes memory _signature
	) public payable nonReentrant isNotContract checkMintCount(_year) checkMint(msg.sender) {
		require(isDataValid(_year, _hash, _signature), "Hash does not match.");
		_tokenIdCounter.increment();
		uint256 _tokenId = _mintCounter(_year);
		isMinted[msg.sender] = true;
		// WL 서명 유효성 유지를 위하여 다른 사람의 opb를 대신 민팅 불가하게 작성됨
		// unreaveal 상태의 baseURI를 리턴할 수 있게 _year 데이터 전달
		opb.saleMint(msg.sender, _tokenId, _year);
	}

	function getMintState() public view returns (Count memory) {
		return
			Count(
				_2015Counter.current(),
				_2016Counter.current(),
				_2017Counter.current(),
				_2018Counter.current(),
				_2019Counter.current(),
				_2020Counter.current(),
				_2021Counter.current(),
				_2022Counter.current()
			);
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
		uint256 _year = 2015;
		for (uint256 i = 0; i < amounts.length; i++) {
			tokenMaximumAmount[_year] = amounts[i];
			_year += 1;
		}
	}

	function _mintCounter(uint256 _year) internal returns (uint256) {
		if (_year == 2015) {
			_2015Counter.increment();
			return 0 + _2015Counter.current();
		} else if (_year == 2016) {
			_2016Counter.increment();
			return 100 + _2016Counter.current();
		} else if (_year == 2017) {
			_2017Counter.increment();
			return 300 + _2017Counter.current();
		} else if (_year == 2018) {
			_2018Counter.increment();
			return 700 + _2018Counter.current();
		} else if (_year == 2019) {
			_2019Counter.increment();
			return 2000 + _2019Counter.current();
		} else if (_year == 2020) {
			_2020Counter.increment();
			return 3500 + _2020Counter.current();
		} else if (_year == 2021) {
			_2021Counter.increment();
			return 5500 + _2021Counter.current();
		} else if (_year == 2022) {
			_2022Counter.increment();
			return 8000 + _2022Counter.current();
		} else {
			revert("This is not the year that supports minting.");
		}
	}
}

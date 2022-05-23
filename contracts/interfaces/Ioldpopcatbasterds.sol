// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface IOldPopcatBasterds {
	function saleMint(
		address to,
		uint256 tokenId,
		uint256 _createdAt
	) external;
}

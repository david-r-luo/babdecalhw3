pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title BadAuction */
contract BadAuction is AuctionInterface {
	/* Bid function, vulnerable to attack
	 * Must return true on successful send and/or bid,
	 * bidder reassignment
	 * Must return false on failure and send people
	 * their funds back
	 */

	uint highestBid;
	address highestBidder;

	function bid() payable external returns (bool) {
		if (msg.value <= highestBid) {
			msg.sender.transfer(msg.value);
			return false;
		}

		if (highestBidder != 0) {
			if (!highestBidder.send(highestBid)) {
				return false;
			}
		}

		highestBidder = msg.sender;
		highestBid = msg.value;

		return true;

	}

	function getHighestBidder() constant returns (address) {
		return highestBidder;
	}


	function getHighestBid() constant returns (uint) {
		return highestBid;
	}

	/* Give people their funds back */
	function () payable {
		msg.sender.transfer(msg.value);
	}
}

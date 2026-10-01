// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ISettlementOracle {
    function status(bytes32 transferId) external view returns (uint8);
}

contract BridgeSettlement {
    ISettlementOracle public immutable oracle;
    address public immutable operator;

    struct Payout {
        address payable recipient;
        uint256 amount;
        bool released;
    }

    mapping(bytes32 => Payout) public payouts;

    modifier onlyOperator() {
        require(msg.sender == operator, "not operator");
        _;
    }

    constructor(address _oracle) payable {
        oracle = ISettlementOracle(_oracle);
        operator = msg.sender;
    }

    receive() external payable {}

    function registerPayout(
        bytes32 transferId,
        address payable recipient,
        uint256 amount
    ) external onlyOperator {
        require(payouts[transferId].amount == 0, "already registered");

        payouts[transferId] = Payout({
            recipient: recipient,
            amount: amount,
            released: false
        });
    }

    function release(bytes32 transferId) external {
        Payout storage payout = payouts[transferId];

        require(payout.amount > 0, "unknown transfer");
        require(!payout.released, "already released");

        require(
            oracle.status(transferId) >= 1,
            "transfer not settled"
        );

        payout.released = true;

        (bool success, ) =
            payout.recipient.call{value: payout.amount}("");

        require(success, "transfer failed");
    }
}
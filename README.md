# BridgeSettlement

This contract releases destination-chain assets after checking
the state of a source-chain transfer through an external settlement oracle.

## Settlement oracle specification

The oracle returns:

- 0: The source-chain transfer is not finalized.
- 1: The source-chain transfer is finalized and irreversible.
- 2 or greater: The transfer is finalized and additional settlement
  processing has completed.

A payout may be released whenever the oracle status is 1 or greater.

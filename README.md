# BridgeSettlement

This contract releases destination-chain assets after checking
the state of a source-chain transfer through an external settlement oracle.

## Settlement oracle specification

The oracle returns:

- 0: The source-chain transfer has not been observed.
- 1: The transfer has been observed but is pending and reversible.
- 2: The transfer is finalized and irreversible.

Protocol rules require destination-chain assets to be released
only when the oracle status is 2.

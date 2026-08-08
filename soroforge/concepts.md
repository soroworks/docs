# Concepts

## Tracked deployments

Every time SoroForge deploys or upgrades a contract, it writes a record: the contract alias and ID, the network, the WASM hash, whether it was a deploy or an upgrade, the deployer's public key, the transaction hash, the ledger, and the time. This history is the core value — it turns "what's live?" and "what changed?" from guesswork into a query.

## Deploy vs upgrade

- **Deploy** uploads a contract's WASM and instantiates a new contract, recording a fresh contract ID.
- **Upgrade** points an existing tracked contract at new WASM (where the contract supports upgrading), recording the version transition against the same contract while preserving the prior record.

Because both are recorded, `soroforge history <contract>` shows the full lineage of a contract across its lifetime on a network.

## Drift detection

`soroforge status` fetches the contract's current on-chain WASM hash and compares it to what SoroForge believes is live. A mismatch — "drift" — means something changed outside SoroForge (a manual upgrade, a different tool, a different operator). Catching drift early is how you keep your tracked history trustworthy.

## Dry-run

Every state-changing action can be assembled without being submitted. Dry-run builds the exact transaction SoroForge would send and shows it to you, so nothing signs or spends until you've confirmed it's what you intended. This is the safety rail for mainnet operations.

## Multi-network

A contract alias like `my-token` is tracked independently per network. Deploying `my-token` to testnet and later to mainnet produces two separate, correctly-namespaced records — no collisions, no ambiguity about which network a given contract ID belongs to.

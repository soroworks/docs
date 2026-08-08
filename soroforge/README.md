# SoroForge

**Deployment and lifecycle management for Soroban smart contracts.**

SoroForge turns Soroban contract deployment into a repeatable, auditable workflow. Deploy a contract, upgrade it later, and always know which version of which contract is live on which network — with a recorded history of every deploy and upgrade.

## Why SoroForge exists

Deploying and upgrading Soroban contracts today is a pile of one-off CLI invocations with no memory. Which WASM hash is live on testnet versus mainnet? What changed between versions? Who deployed it, and when? SoroForge answers those questions by treating deployment like any other tracked software process: every action is recorded, repeatable, and auditable.

- **Tracked history** — every deploy and upgrade records the contract ID, WASM hash, network, deployer, transaction hash, and timestamp
- **Multi-network** — testnet, mainnet, and custom RPCs are first-class; every record is namespaced by network
- **Drift detection** — confirm the on-chain WASM hash still matches what SoroForge believes is live
- **CLI and API** — a cobra CLI for humans, an HTTP API for CI pipelines
- **Dry-run safe** — assemble transactions without submitting, so you can inspect before you commit

## Where it fits in SoroWorks

SoroForge is the **deploy** stage. After deploying, catalog the contract's interface in [SoroVault](../sorovault/README.md), and verify its health with [SoroProbe](../soroprobe/README.md).

## Next

- [Quickstart](quickstart.md) — deploy a contract to testnet
- [Configuration](configuration.md) — networks, keys, and the project config file
- [Concepts](concepts.md) — how deployment tracking and drift detection work
- [CLI & API reference](reference.md)
- [Contributing](contributing.md)

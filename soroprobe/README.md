# SoroProbe

**Simulation and health checking for Soroban smart contracts.**

SoroProbe lets you dry-run a contract call before it runs for real: see whether it would succeed, what it would return, what it would cost, and whether the contract's on-chain state is healthy — for example, not about to expire. It's read-only and stateless: it asks the chain questions, it never changes anything.

## Why SoroProbe exists

Before invoking a Soroban contract for real, you want to know: will this call succeed? what will it cost? is the contract's state healthy, or is it about to expire and start failing? Today that means ad-hoc CLI simulation and manual reasoning. SoroProbe packages it into a tool you can run by hand or wire into CI.

- **Simulate** — run a call through `simulateTransaction` and see the decoded result, success/failure, and estimated resource costs
- **Inspect** — read a contract's on-chain entries and report state health, including how close anything is to expiring
- **Check** — a combined health check that exits non-zero on failure, so it gates cleanly in CI
- **Read-only & stateless** — no database, no signing, no submission; it queries the chain live

## Where it fits in SoroWorks

SoroProbe is the **verify** stage. After a contract is deployed with [SoroForge](../soroforge/README.md) and cataloged in [SoroVault](../sorovault/README.md), SoroProbe confirms it behaves and stays healthy.

## Next

- [Quickstart](quickstart.md) — simulate a call against testnet
- [Configuration](configuration.md)
- [Concepts](concepts.md) — simulation and the state-expiration model
- [CLI & API reference](reference.md)
- [Contributing](contributing.md)

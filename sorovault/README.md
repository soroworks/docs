# SoroVault

**A contract interface (ABI) registry for the Stellar/Soroban network.**

A deployed Soroban contract is a black box unless you have its interface. SoroVault fetches a deployed contract's interface spec, decodes it into a clean, machine-readable form, and serves it through a searchable registry — so tools and people can discover exactly what functions and types a contract exposes.

## Why SoroVault exists

A contract's interface — its functions, their arguments, and its types — is embedded in the uploaded WASM on-chain, but there's no easy way to look it up, search across contracts, or hand a machine-readable ABI to other tooling. SoroVault is that discovery layer: register a contract, and its interface becomes browsable, searchable, and consumable as clean JSON.

- **Decode** — fetch a contract's WASM and decode its interface spec (functions, arguments, return types, user-defined types)
- **Register & search** — store decoded interfaces and search across registered contracts
- **Serve a usable ABI** — expose each interface as clean JSON other tools can build on
- **Version-aware** — detect when a contract's on-chain WASM changes and keep the prior interface version
- **Browse** — a minimal web UI for humans, a JSON API for machines

## Where it fits in SoroWorks

SoroVault is the **catalog** stage. After a contract is deployed with [SoroForge](../soroforge/README.md), SoroVault records what it exposes, and [SoroProbe](../soroprobe/README.md) uses that understanding to verify and simulate against it.

## Next

- [Quickstart](quickstart.md) — register and browse a contract's interface
- [Configuration](configuration.md)
- [Concepts](concepts.md) — how specs are decoded and versioned
- [API & CLI reference](reference.md)
- [Contributing](contributing.md)

# SoroWorks

**Developer tooling for shipping and maintaining Soroban smart contracts.**

SoroWorks is a suite of three complementary open-source tools, written in Go, that cover the contract lifecycle on the Stellar/Soroban network: deploy, verify, and catalog.

## The three tools

- **[SoroForge](soroforge/README.md)** — deployment and lifecycle management. Deploy contracts, upgrade them, and track which version is live on which network, with a recorded history.
- **[SoroProbe](soroprobe/README.md)** — simulation and health checking. Dry-run contract calls before they run, see results and resource costs, and check that a contract's state is healthy.
- **[SoroVault](sorovault/README.md)** — interface discovery. Fetch a deployed contract's interface spec, decode it, and serve it as a searchable ABI registry.

## How they fit together

```
   deploy              catalog              verify
 ┌──────────┐        ┌──────────┐        ┌──────────┐
 │ SoroForge│ ─────▶ │ SoroVault│ ─────▶ │ SoroProbe│
 └──────────┘        └──────────┘        └──────────┘
  push a WASM,        decode & serve       simulate calls,
  track versions      its interface        check state health
```

You **deploy** a contract with SoroForge, **catalog** its interface in SoroVault so tools and people know what it exposes, and **verify** its behavior and ongoing health with SoroProbe. Each tool is useful entirely on its own, but together they form a coherent workflow for building on Soroban with confidence.

## What they share

- **A language and foundation** — all three are Go, built against the Stellar RPC and XDR libraries, reusing the same patterns for transaction assembly, ScVal decoding, and contract-spec handling. A contributor who learns one moves easily to the others.
- **A design philosophy** — each is built around small, mockable interfaces (stellar client, decoder, store, signer) so that `go test ./...` never needs a live network and contributions stay well-scoped.
- **An operating model** — each ships as a single Go binary with a CLI and/or HTTP API, runs via Docker Compose, and is Apache-2.0 licensed.

## Where to start

- New here? Read the tool that matches your need: [SoroForge](soroforge/README.md) to deploy, [SoroProbe](soroprobe/README.md) to test, [SoroVault](sorovault/README.md) to discover interfaces.
- Want to contribute? Each tool has a Contributing page, and all follow the same interface-first patterns.

## Project links

- Organization: [github.com/soroworks](https://github.com/soroworks)
- SoroForge · SoroProbe · SoroVault repositories, all under the same org.

All SoroWorks tools are licensed under Apache-2.0.

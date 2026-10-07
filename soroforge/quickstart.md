# Quickstart

Deploy a contract to testnet and see it tracked. You need Docker (for Postgres), a compiled contract, and a funded testnet account.

## 1. Install SoroForge

Download a binary for your platform from the [latest release](https://github.com/soroworks/soroforge/releases/latest), or build it with Go 1.25+:

```bash
go install github.com/soroworks/soroforge/cmd/soroforge@latest
```

## 2. Start Postgres

SoroForge records every deploy in Postgres. From a clone of the repository:

```bash
git clone https://github.com/soroworks/soroforge.git && cd soroforge
docker compose up -d     # Postgres on localhost:5432
make migrate-up          # create the schema
export DATABASE_URL=postgres://soroforge:soroforge@localhost:5432/soroforge?sslmode=disable
```

## 3. Describe your contracts

From your contract project, after `stellar contract build`:

```bash
soroforge init
```

`init` writes a `soroforge.yaml` with one alias per contract it finds under `target/wasm32v1-none/release` (or the older `wasm32-unknown-unknown`), targeting testnet. Open it and adjust anything you need — constructor arguments, a mainnet network, a `sorovault_url`.

## 4. Provide a key

```bash
export SOROFORGE_KEYSTORE_PATH=~/.config/soroforge/testnet.key   # a file containing only S...
```

Fund the account at <https://friendbot.stellar.org>. See [Configuration](configuration.md) before using a real key.

## 5. Dry-run, then deploy

```bash
soroforge deploy counter --dry-run       # simulates both transactions, submits nothing
soroforge deploy counter --notes "v1.0.0"
```

SoroForge uploads the WASM (skipped if it is already on-chain), instantiates the contract, and records the contract ID, WASM hash, deployer, transaction and ledger.

## 6. Check what is tracked

```bash
soroforge list
soroforge history counter
soroforge status counter     # exit 0 in sync, 2 if the chain disagrees with the record
soroforge status --all       # every tracked contract at once
```

## Next steps

- [Configuration](configuration.md) — key handling and multi-network setup
- [Concepts](concepts.md) — upgrades and drift detection
- [CLI & API reference](reference.md)
- [Using the tools together](../workflow.md) — register deploys in SoroVault automatically

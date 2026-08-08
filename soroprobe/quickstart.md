# Quickstart

Simulate a contract call and check a contract's health, with no database and no keys to sign. You need Go 1.22+ (or Docker) and a contract on testnet to point at.

> Commands and flags below reflect the intended design; confirm against your build's `--help` and README.

## 1. Build and run

```bash
git clone https://github.com/soroworks/SoroProbe.git
cd SoroProbe
make build
```

SoroProbe defaults to the public testnet RPC; no setup needed to start.

## 2. Simulate a call

Dry-run an invocation and see what would happen — result, success, and cost:

```bash
soroprobe simulate <contract_id> <function> [args...]
```

Add `--json` for machine-readable output.

## 3. Inspect contract state

Read the contract's on-chain entries and see how healthy they are — including how close anything is to expiring:

```bash
soroprobe inspect <contract_id>
```

## 4. Run a combined health check (CI-friendly)

```bash
soroprobe check <contract_id>
```

This confirms the contract is deployed, its code/instance is live and not near expiration, and a read-only call simulates successfully. It exits non-zero on failure, so you can drop it straight into a pipeline.

## Next steps

- [Concepts](concepts.md) — how simulation and expiration reporting work
- [CLI & API reference](reference.md)

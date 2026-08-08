# CLI & API reference

> Names and flags reflect the intended design; confirm against your build's `--help` and README.

## CLI

### `soroforge deploy <contract> --network <name> [--dry-run]`
Upload a contract's WASM and instantiate it on the target network, recording the result. `--dry-run` assembles without submitting.

### `soroforge upgrade <contract> --network <name> [--dry-run]`
Deploy new WASM for an existing tracked contract, recording the version transition.

### `soroforge list`
Show tracked contracts, grouped by network.

### `soroforge history <contract>`
Show the full deploy/upgrade history of one contract.

### `soroforge status <contract> --network <name>`
Drift check: compare the on-chain WASM hash against the tracked record. Exit non-zero on drift, so it works in CI.

Global flags typically include `--json` for machine-readable output and `--config` to point at a specific `soroforge.yaml`.

## HTTP API

The same operations are exposed over HTTP for pipeline integration:

- `GET /health` — process and RPC/DB reachability
- `GET /api/contracts` — tracked contracts
- `GET /api/contracts/{id}/history` — one contract's history
- `POST /api/deploy` / `POST /api/upgrade` — trigger operations from CI (with appropriate key handling)
- `GET /api/contracts/{id}/status` — drift check

## Exit codes

CLI commands intended for CI (`status`, and `deploy`/`upgrade` in non-dry-run) return non-zero on failure or drift, so pipelines can gate on them.

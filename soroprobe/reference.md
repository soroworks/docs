# CLI & API reference

> Names and flags reflect the intended design; confirm against your build's `--help` and README.

## CLI

### `soroprobe simulate <contract> <fn> [args...]`
Build and simulate an invocation. Prints whether it would succeed, the decoded return value, and estimated resource costs/fees. `--json` for scripting.

### `soroprobe inspect <contract>`
Read the contract's instance/code/data entries and report state health, flagging anything near expiration.

### `soroprobe check <contract>`
Combined health check (deployed, live, not near expiration, read-only call simulates). Exits non-zero on failure for CI.

## HTTP API

The same operations are available over HTTP for pipeline use:

- `GET /health` — process status and RPC reachability
- `POST /api/simulate` — simulate a call, returns result + costs
- `GET /api/contracts/{id}/inspect` — state health of a contract
- `GET /api/contracts/{id}/check` — combined check result

## Exit codes & output

`check` (and `simulate` on a failed simulation) return non-zero, so pipelines can gate on them. `--json` on the CLI returns structured output matching the API responses, so scripts and humans share one shape.

# CLI & API reference

## CLI

| Command | What it does |
|---|---|
| `soroforge init` | Write a starter `soroforge.yaml`, one alias per contract built under `target/`. Never overwrites without `--force`. |
| `soroforge deploy <alias>` | Upload the WASM (skipped if already on-chain), instantiate the contract, record it, and register it with the network's `sorovault_url` if set. |
| `soroforge upgrade <alias>` | Upload new WASM and invoke the contract's upgrade entrypoint (`upgrade_fn`, default `upgrade`). A no-op if the bytecode is unchanged. |
| `soroforge list` | Tracked contracts; `--network` filters. |
| `soroforge history <alias>` | Full deploy/upgrade timeline, newest first. |
| `soroforge status <alias>` | Compare the on-chain WASM hash with the recorded one. |
| `soroforge status --all` | The same check for every contract tracked on the network — one CI gate for all of them. |
| `soroforge serve` | Run the HTTP API. Requires `SOROFORGE_API_TOKEN`. |
| `soroforge migrate up\|down\|version` | Manage the schema. |
| `soroforge version` | Print the version. |

Global flags: `--config/-c`, `--network/-n`, `--log-level`, `--json`. Output goes to stdout and logs to stderr, so `--json` output stays pipeable.

`deploy` and `upgrade` take `--dry-run` and `--notes`. A dry run assembles and simulates every transaction, prints the envelopes and the resulting contract address, and submits, records and registers nothing — safe to point at mainnet.

### `status` exit codes

| Code | Meaning |
|---|---|
| `0` | `in_sync` — the chain matches the record (with `--all`: every contract) |
| `1` | The check could not be completed |
| `2` | `drift`, `untracked`, or `missing` on-chain (with `--all`: any contract) |

## HTTP API

Every `/v1` route requires `Authorization: Bearer $SOROFORGE_API_TOKEN`. The server binds `127.0.0.1:8080` by default because it holds a signing key.

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/health` | Liveness. No auth. |
| `POST` | `/v1/deploy` | `{"alias", "network", "notes", "dry_run"}` → `201` (`200` for a dry run) |
| `POST` | `/v1/upgrade` | Same body → `200` |
| `GET` | `/v1/contracts?network=` | Tracked contracts |
| `GET` | `/v1/contracts/{network}/{alias}/history` | Deployment history |
| `GET` | `/v1/contracts/{network}/{alias}/status` | Drift check |
| `GET` | `/v1/contracts/{network}/status` | Drift check of every tracked contract; `in_sync` is the verdict |

Unknown JSON fields are rejected, so a misspelled `dry_run` fails instead of deploying for real. Drift returns `200` with `"state": "drift"` — the check ran and produced an answer. Deploy and upgrade results carry a `catalog` field when a `sorovault_url` is configured, reporting whether SoroVault registration succeeded.

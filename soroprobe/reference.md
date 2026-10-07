# CLI & API reference

## CLI

### `soroprobe simulate <contract> <fn> [args...]`
Build and simulate an invocation: whether it would succeed, the decoded return value, resource cost, ledger footprint, and `RESTORE REQUIRED` if archived entries block it. A call the contract rejects is reported as `FAILED` and **exits 0** — it is an answer, not a tool error. Use `check` for a non-zero exit.

### `soroprobe inspect <contract>`
Report expiration health of the contract's instance and code entries, and any data entries named with `--key` (repeatable, `type:value`). `--durability persistent|temporary`.

### `soroprobe check <contract>`
Combined check for CI, in order: `deployed`, `instance_ttl`, `code_ttl`, any `data_ttl`, then `simulate` when `--fn` is given (`--arg` repeatable). A TTL warning does not fail the check; `critical`, `expired` and `missing` do.

| Exit code | Meaning |
|---|---|
| `0` | All checks passed |
| `1` | A check failed — the contract has a problem |
| `2` | SoroProbe could not run — bad input, or RPC unreachable |

### `soroprobe serve`
Run the HTTP API. `--addr` overrides `HTTP_ADDR`.

Global flags: `--json`, `--config`, `--rpc-url`, `--network-passphrase`, `--source-account`, `--log-level`, `--timeout`, `--warn-ledgers`, `--critical-ledgers`, `--sorovault-url`.

## Arguments

Arguments are `type:value` — `u32:5`, `i128:-100`, `sym:transfer`, `str:"hi"`, `bytes:deadbeef`, `addr:G…`. Collections are JSON:

```bash
soroprobe simulate CDEF… set_weights 'map:[["sym:alice", "u32:3"], ["sym:bob", "u32:1"]]'
soroprobe simulate CDEF… batch 'vec:["u32:1", "u32:2"]'
```

A bare value is inferred (digits become `i128`). With `--sorovault-url`, bare values — including collection elements — are typed from the contract's interface instead, and an unknown function or wrong argument count is rejected before simulating.

## HTTP API

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/healthz` | Liveness. Does not call the network. |
| `POST` | `/v1/simulate` | `{"contract_id", "function", "args"}` |
| `GET` | `/v1/inspect/{contract}` | `?key=` (repeatable), `?durability=` |
| `GET` | `/v1/check/{contract}` | `?fn=`, `?arg=`, `?key=`, `?durability=` |

The API is read-only; no route submits anything. A contract that fails its check still returns **200** — read `success` / `ok` in the body. `400` is bad input (including an unknown function or wrong argument count when typing from SoroVault); `502` is an upstream RPC failure.

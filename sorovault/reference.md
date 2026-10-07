# API & CLI reference

## CLI

| Command | What it does |
|---|---|
| `sorovault add <contract_id>...` | Fetch, decode and register one or more contracts. Failures are reported per contract. |
| `sorovault refresh <contract_id>...` | Re-check registered contracts; an upgrade records a new interface version. |
| `sorovault list` | List contracts. `-q` searches IDs, names, and function, type and event names; `--network`, `--limit`, `--offset`. |
| `sorovault get <contract_id>` | Print a decoded interface. `--function`, `--wasm-hash`, `--json`. |
| `sorovault codegen <contract_id>` | Generate a typed TypeScript client from the stored interface. `-o`, `--wasm-hash`. |
| `sorovault serve` | Serve the JSON API and browse UI. Runs automatic refresh when `REFRESH_INTERVAL` is set. |
| `sorovault migrate` | Apply schema migrations. |

Every read command takes `--json`, which prints exactly what the API serves.

## HTTP API

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/healthz` | Liveness. Does not touch the database or RPC. |
| `GET` | `/api/contracts` | List contracts — `?q=`, `?network=`, `?limit=`, `?offset=` |
| `POST` | `/api/contracts` | Register — `{"contract_id": "C…"}`. `201` if new, `200` if already known. |
| `GET` | `/api/contracts/{id}` | The decoded ABI — `?network=`, `?wasm_hash=` |
| `GET` | `/api/contracts/{id}/functions/{fn}` | One function, with its signature |
| `GET` | `/api/contracts/{id}/versions` | Every stored interface version |
| `POST` | `/api/contracts/{id}/refresh` | Re-check against the network |
| `GET` | `/api/contracts/{id}/client.ts` | Typed TypeScript client — `?wasm_hash=`, `?download=1` |

**Status codes.** `404` means the contract is not there; `422` means it exists but has no interface to serve (a Stellar asset contract, or a module without a spec section); `503` means the RPC endpoint serves a different network than configured.

### Search

`?q=` is a case-insensitive substring match against the contract ID, its name, and the names of the functions, types and events in its **current** interface. Results report which symbols matched:

```json
{ "contract_id": "CDZZ…4PAN", "network": "testnet", "matches": ["has_voted", "vote"] }
```

## The ABI JSON shape

The decoded interface is the project's public contract; `abi_version` is bumped if it ever changes incompatibly. Every type is an object with a `kind` and a human-readable `display` (`"Option<Vec<u32>>"`); containers add the fields they need (`inner`, `element`, `key`/`value`, `ok`/`error`, `elements`, `n`, `name`). Empty collections are `[]`, never `null`. The full schema is in the [SoroVault README](https://github.com/soroworks/sorovault#the-abi-json).

## Typed clients

`client.ts` declares every struct, union and enum, an `Errors` code table, and a `Client` interface with one method per contract function. `connect()` returns `@stellar/stellar-sdk`'s `contract.Client` narrowed to it:

```ts
import { connect } from "./zkvote";

const client = await connect({
  rpcUrl: "https://soroban-testnet.stellar.org",
  networkPassphrase: "Test SDF Network ; September 2015",
});
const tx = await client.get_proposal({ index: 0 }); // typed args and result
```

CI compiles a generated client with `tsc --strict` against a pinned SDK on every change.

## Web UI

- `/` — searchable contract list, showing which symbols matched
- `/contracts/{id}` — a contract's decoded interface, version history, and a link to its typed client

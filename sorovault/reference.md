# API & CLI reference

> Names and shapes reflect the intended design; confirm against your build's README and code.

## CLI

### `sorovault add <contract_id>`
Fetch, decode, and register a contract's interface.

### `sorovault list`
List registered contracts.

### `sorovault get <contract_id>`
Print a contract's decoded interface.

## HTTP API

### `GET /health`
Process status and RPC/DB reachability.

### `POST /api/contracts`
Register a contract by ID (fetches WASM, decodes spec, stores it).

### `GET /api/contracts`
List registered contracts. Searchable by contract ID; paginated.

### `GET /api/contracts/{id}`
The contract's decoded interface: functions (name, inputs, outputs) and user-defined types, as clean JSON — a usable ABI.

### `GET /api/contracts/{id}/functions/{fn}`
One function's signature in detail.

## The ABI JSON shape

The decoded interface is returned as structured JSON describing each function's name, its typed inputs and outputs, and any user-defined types referenced. This shape is intended to be stable and consumable by other tooling (client generators, validators, UIs). The exact schema is documented alongside the API so downstream tools can rely on it.

## Web UI

- `/` — searchable contracts list
- `/contracts/{id}` — a contract's decoded interface, browsable

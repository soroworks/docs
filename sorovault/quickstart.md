# Quickstart

Register a deployed contract and browse its decoded interface. You need Go 1.22+ (or Docker), a Postgres instance, and a contract ID on testnet.

> Commands and flags below reflect the intended design; confirm against your build's `--help` and README.

## 1. Start the stack

```bash
git clone https://github.com/soroworks/SoroVault.git
cd SoroVault
cp .env.example .env      # set RPC_URL and DATABASE_URL
docker compose up -d      # SoroVault + Postgres
```

## 2. Register a contract

Fetch its WASM, decode its interface, and store it:

```bash
sorovault add <contract_id>
```

Or over HTTP:

```bash
curl -X POST http://localhost:8080/api/contracts \
  -H 'Content-Type: application/json' \
  -d '{"contract_id": "CC..."}'
```

## 3. Browse the interface

Open `http://localhost:8080` for the searchable contracts list and per-contract interface views, or query the API:

```bash
# every registered contract
curl 'http://localhost:8080/api/contracts'

# one contract's decoded interface (a usable ABI)
curl 'http://localhost:8080/api/contracts/CC...'

# one function's signature in detail
curl 'http://localhost:8080/api/contracts/CC.../functions/transfer'
```

## Next steps

- [Concepts](concepts.md) — spec decoding and version history
- [API & CLI reference](reference.md)

# Quickstart

Register a deployed contract and browse its decoded interface. You need Docker.

## 1. Start the stack

```bash
git clone https://github.com/soroworks/sorovault.git && cd sorovault
make up        # Postgres, migrations, and the server on :8080
```

It targets testnet by default. Set `RPC_URL` and `NETWORK_PASSPHRASE` for another network, and `REFRESH_INTERVAL=6h` to re-check registered contracts for upgrades automatically.

## 2. Register a contract

```bash
curl -X POST localhost:8080/api/contracts \
  -H 'content-type: application/json' \
  -d '{"contract_id":"CDZZXVGUCLBUTE3WDD6TF2NXPTBPOYTVPPBBIZMSPVIQLUG226XJ4PAN"}'
```

SoroVault fetches the contract's WASM, decodes the interface embedded in it, and stores it versioned by WASM hash. `201` means newly registered, `200` already known. The CLI equivalent is `sorovault add <contract_id>`.

## 3. Browse it

Open <http://localhost:8080> for the searchable list — search matches function, type and event names too — or query the API:

```bash
curl -s localhost:8080/api/contracts/CDZZ…4PAN | jq '.interface.functions[].name'
curl -s localhost:8080/api/contracts/CDZZ…4PAN/functions/has_voted | jq .signature
curl -s 'localhost:8080/api/contracts?q=vote'
```

## 4. Generate a typed client

```bash
curl -s localhost:8080/api/contracts/CDZZ…4PAN/client.ts > zkvote.ts
```

The file is a typed TypeScript client for `@stellar/stellar-sdk`. The full API is described at `/api/openapi.json`.

## Next steps

- [Concepts](concepts.md) — spec decoding and version history
- [Configuration](configuration.md)
- [API & CLI reference](reference.md)

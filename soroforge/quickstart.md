# Quickstart

Deploy a contract to testnet and see it tracked. You need Go 1.22+ (or Docker), a Postgres instance, a compiled contract WASM, and a funded testnet key.

> Commands and flags below reflect the intended design; confirm exact names against your build's `--help` output and README.

## 1. Start the stack

```bash
git clone https://github.com/soroworks/SoroForge.git
cd SoroForge
cp .env.example .env      # set DATABASE_URL and your deployer key handling
docker compose up -d      # brings up Postgres
make migrate
```

## 2. Describe your networks and contracts

Edit `soroforge.yaml`:

```yaml
networks:
  testnet:
    rpc_url: https://soroban-testnet.stellar.org
    passphrase: "Test SDF Network ; September 2015"

contracts:
  my-token:
    wasm: ./build/my_token.wasm
```

## 3. Dry-run first

Assemble the deployment transaction without submitting it, to inspect what would happen:

```bash
soroforge deploy my-token --network testnet --dry-run
```

## 4. Deploy for real

```bash
soroforge deploy my-token --network testnet
```

SoroForge uploads the WASM, instantiates the contract, and records the resulting contract ID, WASM hash, deployer, transaction hash, and ledger.

## 5. Inspect what's tracked

```bash
soroforge list
soroforge history my-token
soroforge status my-token --network testnet   # drift check: on-chain vs tracked
```

## Next steps

- [Configuration](configuration.md) — key handling and multi-network setup
- [Concepts](concepts.md) — upgrades and drift detection
- [CLI & API reference](reference.md)

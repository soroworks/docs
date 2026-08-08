# Configuration

SoroForge is configured through a project file (`soroforge.yaml`) plus environment variables.

## soroforge.yaml

Describes your networks and the contracts you manage.

```yaml
networks:
  testnet:
    rpc_url: https://soroban-testnet.stellar.org
    passphrase: "Test SDF Network ; September 2015"
  mainnet:
    rpc_url: https://your-mainnet-rpc-provider.example.com
    passphrase: "Public Global Stellar Network ; September 2015"

contracts:
  my-token:
    wasm: ./build/my_token.wasm
    # optional constructor/init args
```

## Environment variables

| Variable | Description |
|---|---|
| `DATABASE_URL` | Postgres connection string for the deployment history. |
| (deployer key) | The secret key used to sign deploy/upgrade transactions — supplied via an env var or a keystore path. See key handling below. |
| `HTTP_ADDR` | Listen address for the HTTP API (CI use). |
| `LOG_LEVEL` | `debug`, `info`, `warn`, or `error`. |

## Key handling (read this)

Deploying and upgrading are signed, on-chain actions, so SoroForge needs a signing key. Two rules matter:

1. **Keys are never committed or logged.** Supply the deployer secret key through an environment variable or a keystore file path — never inline in `soroforge.yaml`, and never checked into git. SoroForge does not print secret keys.
2. **Use dry-run to rehearse.** `--dry-run` assembles the transaction without submitting it, so you can verify exactly what would happen before any key signs anything or any fee is spent — especially important before touching mainnet.

## Networks

Every deployment record is namespaced by network, so the same contract alias can be tracked independently on testnet and mainnet. Use a dedicated, reliable RPC provider for mainnet — deployment correctness depends on the RPC.

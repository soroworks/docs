# Configuration

SoroForge is configured through a project file (`soroforge.yaml`) plus environment variables. The file holds what is shareable and belongs in version control; secrets come only from the environment.

## soroforge.yaml

```yaml
version: 1                  # schema version; only 1 exists
default_network: testnet    # used when --network is omitted

networks:
  testnet:
    rpc_url: https://soroban-testnet.stellar.org
    passphrase: "Test SDF Network ; September 2015"
    sorovault_url: http://localhost:8080   # optional, see below
  mainnet:
    rpc_url: https://your-mainnet-rpc-provider.example.com
    passphrase: "Public Global Stellar Network ; September 2015"

contracts:
  counter:
    wasm: ./target/wasm32-unknown-unknown/release/counter.wasm
    constructor_args: []    # optional, typed — see the README
    upgrade_fn: upgrade     # optional, defaults to "upgrade"
    salt: ""                # optional 32-byte hex, for a reproducible address
```

Unknown keys are rejected, so a typo is a loud error rather than a silently ignored setting. `wasm` paths resolve against the config file's directory, not your shell's.

### `sorovault_url`

When a network names a [SoroVault](../sorovault/README.md) registry, every **confirmed** deploy and upgrade on that network is registered there, so the contract's interface is discoverable the moment it is live. Registration is best-effort: if the registry is unreachable the deploy still succeeds and is recorded, and the result's `catalog` field reports the failure. Dry runs never register.

## Environment variables

| Variable | Description |
|---|---|
| `DATABASE_URL` | Postgres connection string for the deployment history. Required except for `deploy --dry-run`. |
| `SOROFORGE_SECRET_KEY` | Deployer secret seed (`S...`). |
| `SOROFORGE_KEYSTORE_PATH` | Path to a file containing only the seed. The environment variable wins if both are set. |
| `SOROFORGE_API_TOKEN` | Bearer token for `serve`; the server refuses to start without one (minimum 16 characters). |
| `SOROFORGE_API_ADDR` | Listen address for `serve`. Defaults to `127.0.0.1:8080`. |
| `SOROFORGE_CONFIG` | Config file path. Defaults to `./soroforge.yaml`. |
| `TEST_DATABASE_URL` | Enables the Postgres integration tests. |
| `SOROFORGE_LIVE` | Enables the read-only live testnet smoke tests. |

## Key handling (read this)

Deploying and upgrading are signed, on-chain actions, so SoroForge needs a signing key.

1. **Keys are never committed or logged.** SoroForge passes the seed straight into a signer and records only the derived public address. It never logs it, stores it, or echoes it in an error — even a malformed seed is treated as a secret.
2. **Prefer a keystore file at mode `0600`** locally; use your CI provider's secret store in pipelines. Use a separate key per network.
3. **Rehearse with `--dry-run`.** It assembles and simulates both transactions and prints the resulting contract address, without signing, submitting or recording anything — safe to point at mainnet.

## Networks

Every deployment record is namespaced by network, so the same alias is tracked independently on testnet and mainnet. The passphrase is required rather than inferred from the network name, because it is mixed into every signature. There is no public SDF-hosted mainnet RPC; use a provider you trust.

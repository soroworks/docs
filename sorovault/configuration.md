# Configuration

SoroVault is configured through environment variables.

| Variable | Default | Description |
|---|---|---|
| `RPC_URL` | `https://soroban-testnet.stellar.org` | Stellar RPC endpoint. Point at a provider URL for mainnet. |
| `NETWORK_PASSPHRASE` | testnet passphrase | The network passphrase matching the RPC. |
| `DATABASE_URL` | — (required) | Postgres connection string for the registry. |
| `HTTP_ADDR` | `:8080` | Listen address for the API and browse UI. |
| `LOG_LEVEL` | `info` | `debug`, `info`, `warn`, or `error`. |

## Multi-network

Registry records are namespaced by network, so the same contract ID can be tracked independently on testnet and mainnet, each with its own decoded interface and version history.

## Choosing an endpoint

- **Testnet**: the public endpoint works out of the box.
- **Mainnet**: use a dedicated provider URL — registering a contract fetches its WASM over RPC, so reliability matters.

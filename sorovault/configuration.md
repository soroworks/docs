# Configuration

SoroVault is configured entirely through environment variables. Only `DATABASE_URL` is required.

| Variable | Default | Description |
|---|---|---|
| `DATABASE_URL` | — (required) | Postgres connection string for the registry. |
| `RPC_URL` | `https://soroban-testnet.stellar.org` | Stellar RPC endpoint contract code is read from. |
| `NETWORK_PASSPHRASE` | testnet passphrase | The network you expect `RPC_URL` to serve. |
| `HTTP_ADDR` | `:8080` | Listen address for the API and browse UI. |
| `LOG_LEVEL` | `info` | `debug`, `info`, `warn`, or `error`. |
| `RPC_TIMEOUT` | `30s` | Bound on a single contract fetch. |
| `REFRESH_INTERVAL` | `0` (off) | Re-check registered contracts for upgrades this often while serving. Minimum `1m`. |

## The passphrase is a guard

`NETWORK_PASSPHRASE` is not a source of truth. SoroVault reads the real passphrase from the RPC endpoint and refuses to proceed if the two disagree, so a stale `RPC_URL` cannot quietly file mainnet contracts under `testnet`.

## Automatic refresh

With `REFRESH_INTERVAL` set (for example `6h`), `sorovault serve` re-checks every contract on its network that has not been refreshed within the interval. An upgraded contract gets a new interface version, and the old one is kept; an unchanged contract costs a single ledger-entry read and is not re-downloaded. A contract that fails to refresh is logged and skipped, and the sweep carries on.

## Multi-network

Registry records are namespaced by network, so the same contract ID is tracked independently on testnet and mainnet, each with its own interface and version history. Run one SoroVault per network you catalog.

## Choosing an endpoint

- **Testnet**: the public endpoint works out of the box.
- **Mainnet**: use a dedicated provider URL — registering a contract fetches its WASM over RPC, so reliability matters.

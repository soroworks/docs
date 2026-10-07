# Configuration

SoroProbe needs no database — it is stateless. Settings resolve in this order, lowest to highest: **defaults → config file → environment → flags**.

| Variable | Flag | Default | Description |
|---|---|---|---|
| `RPC_URL` | `--rpc-url` | `https://soroban-testnet.stellar.org` | Stellar RPC endpoint. |
| `NETWORK_PASSPHRASE` | `--network-passphrase` | testnet passphrase | The network the RPC serves. |
| `SOURCE_ACCOUNT` | `--source-account` | all-zero placeholder | Public key used to build transactions for simulation. |
| `HTTP_ADDR` | `--addr` (on `serve`) | `:8080` | Listen address for the HTTP API. |
| `LOG_LEVEL` | `--log-level` | `info` | `debug`, `info`, `warn`, or `error`. |
| `RPC_TIMEOUT` | `--timeout` | `30s` | Per-request RPC timeout. |
| `WARN_LEDGERS` | `--warn-ledgers` | `120960` (≈7 days) | TTL below which an entry is a warning. |
| `CRITICAL_LEDGERS` | `--critical-ledgers` | `17280` (≈1 day) | TTL below which an entry is critical. |
| `SOROVAULT_URL` | `--sorovault-url` | unset | A SoroVault registry used to type simulate arguments. |
| `SOROPROBE_CONFIG` | `--config` | `./soroprobe.json` if present | JSON config file with snake_case keys. |

## On the source account

Building a transaction requires a source account, but **simulation does not require signing**. SoroProbe asks for a public key, and only a public key: configuration validation rejects anything that is not a valid `G...` ed25519 public key, so pasting a secret key fails immediately. The account need not exist or hold a balance. Set a real one only when a contract authorizes on the invoker's address.

## Typing arguments from SoroVault

With `SOROVAULT_URL` set, SoroProbe reads the contract's interface from the registry and gives each untyped argument the type the function declares — so a bare `5` becomes the `u32` the contract expects instead of an inferred `i128`. It also rejects an unknown function name or a wrong argument count before simulating. If the contract is not registered, or the registry is unreachable, SoroProbe falls back to inference and says so in an `abi_note`.

## Choosing an endpoint

- **Testnet**: the public endpoint works out of the box.
- **Mainnet**: use a dedicated provider URL for reliable simulation of live contracts.

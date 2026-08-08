# Configuration

SoroProbe is configured through environment variables and flags. It needs no database — it's stateless.

| Variable | Default | Description |
|---|---|---|
| `RPC_URL` | `https://soroban-testnet.stellar.org` | Stellar RPC endpoint. Point at a provider URL for mainnet. |
| `NETWORK_PASSPHRASE` | testnet passphrase | The network passphrase matching the RPC. |
| `HTTP_ADDR` | `:8080` | Listen address for the HTTP API (mirrors the CLI). |
| `LOG_LEVEL` | `info` | `debug`, `info`, `warn`, or `error`. |
| (source account) | — | A public key used as the source account when building a transaction to simulate. |

## On the source account

Building a transaction to simulate requires a source account, but **simulation does not require signing** — SoroProbe uses a provided public key and never needs a secret key just to simulate. If your build asks for a secret key merely to run `simulate`, that's a bug worth filing. This read-only, no-signing posture is deliberate: SoroProbe should be safe to run anywhere, against anything, without risk.

## Choosing an endpoint

- **Testnet**: the public endpoint works out of the box, rate-limited to roughly 10 requests/second.
- **Mainnet**: use a dedicated provider URL for reliable simulation of live contracts.

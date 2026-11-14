# Security model across the three tools

SoroForge, SoroVault and SoroProbe occupy distinct positions in a Soroban deployment pipeline, and each holds a different level of privilege:

- **[SoroForge](soroforge/README.md)** signs and submits on-chain transactions, holds a deployer secret seed, and writes deployment records to Postgres.
- **[SoroVault](sorovault/README.md)** is read-only on-chain (it never holds keys or submits transactions), parses untrusted contract WASM from Stellar RPC, and writes decoded interfaces to Postgres.
- **[SoroProbe](soroprobe/README.md)** is stateless and read-only on-chain (it holds neither keys nor a database), simulates contract invocations, and spends RPC quota.

This page summarizes what each tool holds, what input it trusts, its default network exposure, its built-in protections, and the recommended controls when running the suite in production.

---

## Trust and exposure overview

| Dimension | [SoroForge](soroforge/README.md) | [SoroVault](sorovault/README.md) | [SoroProbe](soroprobe/README.md) |
|---|---|---|---|
| **On-chain capability** | Signs and submits WASM uploads, contract instantiations and upgrades | Read-only ledger entry fetches (`getLedgerEntries`, `getNetwork`) | Read-only ledger entry fetches and `simulateTransaction` |
| **Secret material held** | Deployer secret seed (`SOROFORGE_SECRET_KEY` or `SOROFORGE_KEYSTORE_PATH`) and `SOROFORGE_API_TOKEN` | Database credentials in `DATABASE_URL` | None (validates `SOURCE_ACCOUNT` is a public `G...` key) |
| **Persistent state** | Postgres (`contracts` and `deployments` tables) | Postgres (`contracts` and `contract_versions` tables) | Stateless (no database) |
| **Default listen address** | `127.0.0.1:8080` (`SOROFORGE_API_ADDR`) | `:8080` (`HTTP_ADDR`) | `:8080` (`HTTP_ADDR` / `--addr`) |
| **HTTP authentication** | Required on every `/v1` route (`Authorization: Bearer $SOROFORGE_API_TOKEN`, minimum 16 chars) | Unauthenticated (`GET` browse/query and `POST` register/refresh) | Unauthenticated (read-only simulation and health checks) |

---

## SoroForge — deployment and upgrade authority

Because SoroForge signs transactions that upload bytecode, instantiate contracts, and invoke upgrade entrypoints, it has the highest privilege of the three tools.

### What it holds

- **Deployer signing seed**: supplied via `SOROFORGE_SECRET_KEY` or a file at `SOROFORGE_KEYSTORE_PATH` (see [SoroForge configuration](soroforge/configuration.md)).
- **API bearer token**: supplied via `SOROFORGE_API_TOKEN` when running `soroforge serve`.
- **Database credentials**: supplied via `DATABASE_URL` for recording deployments.

### Trust boundaries and built-in protections

- **Secrets never touch config files, logs, or the database.** `soroforge.yaml` holds only shareable settings (`rpc_url`, `passphrase`, `wasm` paths, constructor arguments). The secret seed is passed directly to the signer in memory; only the derived `G...` public key is stored in deployment records. Even a malformed seed is redacted from error messages so secrets never leak into CI logs.
- **Loopback-only binding by default.** `soroforge serve` binds `127.0.0.1:8080` unless `SOROFORGE_API_ADDR` is explicitly changed.
- **Mandatory bearer token on the HTTP server.** `soroforge serve` refuses to start if `SOROFORGE_API_TOKEN` is unset or shorter than 16 characters. Every `/v1` route requires `Authorization: Bearer <token>`; only `GET /health` is unauthenticated.
- **Strict schema parsing.** Unknown fields in `soroforge.yaml` and HTTP JSON request bodies are rejected (`400 Bad Request`). A mistyped `"dry_run"` field fails closed instead of silently executing a live deployment.
- **Explicit network passphrases.** Each network block in `soroforge.yaml` must state its `passphrase` explicitly rather than inferring it from the network alias, because the passphrase is mixed directly into every transaction signature.
- **Rehearsal without keys or writes.** `--dry-run` (and `"dry_run": true` on the API) assembles and simulates the upload and instantiation/upgrade transactions without signing, submitting, writing to Postgres, or calling SoroVault.

---

## SoroVault — untrusted WASM decoding and catalog

SoroVault never signs or submits transactions, but it fetches arbitrary contract bytecode from Stellar RPC, decodes XDR spec sections (`contractspecv0`), and stores the resulting ABI in Postgres.

### What it holds

- **Database credentials**: `DATABASE_URL` for reading and writing the interface registry (see [SoroVault configuration](sorovault/configuration.md)).
- **No signing keys**: SoroVault is strictly a reader of the chain.

### Trust boundaries and built-in protections

- **Untrusted WASM is parsed, never executed.** When registering or refreshing a contract, SoroVault extracts and decodes the static XDR metadata sections embedded in the WASM binary. It never instantiates or executes WASM instructions.
- **Network passphrase guard.** Before filing a contract under a configured network name, SoroVault queries the RPC endpoint's live network passphrase and compares it to `NETWORK_PASSPHRASE`. If they disagree, SoroVault refuses to proceed (returning `503` on the API) so a misconfigured `RPC_URL` cannot pollute a `testnet` catalog with `mainnet` contracts or vice versa.
- **Immutable version history.** Each decoded interface version is keyed by `(network, contract_id, wasm_hash)`. Refreshing an upgraded contract inserts a new version and updates the current pointer without overwriting prior versions, preserving an audit trail of ABI changes.
- **Bounded RPC fetches.** Every contract fetch is bounded by `RPC_TIMEOUT` (default `30s`), and background refresh sweeps require `REFRESH_INTERVAL` to be at least `1m`.
- **Unauthenticated write endpoints by default.** `sorovault serve` binds `:8080` and accepts `POST /api/contracts` and `POST /api/contracts/{id}/refresh` without authentication (see [SoroVault reference](sorovault/reference.md)). Anyone who can reach the HTTP port can trigger an RPC fetch and register a contract that exists on the configured network.

---

## SoroProbe — stateless simulation and state-expiry checks

SoroProbe is the lowest-privilege component: it has no database and never writes to the chain or to disk.

### What it holds

- **No secrets and no database.** All configuration is public RPC settings and TTL thresholds (see [SoroProbe configuration](soroprobe/configuration.md)).

### Trust boundaries and built-in protections

- **Secret keys are rejected at configuration time.** Building a transaction envelope for `simulateTransaction` requires a `SOURCE_ACCOUNT` address, not a signature. SoroProbe validates that `SOURCE_ACCOUNT` is a valid `G...` ed25519 public key (defaulting to the all-zero placeholder account) and immediately rejects `S...` secret seeds if pasted by mistake.
- **Read-only HTTP API with bounded batch size.** `soroprobe serve` binds `:8080` and exposes `/v1/simulate`, `/v1/inspect/{contract}`, `/v1/check/{contract}`, and `/v1/checks` (see [SoroProbe reference](soroprobe/reference.md)). Batch requests to `POST /v1/checks` are capped at 20 checks per request, and each RPC call is bounded by `RPC_TIMEOUT` (default `30s`).
- **Safe fallback when typing from SoroVault.** When `SOROVAULT_URL` is configured, SoroProbe fetches the target contract's ABI to validate function names, argument counts, and parameter types before simulating. If SoroVault is unreachable or the contract is unregistered, SoroProbe falls back to local argument inference and records the fallback in `abi_note`.

---

## Recommended deployment controls

1. **Isolate deployer keys per network in SoroForge.** Never reuse a testnet secret seed on mainnet. Store seeds in a mode-`0600` file via `SOROFORGE_KEYSTORE_PATH` on dedicated hosts or in your CI secret manager, and always rehearse mainnet changes with `--dry-run` first.
2. **Keep `soroforge serve` on loopback or behind mTLS.** Leave `SOROFORGE_API_ADDR` on `127.0.0.1:8080` unless an authenticated reverse proxy fronts it, and generate a high-entropy `SOROFORGE_API_TOKEN` (at least 32 random bytes).
3. **Restrict network access or gate `POST` routes on SoroVault and SoroProbe.** Because `sorovault serve` and `soroprobe serve` bind `:8080` without built-in authentication and each request triggers upstream Stellar RPC calls, place them on an internal network or behind a reverse proxy that rate-limits requests and restricts `POST /api/contracts` and `POST /api/contracts/{id}/refresh` to trusted callers (such as SoroForge and CI runners).
4. **Use least-privilege Postgres roles.** Give SoroForge and SoroVault separate databases (or separate roles scoped to their own tables) and require TLS (`sslmode=verify-full`) when connecting over a network.
5. **Pin dedicated RPC endpoints for mainnet.** Public RPC endpoints are suitable for testnet, but mainnet deployments, ABI refreshes, and CI health gates should use a dedicated RPC provider with TLS and known rate limits.

---

## Reporting a vulnerability

If you discover a security vulnerability in SoroForge, SoroVault, SoroProbe or their documentation, please report it privately rather than opening a public issue. Follow the instructions in the [SoroWorks security policy](https://github.com/soroworks/.github/blob/main/SECURITY.md) or use GitHub's private vulnerability reporting on the affected repository.

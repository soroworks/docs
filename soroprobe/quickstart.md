# Quickstart

Simulate a contract call and check a contract's health — no database, no keys, no configuration. Everything below runs against the public testnet; the contract used is the testnet native-asset contract.

## 1. Install

Download a binary from the [latest release](https://github.com/soroworks/soroprobe/releases/latest), or build with Go 1.25+:

```bash
go install github.com/soroworks/soroprobe/cmd/soroprobe@latest
```

## 2. Simulate a call

```bash
soroprobe simulate CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC decimals
```

You get whether the call would succeed, the decoded return value (`7`), its resource cost and fee, and the ledger entries it would touch. A call the contract rejects is reported as `FAILED` with the host's error and still exits 0 — it is an answer, not a tool error. Add `--json` for scripting.

## 3. Inspect state health

```bash
soroprobe inspect CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC
```

This reports how close the contract's instance and code entries are to expiring, in ledgers and approximate time. Name data entries to include with `--key sym:Admin`.

## 4. Gate CI on it

```bash
soroprobe check CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC --fn decimals
echo $?    # 0 pass, 1 unhealthy, 2 SoroProbe could not run
```

For several contracts, list them in a file and run `soroprobe check --file checks.json`.

## 5. Optional: type arguments from SoroVault

If you run [SoroVault](../sorovault/README.md), point SoroProbe at it and bare arguments are encoded as the types the function declares, instead of guessed:

```bash
export SOROVAULT_URL=http://localhost:8080
```

## Next steps

- [Concepts](concepts.md) — how simulation and expiration reporting work
- [Configuration](configuration.md)
- [CLI & API reference](reference.md)

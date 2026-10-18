# Soroban glossary

This glossary explains the Soroban terms that appear in SoroForge, SoroProbe, and SoroVault output and configuration. Each entry points to the SoroWorks command or page where the term is most visible and links to the Stellar documentation for protocol-level details.

## Archival and restoration

A Soroban entry becomes archived when its lifetime ends; Temporary entries are deleted, while Persistent and Instance entries can be restored before a transaction uses them. SoroProbe surfaces this lifecycle through `inspect`, `check`, and the `RESTORE REQUIRED` result from `simulate`; see the [state archival guide](https://developers.stellar.org/docs/learn/fundamentals/contract-development/storage/state-archival).

## Code entry

A code entry stores the contract's WebAssembly bytecode on the network. SoroProbe reports its expiration health with `inspect`, while SoroForge records and checks the deployed code identity with `status`; the [WASM upload guide](https://developers.stellar.org/docs/build/guides/transactions/upload-wasm-bytecode) explains how bytecode is identified.

## Contract spec (`contractspecv0`)

A contract spec is the machine-readable interface embedded in a contract's WASM, including functions, types, errors, and events; `contractspecv0` is the versioned Soroban spec representation that tooling decodes. SoroVault reads it with `add`/`refresh`, and SoroProbe can use the registered interface to type otherwise bare arguments; see [working with contract specs](https://developers.stellar.org/docs/build/guides/dapps/working-with-contract-specs).

## Data entry

A data entry is contract state stored under a key, with a durability class such as Persistent or Temporary. SoroProbe exposes named data entries through `inspect --key` and `check --key`, with `--durability` selecting the class; the [storage guide](https://developers.stellar.org/docs/build/guides/storage/choosing-the-right-storage) compares the available choices.

## Instance entry

An Instance entry stores a contract's instance-level state and metadata, separate from the contract's WASM code and ordinary data entries. SoroProbe includes the instance entry in `inspect` and `check` expiration reports; Stellar's [state archival guide](https://developers.stellar.org/docs/learn/fundamentals/contract-development/storage/state-archival) describes how Instance storage is accessed.

## Live-until ledger (`liveUntilLedgerSeq`)

An entry remains live through its `liveUntilLedgerSeq` boundary; its TTL is the number of ledgers between the current ledger and that boundary, rather than a wall-clock duration. SoroProbe surfaces the resulting expiration health through `inspect` and the `instance_ttl`, `code_ttl`, and `data_ttl` values reported by `check`; see Stellar's [state archival guide](https://developers.stellar.org/docs/learn/fundamentals/contract-development/storage/state-archival).

## Network passphrase

A network passphrase names a Stellar network and is used when deriving the network ID and validating transaction signatures, so a transaction for one network cannot be reused on another. SoroForge, SoroProbe, and SoroVault accept it in their network configuration or command flags; compare the [network documentation](https://developers.stellar.org/docs/networks) before switching between networks.

## Persistent storage

Persistent storage is intended for contract state that should remain available across periods without access. When its TTL expires it is archived rather than immediately deleted, and SoroProbe selects it with `--durability persistent` when inspecting or checking a data key; see [choosing storage](https://developers.stellar.org/docs/build/guides/storage/choosing-the-right-storage).

## Stellar Asset Contract (SAC)

A Stellar Asset Contract is the Soroban contract representation of a Stellar asset and implements the SEP-41 token interface. SoroProbe can inspect or simulate its read-only behavior and reports that it has no code entry. A SAC is built into the host rather than deployed as WASM, so it carries no embedded spec and SoroVault answers `422` for it; the [SAC guide](https://developers.stellar.org/docs/build/guides/tokens/stellar-asset-contract) covers the standard.

## Temporary storage

Temporary storage is for state that may be discarded when its TTL ends; unlike Persistent and Instance entries, an expired Temporary entry is deleted instead of archived for restoration. SoroProbe selects it with `--durability temporary` when inspecting or checking a data key; see [choosing storage](https://developers.stellar.org/docs/build/guides/storage/choosing-the-right-storage).

## Time to live (TTL)

TTL is the number of ledgers for which an entry remains live, not a wall-clock duration. SoroProbe reports TTL and approximate time in `inspect` and uses it in `check` health gates; the [state archival guide](https://developers.stellar.org/docs/learn/fundamentals/contract-development/storage/state-archival) explains the live-until boundary.

## WASM hash

The WASM hash is the SHA-256 digest of a contract's WebAssembly bytecode and identifies the exact code that was uploaded. SoroForge records it and compares it with the chain in `status`, while SoroVault versions a decoded interface by WASM hash; see [uploading WASM bytecode](https://developers.stellar.org/docs/build/guides/transactions/upload-wasm-bytecode).

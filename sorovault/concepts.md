# Concepts

## Contract interfaces (specs)

Every Soroban contract's WASM carries a **spec**: a machine-readable description of the functions it exposes — their names, arguments, and return types — along with any user-defined types (UDTs) those functions use. This is effectively the contract's ABI. SoroVault's job is to fetch that spec, decode it into a clean model, and make it usable.

## How registration works

When you register a contract, SoroVault:

1. Fetches the contract's on-chain code/instance and obtains its WASM.
2. Locates and decodes the spec embedded in that WASM into structured data — functions with typed inputs and outputs, plus UDTs.
3. Stores the decoded interface alongside the contract ID, network, and WASM hash.

From then on, the interface is queryable as clean JSON and browsable in the UI, without anyone needing to handle XDR or WASM themselves.

## A usable ABI

The decoded interface isn't just for humans to read — it's exposed as JSON that other tools can consume: a code generator could turn it into typed client bindings, a simulator could use it to validate call arguments, a UI could render a contract's methods. Publishing a stable, documented ABI shape is part of SoroVault's purpose. (Client-code generation from the ABI is a natural future contribution rather than an MVP feature.)

## Versioning

Contracts can be upgraded, which changes their WASM — and therefore potentially their interface. SoroVault detects when a registered contract's on-chain WASM hash has changed, decodes the new spec, and stores it as a new version while keeping the prior one. That history lets you see how a contract's interface evolved, and lets consumers pin to a known version.

## Read-only and safe

SoroVault only reads from the chain and writes to its own registry. It never signs, submits, or modifies contracts — it's a catalog, not an actor.

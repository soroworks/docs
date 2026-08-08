# Concepts

## Simulation

Soroban lets you *simulate* a contract invocation — run it against the current ledger state without submitting a transaction — to learn what it would do. SoroProbe builds the call, sends it through the RPC's simulation, and presents the outcome: would it succeed, what would it return (decoded from ScVal into readable JSON), and what resources and fees it would consume.

Because nothing is submitted, simulation is free, safe, and repeatable — the ideal way to check a call before committing to it.

## State health and expiration

Soroban contract state doesn't live forever by default: entries have a lifetime and can expire (become archived) if not maintained, after which calls that depend on them start failing. This is one of the most common and confusing sources of "it worked yesterday" bugs.

SoroProbe reads a contract's on-chain entries (its code, instance, and data) and reports their health — most importantly, how close any of them are to expiring — so you can act before expiration causes failures rather than after. The exact expiration model and its terminology are described as SoroProbe reports them; the goal is to make an easily-missed problem visible and plain.

## The combined check

`soroprobe check` bundles the above into one pass suitable for CI: is the contract deployed, is its code/instance live and not near expiration, and does a simple read-only call simulate successfully? It returns a non-zero exit code on any failure, so a pipeline can fail fast when a contract is unhealthy.

## Argument and result encoding

Contract calls take and return Soroban `ScVal`s. SoroProbe accepts human-friendly arguments and encodes them to ScVals for the call, then decodes ScVal results back into readable JSON. The encoder/decoder sits behind an interface, so support for more types is a natural contribution.

## Read-only by design

SoroProbe never signs, never submits, and never stores. It only asks the chain questions. That keeps its security surface minimal and makes it safe to run freely, including in automated environments.

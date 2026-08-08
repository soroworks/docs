# Contributing

SoroForge is built around clean Go interfaces (the stellar client, the store, and the signer), so most contributions are small and self-contained. The project participates in **Drips Wave**, where merged PRs on tagged issues earn points toward rewards.

## Where contributions land

- **New lifecycle operations** — rollback to a prior version, diffing two deployed versions, bulk deploy from config.
- **Signing backends** — new implementations of the signer interface (keystore files, hardware or remote signers) beyond env-var keys.
- **CLI & API** — new subcommands, `--json` output everywhere, additional HTTP endpoints for CI.
- **Testing** — dry-run assembly tests for every transaction type against the mocked stellar client; integration tests for the history store.
- **Docs & ops** — deployment guides, key-handling security notes, Docker/CI pipelines, Helm charts.

## How to contribute

1. Pick an open issue — each carries context, requirements, a suggested approach, and an explicit definition of done.
2. Get assigned before starting.
3. Fork, branch, build. `go build ./...` and `go test ./...` must pass without a live network.
4. Open a PR with `Closes #<issue>`, test output, and anything the issue asked to demonstrate.

## Standards

- Interface the stellar client, store, and signer so each is testable and replaceable.
- **Never** log or commit secret keys.
- Never require a live network for `go test ./...` — mock the RPC.
- Be honest in PRs about limitations and untested edges.

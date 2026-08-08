# Contributing

SoroVault is built around clean interfaces (the stellar client, the spec decoder, and the store), so contributions stay small and self-contained. The project participates in **Drips Wave**, where merged PRs on tagged issues earn points toward rewards.

## Where contributions land

- **Spec decoding** — coverage for more spec and UDT shapes is the core extension point.
- **Client-code generation** — generating typed bindings (TypeScript, Go) from a stored ABI is a high-value, well-scoped feature.
- **New features** — ABI diffing across versions, contract metadata resolution (names/symbols), additional export formats.
- **Web UI** — better search and filtering, function-signature detail views, responsive htmx layouts.
- **Testing** — spec-decoding tests against checked-in WASM fixtures, store and API handler tests, version-history correctness.
- **Docs & ops** — the exported ABI schema, architecture docs, Docker/CI pipelines.

## How to contribute

1. Pick an open issue — each carries context, requirements, a suggested approach, and a definition of done.
2. Get assigned before starting.
3. Fork, branch, build. `go build ./...` and `go test ./...` must pass without a live network — decode from a checked-in WASM fixture.
4. Open a PR with `Closes #<issue>`, test output, and anything the issue asked for.

## Standards

- Interface the stellar client, the spec decoder, and the store so each is testable.
- Never require a live network for tests — use a checked-in WASM/spec fixture.
- Keep SoroVault read-only with respect to the chain: fetch and catalog, never sign or submit.
- Be honest about limitations and untested edges in PRs.

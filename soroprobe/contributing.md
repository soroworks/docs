# Contributing

SoroProbe is stateless and read-only, built around two clean interfaces (the stellar client and the ScVal codec), so contributions stay small and self-contained. The project participates in **Drips Wave**, where merged PRs on tagged issues earn points toward rewards.

## Where contributions land

- **ScVal type support** — the encode/decode layer is the main extension point; adding types is high-value, approachable work.
- **New checks & features** — batch simulation of multiple calls, cost/fee threshold checks that fail in CI, deeper state-expiration reporting (rent/restore estimates), simulated-vs-actual comparison.
- **CLI & API** — richer output, `--json` everywhere, additional endpoints.
- **Testing** — table-driven ScVal codec tests, health-interpretation tests against recorded fixtures, more simulation fixtures (success, failure, near-expiration).
- **Docs** — reading simulation output, the state-expiration explainer, CI-integration recipes.

## How to contribute

1. Pick an open issue — each carries context, requirements, a suggested approach, and a definition of done.
2. Get assigned before starting.
3. Fork, branch, build. `go build ./...` and `go test ./...` must pass without a live network — use recorded fixtures.
4. Open a PR with `Closes #<issue>`, test output, and anything the issue asked for.

## Standards

- Interface the stellar client and the ScVal codec so both are testable.
- Keep SoroProbe read-only: no signing, no submission, no persistence.
- Never require a live network for tests — record and check in fixtures.
- Be honest about limitations and untested edges in PRs.

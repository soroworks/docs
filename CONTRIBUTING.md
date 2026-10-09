# Contributing to the SoroWorks docs

These pages document SoroForge, SoroVault and SoroProbe. They are published with GitBook from this repository (`SUMMARY.md` is the table of contents).

## Ground rules

- **Every command must have been run.** Document what the tools actually do, against their current release — not what they might do. If you are unsure of a flag or an exit code, check the tool's `--help` or its README, which are kept in step with the code.
- **One topic per page**, linked from `SUMMARY.md`. A new page that is not in `SUMMARY.md` will not appear on the site.
- **Behaviour changes belong in the tool first.** If a page is wrong because the tool is wrong, open an issue on the tool's repository.

## Making a change

1. Fork, branch, edit the Markdown.
2. Check every relative link resolves and every code block is copy-pasteable.
3. Open a pull request describing what you verified and against which version.

Issues labelled `good first issue` or carrying a `complexity:` label are ready to pick up; comment on one to be assigned before you start.

By contributing you agree that your contributions are licensed under the Apache License 2.0, as the rest of SoroWorks is.

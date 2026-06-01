# Contributing to assay

Thanks for looking. assay is small on purpose and intends to stay that way.

## The one rule

**The friction is load-bearing.** assay manufactures judgment by making the user
state a bet before they keep anything. Any change that removes that friction in
the name of convenience is not a feature, it is a different tool. Proposals to
auto-keep, auto-summarize, or silently remember will be declined. See
[SPEC.md](SPEC.md) for the full argument.

## What is in scope

- Fixing or clarifying the spec and docs.
- Improving the generic example or the worked synthetic examples.
- Hardening the one helper script (`bin/assay-capture`) without adding dependencies.
- Tests for the above.

## What is out of scope for now

- `organize`, `review`, and `nudge` logic. These are run by hand in v0 by design.
- A CLI framework or an MCP server (Layer 3). Deferred, not yet wanted.
- Any learning or evolution loop (Layer 4). Hard-gated. Do not propose it until
  Layer 2 has produced a verified review signal that beats random and cold gut.

## Hard constraints

- **Dependency-free.** No package installs of any kind. Stdlib and POSIX shell only.
- **No personal data in the repo.** Examples must be generic and obviously synthetic.
  The repo is the tool. Real context lives in the user's private `~/.assay/`.
- **Plain files are the single source of truth.** No databases, no hidden state.

## Practical notes

- Keep the maintainer voice: direct, opinionated, no filler.
- Run the test before sending a change:

  ```sh
  sh tests/test_capture.sh
  ```

- The capture script targets POSIX `/bin/sh`. Do not add bashisms.

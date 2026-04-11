# Copilot Instructions

This is a Homebrew tap repository (`nyg/jmxsh`) that distributes a single formula: [jmxsh](https://github.com/nyg/jmxsh), an interactive command-line JMX client for monitoring and managing Java applications.

## Architecture

- `Formula/jmxsh.rb` — The sole Homebrew formula. Downloads a JAR from GitHub Releases and creates a wrapper script via `write_jar_script`. Includes a `livecheck` block for automatic version detection.
- `.github/workflows/update-formula.yml` — Triggered by `repository_dispatch` from upstream releases (or `workflow_dispatch`). Downloads the JAR, computes SHA256, updates the formula, and opens a PR on branch `update-jmxsh-<version>`.
- `.github/workflows/tests.yml` — Runs `brew test-bot` on push/PR across three platforms (macOS Intel, macOS ARM, Linux). Uploads bottle artifacts on PRs.
- `.github/workflows/auto-pr-pull.yml` — Triggered when `tests.yml` completes successfully on an `update-jmxsh-*` branch. Applies the `pr-pull` label using `HOMEBREW_TAP_TOKEN` (so the event triggers `publish.yml`).
- `.github/workflows/publish.yml` — Triggered by the `pr-pull` label. Runs `brew pr-pull` to download/upload bottles and annotate the formula with a `bottle` block. Force-pushes the annotated commit to the PR branch and squash-merges via the GitHub API (direct push to master is blocked by branch protection).

## Token strategy

- `HOMEBREW_TAP_TOKEN` (fine-grained PAT) — Used in `update-formula.yml` (create PRs) and `auto-pr-pull.yml` (apply labels). Required because `GITHUB_TOKEN`-triggered events don't trigger downstream workflows.
- `GITHUB_TOKEN` — Used in `publish.yml` for all operations (Homebrew setup, bottle upload API, push to PR branch, squash-merge). Sufficient because the PR branch isn't protected and the ruleset allows squash merge with 0 approvals.

## Testing

```sh
# Lint the formula (syntax, style, audit)
brew test-bot --only-tap-syntax

# Build and test a specific formula (used in CI for PRs)
brew test-bot --only-formulae

# Run the formula's test block locally
brew test jmxsh

# Check for new upstream releases
brew livecheck jmxsh
```

## Updating the Formula

Formula updates are automated (see `update-formula.yml`). For manual updates when a new jmxsh release is published:

1. Update `url` with the new release JAR URL and version.
2. Update `sha256` — generate with `brew fetch --force --build-from-source jmxsh` or `shasum -a 256 <jar>`.
3. Update `depends_on "openjdk@XX"` if the required Java version changes.
4. The JAR filename in `install` includes the version (`jmxsh-#{version}.jar`), so it updates automatically from the `url` version.

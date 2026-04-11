# Copilot Instructions

This is a Homebrew tap repository (`nyg/jmxsh`) that distributes a single formula: [jmxsh](https://github.com/nyg/jmxsh), an interactive command-line JMX client for monitoring and managing Java applications.

## Architecture

- `Formula/jmxsh.rb` — The sole Homebrew formula. Downloads a JAR from GitHub Releases and creates a wrapper script via `write_jar_script`. Includes a `livecheck` block for automatic version detection.
- `.github/workflows/tests.yml` — Runs `brew test-bot` on push/PR (macOS Intel, macOS ARM, Linux).
- `.github/workflows/publish.yml` — Pulls bottles and pushes commits when a PR is labeled `pr-pull`.

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

When a new jmxsh release is published:

1. Update `url` with the new release JAR URL and version.
2. Update `sha256` — generate with `brew fetch --force --build-from-source jmxsh` or `shasum -a 256 <jar>`.
3. Update `depends_on "openjdk@XX"` if the required Java version changes.
4. The JAR filename in `install` includes the version (`jmxsh-#{version}.jar`), so it updates automatically from the `url` version.

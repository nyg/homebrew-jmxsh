# homebrew-jmxsh

Homebrew tap for [jmxsh](https://github.com/nyg/jmxsh) — an interactive command-line JMX client for monitoring and managing Java applications.

**Website:** [jmx.sh](https://jmx.sh)

## Installation

```sh
brew install nyg/jmxsh/jmxsh
```

Or tap first, then install:

```sh
brew tap nyg/jmxsh
brew install jmxsh
```

Or in a [`Brewfile`](https://github.com/Homebrew/homebrew-bundle):

```ruby
tap "nyg/jmxsh"
brew "jmxsh"
```

## Usage

Once installed, run `jmxsh` to start the interactive shell. See the [upstream documentation](https://github.com/nyg/jmxsh) for the full command reference.

## Automated Formula Updates

When a new release is published in [`nyg/jmxsh`](https://github.com/nyg/jmxsh), the formula in this tap can be updated automatically via GitHub Actions.

### How it works

1. A release in `nyg/jmxsh` triggers a `repository_dispatch` event to this repo.
2. [`update-formula.yml`](.github/workflows/update-formula.yml) updates the formula (URL, SHA256, Java version) and opens a PR.
3. [`tests.yml`](.github/workflows/tests.yml) builds bottles on the PR.
4. [`auto-pr-pull.yml`](.github/workflows/auto-pr-pull.yml) applies the `pr-pull` label once tests pass.
5. [`publish.yml`](.github/workflows/publish.yml) pulls bottles and pushes to master.

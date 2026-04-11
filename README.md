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

### Setup

#### 1. Create a Personal Access Token

Create a [fine-grained PAT](https://github.com/settings/personal-access-tokens/new) scoped to `nyg/homebrew-jmxsh` with the following permissions:

| Permission | Access | Purpose |
|---|---|---|
| Contents | Read and write | Push branches, receive `repository_dispatch` |
| Pull requests | Read and write | Create PRs |
| Issues | Read and write | Apply `pr-pull` label |

Add the token as a repository secret named **`HOMEBREW_TAP_TOKEN`** in both [`nyg/jmxsh`](https://github.com/nyg/jmxsh/settings/secrets/actions) and [`nyg/homebrew-jmxsh`](https://github.com/nyg/homebrew-jmxsh/settings/secrets/actions).

#### 2. Create the `pr-pull` label

Ensure a label named **`pr-pull`** exists in this repo (it should already if you've used the publish workflow before).

#### 3. Add the dispatch workflow to `nyg/jmxsh`

Create `.github/workflows/update-tap.yml` in the upstream repo:

```yaml
name: Update Homebrew tap

on:
  release:
    types: [published]

jobs:
  update-tap:
    if: "!github.event.release.prerelease && !github.event.release.draft"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Get Java version
        id: java
        run: |
          # Adapt to your build system, e.g.:
          #   grep sourceCompatibility build.gradle.kts
          #   cat .java-version
          echo "version=25" >> "$GITHUB_OUTPUT"

      - name: Get JAR asset URL
        id: jar
        env:
          GH_TOKEN: ${{ github.token }}
        run: |
          JAR_URL=$(gh release view "${{ github.event.release.tag_name }}" \
            --json assets --jq '.assets[] | select(.name | endswith(".jar")) | .url')
          echo "url=$JAR_URL" >> "$GITHUB_OUTPUT"

      - name: Dispatch to Homebrew tap
        uses: peter-evans/repository-dispatch@v3
        with:
          token: ${{ secrets.HOMEBREW_TAP_TOKEN }}
          repository: nyg/homebrew-jmxsh
          event-type: update-formula
          client-payload: >-
            {
              "version": "${{ github.event.release.tag_name }}",
              "jar_url": "${{ steps.jar.outputs.url }}",
              "java_version": "${{ steps.java.outputs.version }}"
            }
```

### Manual trigger

The update workflow can also be triggered manually via `workflow_dispatch` from the [Actions tab](../../actions/workflows/update-formula.yml).

### First-run note

The `auto-pr-pull.yml` workflow uses `workflow_run`, which only activates for workflows present in the default branch. After the initial merge of these workflows into `master`, the first automated PR may need the `pr-pull` label applied manually.

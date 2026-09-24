# Homebrew Tap

Custom Homebrew tap for shreeve's apps and tools.

## Installation

```bash
brew tap shreeve/tap
```

## Formulae

### git-enc

Keep secrets in git, encrypted, and declare them in `.gitignore`. Runs as `git enc`.

```bash
brew install shreeve/tap/git-enc
```

More info: https://github.com/shreeve/git-enc

## Casks

### PairSync

A beautiful dual-pane file synchronization app for macOS with rsync and SSH support.

```bash
brew install --cask pairsync
```

**Features:**
- Dual-pane file browser
- Remote SSH/SFTP browsing
- Selective file sync
- Force (mirror) and Slurp (copy) modes
- Light/Dark theme

More info: https://github.com/shreeve/pairsync

### Transfer

A native Mac app for browsing an SFTP server, riding the system's `ssh`. Signed with a Developer ID and notarized, and it updates itself.

```bash
brew install --cask shreeve/tap/transfer-sftp
```

The cask is `transfer-sftp` because Homebrew's own `transfer` is a different app. Requires macOS 27 on Apple silicon.

More info: https://github.com/shreeve/transfer

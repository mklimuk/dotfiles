# Dotfiles Repository

This is a chezmoi dotfile management repository.

## Usage

### Initial Setup

1. **Install chezmoi** (if not already installed):

   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
   ```

2. **Initialize dotfiles**:

Note: Often on clean install `.local/bin` is not in PATH, so you may need to use `~/.local/bin/chezmoi` instead of `chezmoi`.

Simplest (default github setup):

```bash
   chezmoi init --apply mklimuk
```

Explicit (if you want to specify the repo):

   ```bash
   chezmoi init --apply https://github.com/mklimuk/dotfiles.git
   ```

Or with SSH:
   ```bash
   chezmoi init --apply git@github.com:mklimuk/dotfiles.git
   ```

3. **Verify installation**:
   ```bash
   ls -la ~/.config/zsh | grep zshrc
   source ~/.config/zsh/.zshrc
   ```

### Updating Dotfiles

Edit the files in this repository (with `dot_` prefix), commit, and push. On remote servers, run:
```bash
chezmoi update
```

This will pull the latest changes and apply them.

## What's Included

- Basic zsh configuration (.zshenv, .zshrc) with tool integrations
- Automated installation script for development tools (see below)

## Tool Installation

This repository includes an automated installation script for MacOS and Linux that installs the following development tools:

### Tools Installed

1. **oh-my-posh** - Modern shell prompt
2. **pass** - Password store (via apt)
3. **zellij** - Terminal multiplexer
4. **nvim** - Neovim editor (prefers apt, falls back to GitHub)
5. **bat** - Cat alternative with syntax highlighting (via apt)
6. **eza** - Modern ls replacement
7. **ripgrep** - Fast grep alternative (via apt)
8. **entr** - File watcher (via apt)
9. **fzf** - Fuzzy finder (prefers apt, falls back to GitHub)
10. **zoxide** - Smart cd replacement
11. **tlrc** - tldr client
12. **delta** - Git diff viewer
13. **chezmoi** - Dotfile manager

### How It Works

The script `run_once_install-tools.sh` is automatically executed by chezmoi when you run `chezmoi apply` or `chezmoi init --apply`.

#### Installation Methods

- **Homebrew**: Tools available in Homebrew are installed via `brew`
- **APT packages**: Tools available in Debian repositories are installed via `apt-get`
- **GitHub releases**: Tools not in repositories are downloaded from GitHub releases
- **Idempotent**: The script checks if tools are already installed before attempting installation

#### Requirements

- MacOS
- Debian Trixie (or compatible Debian-based system)
- sudo access
- Internet connection
- Architecture: amd64 or arm64

### Manual Execution

If you need to run the installation script manually:

```bash
bash ~/.local/share/chezmoi/run_once_install-tools.sh
```

Or if you've cloned this repo directly:

```bash
bash run_once_install-tools.sh
```

### Troubleshooting

#### Tools not found after installation

Make sure `~/.local/bin` is in your PATH. This is automatically added to `.zshrc`, but you may need to:

```bash
export PATH="$HOME/.local/bin:$PATH"
source ~/.zshrc
```

#### GitHub download failures

Some tools may fail to download if:

- GitHub API rate limits are hit
- Network connectivity issues
- Release asset naming changes

In these cases, you can manually install the tool or retry the script.

#### Architecture not supported

The script currently supports:
- `amd64` / `x86_64`
- `arm64` / `aarch64`

For other architectures, you'll need to modify the script or install tools manually.

## Repository Structure

- `dot_zshenv` → becomes `~/.zshenv` on target system
- `dot_config/zsh/dot_zshrc` → becomes `~/.config/zsh/.zshrc` on target system
- `dot_config/zsh/dot_zprofile` → becomes `~/.zprofile` on target system
- `dot_config/ohmyposh/config.toml` → becomes `~/.config/ohmyposh/config.toml` on target system

#### Lex specific

To fix network adapter lag use Intel driver and set:

```bash
sudo ethtool -K enp7s0 tx off rx off
```

To make it permanent add to `/etc/network/interfaces`:

```bash
auto enp7s0
iface enp7s0 inet dhcp
    ethtool -K enp7s0 tx off rx off
```

Grub setup `/etc/default/grub` (also fixes slow boot with ATA0 error):

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 i915.enable_guc_loading=1 i915.enable_guc_submission=1 libata.force=noncq"
```

Then run:

```bash
sudo update-grub
```
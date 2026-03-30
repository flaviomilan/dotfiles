# Dotfiles

Personal dotfiles for a terminal-centric workflow. Primarily designed for **macOS** with cross-platform support for **Arch Linux**.

> **Using Omarchy?** See [dotfiles.omarchy](https://github.com/flaviomilan/dotfiles.omarchy) — a lightweight overlay that respects the omakase philosophy.

## Quick Start

```bash
git clone https://github.com/<your-user>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer auto-detects your platform and picks the right strategy:

| Platform | Default Mode | What Happens |
|----------|-------------|--------------|
| macOS | `full` | Installs everything via Homebrew |
| Arch Linux | `full` | Installs everything via pacman |
| Omarchy | `overlay` | Keeps Omarchy base, selectively replaces configs |

### Installation Modes

```bash
./install.sh full        # Install everything
./install.sh overlay     # Overlay on existing setup (Omarchy)
./install.sh minimal     # Only install missing tools
./install.sh uninstall   # Remove dotfiles symlinks
./install.sh --dry-run   # Preview without changes
./install.sh --yes full  # Non-interactive
```

## Architecture

```
dotfiles/
├── install.sh           # Main entry point
├── Makefile             # Quick commands (make help)
├── lib/                 # Modular shell library
│   ├── logging.sh       # Colored output utilities
│   ├── platform.sh      # OS & environment detection
│   ├── packages.sh      # Cross-platform package installer
│   ├── stow.sh          # GNU Stow wrapper with backup/restore
│   └── omarchy.sh       # Omarchy coexistence logic
├── configs/             # Stow packages (symlinked to ~)
│   ├── bash/            # .bashrc (slim wrapper)
│   ├── ghostty/         # Ghostty terminal config
│   ├── git/             # .gitconfig
│   ├── mise/            # mise global tool versions
│   ├── neovim/          # Neovim (LazyVim based)
│   ├── shell/           # Shared shell modules (aliases, fzf, tools…)
│   ├── starship/        # Starship prompt config
│   ├── tmux/            # tmux config with plugins
│   ├── tools/           # Custom scripts (fzf-git, aws_creds)
│   └── zsh/             # .zshrc (slim wrapper) + vendored plugins
├── docs/                # Platform-specific guides
│   ├── archlinux.md
│   ├── macos.md
│   ├── omarchy.md       # Omarchy coexistence guide
│   └── windows_setup.md
└── .github/
    ├── workflows/lint.yml
    └── ISSUE_TEMPLATE/
```

### How It Works

1. **Detection** — Identifies OS, package manager, and Omarchy presence
2. **Prerequisites** — Installs `gum` (TUI) and `stow` (symlinks)
3. **Tools** — Installs CLI tools via the platform package manager
4. **Configs** — Symlinks config files to `~` using GNU Stow
5. **Backup** — Existing configs are backed up to `~/.dotfiles-backup/` before replacement

### Shell Architecture

Both `.bashrc` and `.zshrc` are slim wrappers that source shared modules from `~/.config/shell/`:

```
~/.config/shell/
  environment.sh   # EDITOR, HISTSIZE, LANG, XDG dirs, PATH
  aliases.sh       # General, directory, safety-net, and git aliases
  fzf.sh           # fzf config, colors, previews, fzf-git
  tools.sh         # zoxide, starship, mise activation
  functions.sh     # mkcd, extract, serve, gclone, fkill, path
  ai.sh            # AI tools: Claude Code, GitHub Copilot CLI, aicommit
  tmux.sh          # tmux auto-attach, GPG agent
```

Each RC file only contains shell-specific setup (bash `shopt` options, zsh plugins) and a loop that sources the shared modules. Adding a new alias or function means editing **one file** instead of two.

## Tools

| Tool | Description |
|------|-------------|
| [neovim](https://neovim.io/) | Hyperextensible text editor |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer with session persistence |
| [ghostty](https://ghostty.org/) | Fast, native terminal emulator |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder for files, history, and more |
| [fd](https://github.com/sharkdp/fd) | Fast alternative to `find` |
| [bat](https://github.com/sharkdp/bat) | `cat` with syntax highlighting |
| [eza](https://github.com/eza-community/eza) | Modern `ls` replacement |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` that learns your habits |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Blazing fast recursive grep |
| [starship](https://starship.rs/) | Minimal, fast, customizable prompt |
| [mise](https://mise.jdx.dev/) | Dev tool version manager (node, python, go, etc.) |
| [lazygit](https://github.com/jesseduffield/lazygit) | Simple terminal UI for Git |
| [sesh](https://github.com/joshmedeski/sesh) | Smart tmux session manager |
| [fzf-git](https://github.com/junegunn/fzf-git.sh) | Git + fzf keybindings |
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | AI coding agent in the terminal |
| [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli) | AI command suggestions (`??`, `explain`) |

## Keymaps

### fzf

| Key | Action |
|-----|--------|
| <kbd>Ctrl-T</kbd> | Fuzzy file search |
| <kbd>Alt-C</kbd> | Fuzzy directory search |
| <kbd>Ctrl-R</kbd> | History search |

### fzf-git

| Key | Action |
|-----|--------|
| <kbd>Ctrl-G</kbd> <kbd>Ctrl-F</kbd> | **F**iles |
| <kbd>Ctrl-G</kbd> <kbd>Ctrl-B</kbd> | **B**ranches |
| <kbd>Ctrl-G</kbd> <kbd>Ctrl-T</kbd> | **T**ags |
| <kbd>Ctrl-G</kbd> <kbd>Ctrl-R</kbd> | **R**emotes |
| <kbd>Ctrl-G</kbd> <kbd>Ctrl-H</kbd> | Commit **H**ashes |
| <kbd>Ctrl-G</kbd> <kbd>Ctrl-S</kbd> | **S**tashes |
| <kbd>Ctrl-G</kbd> <kbd>Ctrl-L</kbd> | Ref**l**ogs |
| <kbd>Ctrl-G</kbd> <kbd>Ctrl-W</kbd> | **W**orktrees |
| <kbd>Ctrl-G</kbd> <kbd>Ctrl-E</kbd> | **E**ach ref |

### tmux

| Key | Action |
|-----|--------|
| <kbd>Ctrl-A</kbd> | Prefix (replaces Ctrl-B) |
| <kbd>Prefix</kbd> <kbd>T</kbd> | Session switcher (sesh + fzf) |
| <kbd>Ctrl-H/J/K/L</kbd> | Navigate panes (vim-aware) |
| <kbd>Prefix</kbd> <kbd>H/J/K/L</kbd> | Resize panes |
| <kbd>Prefix</kbd> <kbd>\|</kbd> | Split horizontal |
| <kbd>Prefix</kbd> <kbd>-</kbd> | Split vertical |

### Neovim AI (<kbd>Space</kbd> + <kbd>a</kbd>)

| Key | Mode | Action |
|-----|------|--------|
| <kbd>Space</kbd> <kbd>a</kbd> <kbd>a</kbd> | n | Toggle CopilotChat |
| <kbd>Space</kbd> <kbd>a</kbd> <kbd>q</kbd> | n | Quick AI question |
| <kbd>Space</kbd> <kbd>a</kbd> <kbd>m</kbd> | n | Generate commit message |
| <kbd>Space</kbd> <kbd>a</kbd> <kbd>p</kbd> | n | Prompt actions (Telescope) |
| <kbd>Space</kbd> <kbd>a</kbd> <kbd>e</kbd> | v | Explain selection |
| <kbd>Space</kbd> <kbd>a</kbd> <kbd>r</kbd> | v | Review selection |
| <kbd>Space</kbd> <kbd>a</kbd> <kbd>f</kbd> | v | Fix selection |
| <kbd>Space</kbd> <kbd>a</kbd> <kbd>o</kbd> | v | Optimize selection |
| <kbd>Space</kbd> <kbd>a</kbd> <kbd>d</kbd> | v | Generate docs |
| <kbd>Space</kbd> <kbd>a</kbd> <kbd>t</kbd> | v | Generate tests |
| <kbd>Space</kbd> <kbd>a</kbd> <kbd>c</kbd> | n | Avante: ask AI about code |
| <kbd>Tab</kbd> | i | Accept Copilot suggestion |

### Shell AI

| Command | Action |
|---------|--------|
| `??` | AI shell command suggestion (gh copilot) |
| `git?` | AI git command suggestion |
| `explain` | Explain a command with AI |
| `ask "..."` | Quick question to Claude / Copilot |
| `how "..."` | Get a shell command for a task |
| `aicommit` | AI-generated git commit message |
| `review file` | AI code review of a file |

## Aliases

### General

| Alias | Command |
|-------|---------|
| `vim` | `nvim` |
| `c` | `clear` |
| `ls` | `eza` with icons |
| `tree` | Tree view (3 levels) |
| `lg` | `lazygit` |

### Git (shell aliases)

| Alias | Command | Category |
|-------|---------|----------|
| `gs` | `git status -s` | basics |
| `gd` / `gds` | `git diff` / `--staged` | basics |
| `ga` / `gap` | `git add .` / `add -p` (interactive) | staging |
| `grs` | `git restore --staged` (unstage) | staging |
| `gc` / `gce` | `git commit -m` / open editor | commits |
| `gca` / `gcae` | amend (silent / open editor) | commits |
| `gcam` | `git commit -am` (tracked + commit) | commits |
| `gwip` | quick WIP commit (skip CI) | commits |
| `gundo` | undo last commit, keep staged | commits |
| `gsw` / `gswc` | `git switch` / `-c` (create) | branches |
| `gb` / `gba` | branch / branch -a | branches |
| `gbd` / `gbD` | delete merged / force delete | branches |
| `gf` / `gfa` | `fetch` / `--all --prune` | remote |
| `gpl` / `gplr` | `pull` / `--rebase` | remote |
| `gps` / `gpsf` | `push` / `--force-with-lease` | remote |
| `gpsu` | push new branch + set upstream | remote |
| `grbi` | `git rebase -i` (interactive) | rebase |
| `grbc` / `grba` | rebase continue / abort | rebase |
| `gst` / `gstp` / `gstl` | stash / pop / list | stash |
| `glog` / `gll` / `glp` | graph / last 20 / pretty dated | log |
| `gbl` | `git blame -C` | utils |
| `gcp` | `git cherry-pick` | utils |
| `gbclean` | delete branches merged into main | utils |

### Git (gitconfig aliases)

| Alias | Command |
|-------|---------|
| `git undo` | Reset last commit (soft) |
| `git unstage` | Restore --staged |
| `git wip` | Quick WIP commit |
| `git unwip` | Pop WIP commit |
| `git today` | Commits since midnight |
| `git bclean` | Delete merged branches |
| `git gone` | List branches with deleted remotes |
| `git prune-gone` | Delete branches with deleted remotes |
| `git last` | Diff from last commit |
| `git aliases` | List all git aliases |
| `git root` | Show repo root path |

## Make Commands

```bash
make help            # Show all commands
make install         # Auto-detect and install
make install-full    # Full install
make install-overlay # Overlay mode
make install-dry     # Dry-run preview
make stow-neovim     # Stow single config
make unstow-neovim   # Unstow single config
make doctor          # Check system health
make lint            # Run shellcheck
make backup          # List config backups
make restore         # Restore a backup
make update          # Pull + re-install
make version         # Show current version
make changelog       # Changes since last release
```

## Releases

This project uses [CalVer](https://calver.org/) — tags follow the format `YYYY.MM.DD`.

Every push to `main` automatically creates a GitHub Release with a changelog grouped by [Conventional Commits](https://www.conventionalcommits.org/):

| Prefix | Changelog Section |
|--------|-------------------|
| `feat:` | ✨ Features |
| `fix:` | 🐛 Bug Fixes |
| `docs:` | 📚 Documentation |
| `refactor:` | ♻️ Refactoring |
| `chore:` | 🔧 Chores |
| `perf:` | ⚡ Performance |
| `ci:` | 👷 CI |

To skip a release, add `[skip release]` to your commit message.

See all releases: [GitHub Releases](https://github.com/oflaviomilan/dotfiles/releases)

## Platform Guides

- [macOS](docs/macos.md) — Homebrew, iTerm2, fonts
- [Arch Linux](docs/archlinux.md) — pacman, AUR, clipboard
- [Omarchy](docs/omarchy.md) — Coexistence with DHH's Arch setup
- [Windows (WSL)](docs/windows_setup.md) — Windows Terminal + WSL2

## License

MIT

# Contributing to Dotfiles

> This guide is mostly for **future you** — keeping things organized as the setup evolves.

## Project Structure

```
dotfiles/
├── configs/          # Stow packages → symlinked to ~
│   ├── shell/        # Shared shell modules (~/.config/shell/)
│   ├── bash/         # .bashrc (slim wrapper)
│   ├── zsh/          # .zshrc (slim wrapper + plugins)
│   ├── neovim/       # Neovim config (kickstart + custom plugins)
│   ├── tmux/         # tmux config
│   ├── git/          # .gitconfig
│   ├── ghostty/      # Ghostty terminal
│   ├── starship/     # Starship prompt
│   ├── mise/         # mise tool versions
│   └── tools/        # Custom scripts
├── lib/              # Bash library modules (sourced by install.sh)
├── scripts/          # Standalone setup scripts (GPG, etc.)
├── docs/             # Platform guides
└── .github/          # CI, templates, workflows
```

## Rules

### 1. One feature = one stow package

Each directory under `configs/` is a [GNU Stow](https://www.gnu.org/software/stow/) package. Its internal structure mirrors `$HOME`:

```
configs/ghostty/.config/ghostty/config  →  ~/.config/ghostty/config
configs/git/.gitconfig                  →  ~/.gitconfig
```

### 2. Shared shell logic goes in `configs/shell/`

**Never** duplicate between `.bashrc` and `.zshrc`. Add new aliases, functions, or env vars to the appropriate module:

| File | Purpose |
|------|---------|
| `environment.sh` | Env vars, PATH, XDG |
| `aliases.sh` | Shell aliases |
| `fzf.sh` | fzf configuration |
| `tools.sh` | Tool init (zoxide, starship, mise) |
| `functions.sh` | Utility functions |
| `ai.sh` | AI tools and functions |
| `tmux.sh` | tmux auto-start, GPG agent |

### 3. Guard everything

Every tool init must be guarded. Never assume a tool is installed:

```bash
# ✅ Good
command -v zoxide &>/dev/null && eval "$(zoxide init "$CURRENT_SHELL")"

# ❌ Bad — breaks when zoxide is missing
eval "$(zoxide init "$CURRENT_SHELL")"
```

```bash
# ✅ Good
[[ -f ~/.tools/fzf-git.sh ]] && source ~/.tools/fzf-git.sh

# ❌ Bad
source ~/.tools/fzf-git.sh
```

### 4. No hardcoded paths

Use variables, not absolute paths:

```bash
# ✅ Good
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# ❌ Bad
source /home/flavio/.config/shell/aliases.sh
```

### 5. Cross-platform by default

Every config must work on both macOS and Linux. Use platform detection when needed:

```bash
# ✅ Correct pattern
case "$(uname -s)" in
  Darwin) echo "macOS" ;;
  Linux)  echo "Linux" ;;
esac
```

For `xargs`, avoid GNUisms like `-r` (not available on macOS). Use `2>/dev/null` instead.

### 6. Commit messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add zsh completion for custom functions
fix: tmux clipboard on wayland
docs: update arch linux guide
refactor: split aliases into categories
chore: update neovim plugins
```

The release workflow auto-generates changelogs from these prefixes.

Add `[skip release]` to skip automatic release creation.

## Adding a New Tool

1. **Package mapping** — Add to `PACKAGE_MAP` in `lib/packages.sh`:
   ```bash
   [newtool]="brew:newtool|pacman:newtool|apt:newtool"
   ```

2. **Config** — Create `configs/newtool/.config/newtool/config` (mirroring home structure)

3. **Install mapping** — If the config should be auto-stowed, add to `TOOL_CONFIG_MAP` in `install.sh`

4. **Shell integration** — Add `eval` or alias to the appropriate `configs/shell/.config/shell/*.sh` module

5. **Doctor** — Add to the tool list in `Makefile` → `doctor` target

6. **README** — Add to the Tools table

## Adding a Neovim Plugin

1. Create `configs/neovim/.config/nvim/lua/custom/plugins/myplugin.lua`
2. Return a lazy.nvim spec — it's auto-loaded via `{ import = 'custom.plugins' }`
3. Keep plugins in individual files (one plugin = one file)

## Testing Changes

```bash
# Syntax check all shell files
find . -name '*.sh' -not -path './configs/zsh/.zsh/*' -not -path './configs/tools/.tools/*' \
  | xargs bash -n

# Full lint
make lint

# Dry-run install
make install-dry

# System health check
make doctor

# Test single config
make restow-neovim
```

## Useful Commands

```bash
make help        # All available commands
make doctor      # Health check
make changelog   # What changed since last release
make version     # Current version
```

# Copilot Instructions — Dotfiles Repository

## Context

This is a personal dotfiles repository managed with **GNU Stow**. It supports **macOS** (Homebrew) and **Arch Linux** (pacman), including **Omarchy** (overlay mode).

## Architecture

- `configs/` — Stow packages. Each directory mirrors `$HOME` structure and is symlinked via `stow -t ~`.
- `configs/shell/.config/shell/` — Shared shell modules sourced by both `.bashrc` and `.zshrc`.
- `lib/` — Bash library modules sourced by `install.sh` (logging, platform detection, packages, stow, omarchy).
- `scripts/` — Standalone setup scripts (GPG, doctor, etc.).
- `install.sh` — Main installer with modes: full, overlay, minimal, uninstall.

## Coding Rules

1. **Guard all commands** — Never assume a tool is installed:
   ```bash
   command -v tool &>/dev/null && eval "$(tool init bash)"
   ```

2. **No hardcoded paths** — Use `$HOME`, `$XDG_CONFIG_HOME`, etc.

3. **Cross-platform** — Every change must work on both macOS and Linux:
   - No GNU-only flags (`xargs -r`, `sed -i` without `''`)
   - Use `uname -s` for platform detection
   - Ghostty: `gtk-titlebar` is Linux-only, `macos-option-as-alt` is macOS-only

4. **Shell modules** — Shared logic goes in `configs/shell/.config/shell/*.sh`. Never duplicate between `.bashrc` and `.zshrc`.

5. **Lib guard pattern** — All `lib/*.sh` files use:
   ```bash
   [[ -n "${_FILENAME_SH_LOADED:-}" ]] && return 0
   _FILENAME_SH_LOADED=1
   ```

6. **Conventional Commits** — Use `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`, `perf:`, `ci:` prefixes.

7. **Stow structure** — Files in `configs/<name>/` mirror home directory paths:
   ```
   configs/ghostty/.config/ghostty/config → ~/.config/ghostty/config
   configs/git/.gitconfig                 → ~/.gitconfig
   ```

8. **Neovim plugins** — One file per plugin in `configs/neovim/.config/nvim/lua/custom/plugins/`. Return a lazy.nvim spec table.

## Testing

- `bash -n <file>` for syntax checking
- `shellcheck --severity=warning` for linting
- `make lint` runs full CI lint suite
- `make doctor` for system health check
- `make install-dry` for dry-run installation

## Package Management

New tools must be added to `PACKAGE_MAP` in `lib/packages.sh` with mappings for all supported package managers:
```bash
[toolname]="brew:name|pacman:name|apt:name"
```

## Important Files

- `install.sh` — Main entry point, do not break CLI arg parsing
- `lib/packages.sh` — `PACKAGE_MAP` associative array (requires bash 4+)
- `configs/shell/.config/shell/aliases.sh` — 42 shell aliases, organized by category
- `Makefile` — User-facing commands, keep `make help` output clean

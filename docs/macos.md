# macOS Setup

## Pré-requisitos

### Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Xcode Command Line Tools

```bash
xcode-select --install
```

## Instalação

```bash
git clone https://github.com/<your-user>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh full
```

## Terminal

### Ghostty

O installer instala o Ghostty automaticamente via Homebrew. A config em `configs/ghostty/` será aplicada.

### iTerm2 (Alternativa)

Se preferir o iTerm2:

1. Instale: `brew install --cask iterm2`
2. Tema Minimal: `Preferences > Appearance > General > Theme: Minimal`
3. Esconda scrollbars: `Preferences > Appearance > Windows > Hide scrollbars`
4. Instale o tema Snazzy:
   ```bash
   curl -Ls https://raw.githubusercontent.com/sindresorhus/iterm2-snazzy/main/Snazzy.itermcolors > /tmp/Snazzy.itermcolors && open /tmp/Snazzy.itermcolors
   ```
5. Aplique: `Preferences > Profiles > Color > Color Presets: Snazzy`

## Fonte

A JetBrains Mono Nerd Font é instalada automaticamente via `brew install font-jetbrains-mono-nerd-font` (requer `brew tap homebrew/cask-fonts`).

## Clipboard no tmux

O tmux está configurado para usar `pbcopy` automaticamente no macOS.

## Atalhos do macOS

Recomendo desabilitar alguns atalhos padrão do macOS que conflitam com o terminal:

- `System Settings > Keyboard > Keyboard Shortcuts > Mission Control`
  - Desabilite `Ctrl + ↑/↓/←/→` (conflitam com tmux/neovim)

## mise

O `mise` é instalado via curl e ativado automaticamente no `.zshrc_mac` / `.bashrc_mac`. As tool versions em `configs/mise/.config/mise/config.toml` serão aplicadas globalmente.

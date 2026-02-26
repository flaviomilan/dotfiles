# Arch Linux Setup

## Pré-requisitos

Uma instalação funcional do Arch Linux com:
- Acesso à internet
- `sudo` configurado para seu usuário
- `git` instalado (`sudo pacman -S git`)

## Instalação

```bash
git clone https://github.com/<your-user>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh full
```

### Com Omarchy

Se você está rodando o [Omarchy](https://github.com/basecamp/omarchy) (Arch Linux do DHH):

```bash
git clone https://github.com/<your-user>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh overlay
```

Veja [docs/omarchy.md](omarchy.md) para o guia completo de coexistência.

## AUR Helper

Para pacotes como 1Password que estão no AUR, o installer procura `yay` ou `paru`. Se nenhum estiver instalado, faz build manual via `makepkg`.

Recomendo instalar o `yay`:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si
```

## Clipboard no tmux

No Arch Linux, o tmux usa `wl-copy` (Wayland) com fallback para `xclip` (X11):

```bash
# Wayland (Hyprland/Sway)
sudo pacman -S wl-clipboard

# X11 (i3/etc)
sudo pacman -S xclip
```

## Ghostty

O Ghostty está configurado com:
- Tema: GruvboxDarkHard
- Fonte: JetBrainsMono NF, size 11
- `gtk-titlebar = false` (visual limpo no tiling WM)

## Ferramentas Instaladas

| Ferramenta | Pacote | Descrição |
|-----------|--------|-----------|
| neovim | `neovim` | Editor |
| ghostty | `ghostty` | Terminal |
| tmux | `tmux` | Multiplexer |
| zsh | `zsh` | Shell |
| fzf | `fzf` | Fuzzy finder |
| fd | `fd` | Find alternativo |
| bat | `bat` | Cat com syntax highlighting |
| eza | `eza` | ls moderno |
| zoxide | `zoxide` | cd inteligente |
| ripgrep | `ripgrep` | grep rápido |
| tldr | `tldr` | Man pages simplificados |
| lazygit | `lazygit` | Git TUI |
| starship | via curl | Prompt customizável |
| mise | via curl | Gerenciador de tool versions |

# Omarchy + Dotfiles Pessoais — Guia de Coexistência

## O que é o Omarchy?

[Omarchy](https://github.com/basecamp/omarchy) é o setup Arch Linux criado por DHH (David Heinemeier Hansson). Ele instala e configura automaticamente:

- **Hyprland** — compositor Wayland tiling
- **Ghostty** — terminal emulator
- **Neovim** — editor (config própria)
- **tmux** — terminal multiplexer
- **zsh** — shell com plugins
- **Starship** — prompt
- Ferramentas CLI: fzf, fd, bat, eza, zoxide, ripgrep, lazygit, etc.

## O Desafio

Quando você roda o Omarchy, ele já configura muitas das mesmas ferramentas que estes dotfiles gerenciam. Simplesmente sobrescrever tudo pode quebrar a integração do Omarchy com o Hyprland e outros componentes do desktop.

## Estratégias de Instalação

### 1. Overlay (Recomendado)

```bash
./install.sh overlay
```

Neste modo, o installer:

1. **Detecta** que você está em um ambiente Omarchy
2. **Pula** a instalação de ferramentas que já existem
3. **Pergunta** quais configs pessoais você quer aplicar
4. **Faz backup** dos configs do Omarchy antes de substituir
5. **Aplica** apenas os configs selecionados + configs que não conflitam (bash, git, tools)

**Ideal para:** Manter o Omarchy como base e customizar apenas o que importa

### 2. Full

```bash
./install.sh full
```

Substitui **todos** os configs pelos seus pessoais. Útil se você prefere sua config de neovim, tmux, etc. ao invés das do Omarchy.

**Atenção:** Configs do Omarchy serão salvos em `~/.dotfiles-backup/`

### 3. Minimal

```bash
./install.sh minimal
```

Instala apenas ferramentas **ausentes** e aplica somente configs que não conflitam (bash, git, tools). Não toca nas configs do Omarchy.

**Ideal para:** Adicionar suas coisas sem alterar nada do Omarchy

## Configs que Tipicamente Conflitam

| Config | Omarchy fornece? | Recomendação |
|--------|-------------------|--------------|
| neovim | ✅ Sim | Use overlay se sua config é muito diferente |
| tmux | ✅ Sim | Sua config tem sesh/resurrect — vale substituir |
| ghostty | ✅ Sim | Compare temas antes de substituir |
| zsh | ✅ Sim | Overlay é seguro — os aliases são aditivos |
| starship | ✅ Sim | Substitua se você tem prompt customizado |
| git | ❌ Parcial | Sempre aplique (configuração pessoal) |
| bash | ❌ Não | Sempre aplique (configuração pessoal) |
| mise | ❌ Não | Sempre aplique (tool versions pessoais) |

## Restaurando Configs do Omarchy

Se você aplicou seus dotfiles e quer voltar ao Omarchy:

```bash
# Ver backups disponíveis
make backup

# Restaurar um backup
make restore

# Ou via installer
./install.sh uninstall
```

## Dicas para Coexistência

### Aliases e Funções Personalizadas

Ao invés de modificar o `.zshrc` principal (que o Omarchy gerencia), considere criar `~/.zshrc_local` e source-á-lo:

```bash
# No final do seu .zshrc
[[ -f ~/.zshrc_local ]] && source ~/.zshrc_local
```

### Neovim

Se o Omarchy usa LazyVim e você usa kickstart.nvim, são configs **completamente diferentes**. No overlay mode, escolha uma ou outra. Suas config custom plugins (copilot, octo, oil, smart-splits) podem ser adaptados para qualquer base.

### tmux

Sua config tmux tem integrações importantes (sesh, resurrect, continuum, vim-tmux-navigator) que provavelmente são mais completas que a do Omarchy. Recomendo substituir.

### GPG/SSH

Os configs de GPG agent são compartilhados entre bash e zsh. Funciona em ambos os ambientes sem conflito.

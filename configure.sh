#!/bin/bash

source ./setup/apps.sh
source ./setup/utils.sh
config_dir="$(pwd)/configs"

# -------------------------
# Função para configurar apps com stow
#

configure_app() {
  local app="$1"
  gum spin --spinner "dot" --title "Configuring app $app..." -- env app="$app" bash -c 'source ./setup/apps.sh; apply_stow_config "'"$config_dir"'" "$app"'
}

# -------------------------
# Configurar apps obrigatórios
#

required_configs=(
  "neovim"
  "ghostty"
  "zsh"
  "bash"
  "tools"
)

echo "🔧 Configurando aplicações obrigatórias..."
for app in "${required_configs[@]}"; do
    configure_app "$app"
done

# -------------------------
# Configurar apps opcionais
#

optional_configs=(
  "starship"
  "tmux"
  "git"
)

echo "⚙️ Selecione configurações opcionais para aplicar:"
selected_configs=$(gum choose --no-limit --header "Select configs to apply" "${optional_configs[@]}")
IFS=$'\n' read -rd '' -a selected_configs_array <<<"$selected_configs"

for app in "${selected_configs_array[@]}"; do
    configure_app "$app"
done

echo "✅ Configuração concluída com sucesso!"
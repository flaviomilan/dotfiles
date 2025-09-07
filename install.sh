#!/bin/bash
set -e

source ./setup/apps.sh
source ./setup/utils.sh
config_dir="$(pwd)/configs"

# ------------------------->
#  SETUP
# ------------------------->
install_gum
install_stow

# ------------------------->
#  OS SELECTION
# ------------------------->
gum_header="Select your operating system/profile"
os_profile=$(gum choose --header="$gum_header" "Arch Linux (GUI)" "Arch Linux (WSL)" "macOS")

# ------------------------->
#  DEFINE PACKAGES & INSTALLER
# ------------------------->
required_apps=()
installable_apps=()
CLI_INSTALLER=""
GUI_INSTALLER=""
installed_apps_for_stow=() # Array to track successful installs

case "$os_profile" in
  "Arch Linux (GUI)")
    mapfile -t required_apps < <(cat ./setup/packages_arch_cli.txt)
    mapfile -t installable_apps < <(cat ./setup/packages_arch_gui.txt)
    CLI_INSTALLER="sudo pacman -S --noconfirm"
    GUI_INSTALLER="sudo pacman -S --noconfirm"
    ;; 
  "Arch Linux (WSL)")
    mapfile -t required_apps < <(cat ./setup/packages_arch_cli.txt)
    CLI_INSTALLER="sudo pacman -S --noconfirm"
    GUI_INSTALLER="sudo pacman -S --noconfirm" # Won't be used, but set for consistency
    ;; 
  "macOS")
    mapfile -t required_apps < <(cat ./setup/packages_macos_cli.txt)
    mapfile -t installable_apps < <(cat ./setup/packages_macos_gui.txt)
    CLI_INSTALLER="brew install"
    GUI_INSTALLER="brew install --cask"
    ;; 
esac

# ------------------------->
#  INSTALLATION FUNCTION
# ------------------------->
install_and_configure() {
  local app="$1"
  local installer_cmd="$2"

  local install_sub_command="env app='$app' INSTALLER_CMD='$installer_cmd' os_profile='$os_profile' bash -c 'set -e; source ./setup/apps.sh; check_and_install \"$app\"'"

  if gum spin --spinner "dot" --title "Installing app '$app'..." -- bash -c "$install_sub_command"; then
    # On success, add to our list for stow
    installed_apps_for_stow+=("$app")
  else
    gum format -- "## ⚠️  Failed to install '$app'. Skipping." 
  fi
}

# ------------------------->
#  EXECUTION: SYSTEM PACKAGES
# ------------------------->

# Install required apps (CLI)
if [ ${#required_apps[@]} -gt 0 ]; then
    gum format -- "## Installing required applications..."
    for app in "${required_apps[@]}"; do
        install_and_configure "$app" "$CLI_INSTALLER"
    done
fi

# Install optional apps (GUI)
if [ ${#installable_apps[@]} -gt 0 ]; then
    gum format -- "## Installing optional applications..."
    selected_apps=$(gum choose --no-limit --selected --header "Select desired optional apps" "${installable_apps[@]}")
    if [ -n "$selected_apps" ]; then
        IFS=$'\n' read -rd '' -a selected_apps_array <<<"$selected_apps"
        for app in "${selected_apps_array[@]}"; do
            install_and_configure "$app" "$GUI_INSTALLER"
        done
    fi
fi

# --------------------------------
#  EXECUTION: MISE TOOLCHAINS
# --------------------------------
if [[ " ${installed_apps_for_stow[*]} " =~ " mise " ]]; then
    gum format -- "## Installing toolchains with mise..."
    mise_command="export PATH=\"$HOME/.local/bin:$PATH\"; mise install"
    bash -c "$mise_command"
else
    gum format -- "## mise not installed, skipping toolchain installation."
fi

# --------------------------
# AUTOMATIC STOW APPLICATION
# --------------------------
gum format -- "## Applying configurations..."

stow_configs_base=("bash" "tools" "git" "zsh")

# Combine base configs with configs for installed apps and get unique values
all_stow_configs=()
mapfile -t all_stow_configs < <( (printf "%s\n" "${stow_configs_base[@]}" "${installed_apps_for_stow[@]}") | sort -u)

for config in "${all_stow_configs[@]}"; do
    # Check if the config directory exists before trying to apply it
    if [ -d "$config_dir/$config" ]; then
        gum spin --spinner "dot" --title "Applying '$config' configuration..." -- bash -c "source ./setup/utils.sh; source ./setup/apps.sh; apply_stow_config '$config_dir' '$config'"
    fi
done

gum format -- "## ✅ Configuration successfully completed!"
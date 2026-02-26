#!/usr/bin/env bash
# =============================================================================
# stow.sh — GNU Stow wrapper with backup and restore support
# =============================================================================

[[ -n "${_STOW_SH_LOADED:-}" ]] && return 0
_STOW_SH_LOADED=1

# shellcheck source=./logging.sh
source "$(dirname "${BASH_SOURCE[0]}")/logging.sh"

readonly BACKUP_DIR="$HOME/.dotfiles-backup"

# Create a timestamped backup of existing config files before stowing
backup_existing_config() {
  local config_name="$1"
  local config_source_dir="$2"
  local timestamp
  timestamp="$(date +%Y%m%d_%H%M%S)"
  local backup_path="$BACKUP_DIR/$timestamp/$config_name"

  # Discover which files would be stowed
  local files_to_backup=()
  while IFS= read -r -d '' file; do
    local relative="${file#"$config_source_dir/$config_name/"}"
    local target="$HOME/$relative"
    if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
      files_to_backup+=("$relative")
    fi
  done < <(find "$config_source_dir/$config_name" -type f -print0 2>/dev/null)

  if [[ ${#files_to_backup[@]} -eq 0 ]]; then
    return 0
  fi

  log_dim "Backing up existing $config_name config..."
  mkdir -p "$backup_path"

  for file in "${files_to_backup[@]}"; do
    local src="$HOME/$file"
    local dest="$backup_path/$file"
    mkdir -p "$(dirname "$dest")"
    cp -a "$src" "$dest"
    log_dim "  backed up: ~/$file"
  done

  log_dim "Backup saved to: $backup_path"
}

# Apply stow config with optional backup
apply_stow_config() {
  local config_dir="$1"
  local config_name="$2"
  local do_backup="${3:-true}"

  if [[ ! -d "$config_dir/$config_name" ]]; then
    log_warn "Config directory not found: $config_dir/$config_name"
    return 1
  fi

  # Backup if requested
  if [[ "$do_backup" == "true" ]]; then
    backup_existing_config "$config_name" "$config_dir"
  fi

  log_dim "Applying config: $config_name"
  (cd "$config_dir" && stow -t "$HOME" --adopt "$config_name" 2>/dev/null) || {
    log_error "Failed to stow $config_name"
    return 1
  }

  # After --adopt, restore our version from git
  (cd "$config_dir" && git checkout -- "$config_name" 2>/dev/null) || true
}

# Remove stowed config (unstow) and clean empty directories
remove_stow_config() {
  local config_dir="$1"
  local config_name="$2"

  if [[ ! -d "$config_dir/$config_name" ]]; then
    log_warn "Config directory not found: $config_dir/$config_name"
    return 1
  fi

  log_dim "Removing config: $config_name"
  (cd "$config_dir" && stow -t "$HOME" -D "$config_name" 2>/dev/null) || {
    log_error "Failed to unstow $config_name"
    return 1
  }

  # Clean up empty parent directories left behind by stow
  _cleanup_empty_dirs "$config_dir/$config_name"
}

# Remove empty directories in $HOME that were created by stowing a config
_cleanup_empty_dirs() {
  local config_source="$1"

  while IFS= read -r -d '' dir; do
    local relative="${dir#"$config_source/"}"
    local target_dir="$HOME/$relative"

    # Walk up removing empty dirs (but never touch $HOME itself)
    while [[ "$target_dir" != "$HOME" && "$target_dir" != "/" ]]; do
      if [[ -d "$target_dir" ]] && [[ -z "$(ls -A "$target_dir" 2>/dev/null)" ]]; then
        rmdir "$target_dir" 2>/dev/null && log_dim "  cleaned: ~/${target_dir#"$HOME/"}" || break
        target_dir="$(dirname "$target_dir")"
      else
        break
      fi
    done
  done < <(find "$config_source" -type d -print0 2>/dev/null | sort -rz)
}

# List available backups
list_backups() {
  if [[ ! -d "$BACKUP_DIR" ]]; then
    log_info "No backups found"
    return 0
  fi

  log_step "Available backups"
  for dir in "$BACKUP_DIR"/*/; do
    local timestamp
    timestamp="$(basename "$dir")"
    local configs
    configs="$(ls "$dir" 2>/dev/null | tr '\n' ', ')"
    echo "  $timestamp → ${configs%, }"
  done
}

# Restore a backup
restore_backup() {
  local timestamp="$1"
  local backup_path="$BACKUP_DIR/$timestamp"

  if [[ ! -d "$backup_path" ]]; then
    log_error "Backup not found: $timestamp"
    list_backups
    return 1
  fi

  log_step "Restoring backup from $timestamp"

  for config_dir in "$backup_path"/*/; do
    local config_name
    config_name="$(basename "$config_dir")"
    log_dim "Restoring $config_name..."

    find "$config_dir" -type f -print0 | while IFS= read -r -d '' file; do
      local relative="${file#"$config_dir/"}"
      local target="$HOME/$relative"
      mkdir -p "$(dirname "$target")"
      cp -a "$file" "$target"
      log_dim "  restored: ~/$relative"
    done
  done

  log_success "Backup restored successfully"
}

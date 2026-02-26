#!/usr/bin/env bash
# =============================================================================
# stow.sh — GNU Stow wrapper with snapshot-based backup and restore
# =============================================================================

[[ -n "${_STOW_SH_LOADED:-}" ]] && return 0
_STOW_SH_LOADED=1

# shellcheck source=./logging.sh
source "$(dirname "${BASH_SOURCE[0]}")/logging.sh"

readonly BACKUP_DIR="$HOME/.dotfiles-backup"

# =============================================================================
# Snapshot — full pre-install backup
# =============================================================================

# Take a complete snapshot of all files that would be affected by stowing.
# Resolves symlinks so the REAL content is preserved (critical for Omarchy).
#
# Usage: snapshot_create [label] [config1 config2 ...]
snapshot_create() {
  local config_dir="${DOTFILES_CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../configs" && pwd)}"
  local label="${1:-auto}"
  shift 2>/dev/null || true
  local configs=("$@")

  # If no configs specified, snapshot all
  if [[ ${#configs[@]} -eq 0 ]]; then
    for dir in "$config_dir"/*/; do
      [[ -d "$dir" ]] && configs+=("$(basename "$dir")")
    done
  fi

  local timestamp
  timestamp="$(date +%Y%m%d_%H%M%S)"
  local snapshot_id="${timestamp}_${label}"
  local snapshot_path="$BACKUP_DIR/$snapshot_id"

  local total_files=0

  for config_name in "${configs[@]}"; do
    local source_dir="$config_dir/$config_name"
    [[ -d "$source_dir" ]] || continue

    while IFS= read -r -d '' file; do
      local relative="${file#"$source_dir/"}"
      local target="$HOME/$relative"

      # Skip if target doesn't exist at all
      [[ -e "$target" || -L "$target" ]] || continue

      local dest="$snapshot_path/$config_name/$relative"
      mkdir -p "$(dirname "$dest")"

      # Dereference symlinks so we capture the actual file content
      if [[ -L "$target" ]]; then
        local real_target
        real_target="$(readlink -f "$target" 2>/dev/null || true)"
        if [[ -n "$real_target" && -e "$real_target" ]]; then
          cp -a "$real_target" "$dest"
          total_files=$((total_files + 1))
        fi
      elif [[ -f "$target" ]]; then
        cp -a "$target" "$dest"
        total_files=$((total_files + 1))
      fi
    done < <(find "$source_dir" -type f -print0 2>/dev/null)
  done

  if [[ "$total_files" -eq 0 ]]; then
    return 0
  fi

  # Write metadata
  cat > "$snapshot_path/.snapshot-meta" <<EOF
timestamp=$timestamp
label=$label
configs=${configs[*]}
files=$total_files
created=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
EOF

  log_dim "Snapshot created: $snapshot_id ($total_files files)"
  echo "$snapshot_id"
}

# =============================================================================
# Snapshot listing
# =============================================================================

snapshot_list() {
  if [[ ! -d "$BACKUP_DIR" ]]; then
    log_info "No snapshots found"
    return 0
  fi

  local found=0
  for dir in "$BACKUP_DIR"/*/; do
    [[ -d "$dir" ]] || continue
    local id
    id="$(basename "$dir")"
    local meta="$dir/.snapshot-meta"

    if [[ -f "$meta" ]]; then
      local label files configs
      label="$(grep '^label=' "$meta" | cut -d= -f2)"
      files="$(grep '^files=' "$meta" | cut -d= -f2)"
      configs="$(grep '^configs=' "$meta" | cut -d= -f2)"
      printf "  %-28s  %-12s  %s files  [%s]\n" "$id" "$label" "$files" "$configs"
    else
      # Legacy backup (no metadata)
      local file_count
      file_count="$(find "$dir" -type f -not -name '.snapshot-meta' 2>/dev/null | wc -l)"
      local subdirs
      subdirs="$(find "$dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | tr '\n' ' ')"
      if [[ "$file_count" -gt 0 ]]; then
        printf "  %-28s  %-12s  %s files  [%s]\n" "$id" "legacy" "$file_count" "${subdirs% }"
      else
        printf "  %-28s  %-12s  (empty)\n" "$id" "legacy"
      fi
    fi
    found=$((found + 1))
  done

  if [[ "$found" -eq 0 ]]; then
    log_info "No snapshots found"
  fi
}

# =============================================================================
# Snapshot restore
# =============================================================================

# Restore a snapshot. Unstows dotfiles first, then copies original files back.
#
# Usage: snapshot_restore <snapshot_id> [config1 config2 ...]
snapshot_restore() {
  local snapshot_id="$1"
  shift 2>/dev/null || true
  local filter_configs=("$@")

  local snapshot_path="$BACKUP_DIR/$snapshot_id"

  if [[ ! -d "$snapshot_path" ]]; then
    log_error "Snapshot not found: $snapshot_id"
    snapshot_list
    return 1
  fi

  local config_dir="${DOTFILES_CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../configs" && pwd)}"

  # Collect configs to restore
  local configs_to_restore=()
  for dir in "$snapshot_path"/*/; do
    [[ -d "$dir" ]] || continue
    local name
    name="$(basename "$dir")"

    # Apply filter if specified
    if [[ ${#filter_configs[@]} -gt 0 ]]; then
      local match=false
      for fc in "${filter_configs[@]}"; do
        [[ "$fc" == "$name" ]] && match=true
      done
      [[ "$match" == "false" ]] && continue
    fi

    configs_to_restore+=("$name")
  done

  if [[ ${#configs_to_restore[@]} -eq 0 ]]; then
    log_warn "No configs to restore in this snapshot"
    return 1
  fi

  log_step "Restoring snapshot: $snapshot_id"

  for config_name in "${configs_to_restore[@]}"; do
    local source="$snapshot_path/$config_name"

    # Unstow first (remove our symlinks)
    if [[ -d "$config_dir/$config_name" ]]; then
      (cd "$config_dir" && stow -t "$HOME" -D "$config_name" 2>/dev/null) || true
    fi

    # Copy original files back
    find "$source" -type f -not -name '.snapshot-meta' -print0 | while IFS= read -r -d '' file; do
      local relative="${file#"$source/"}"
      local target="$HOME/$relative"
      mkdir -p "$(dirname "$target")"

      # Remove symlink at target if exists
      [[ -L "$target" ]] && rm -f "$target"

      cp -a "$file" "$target"
    done
    log_dim "  Restored: $config_name"
  done

  log_success "Restore complete — restart your shell: exec \$SHELL"
}

# Restore the most recent non-empty snapshot
snapshot_rollback() {
  if [[ ! -d "$BACKUP_DIR" ]]; then
    log_error "No snapshots to rollback to"
    return 1
  fi

  local latest=""
  for dir in "$BACKUP_DIR"/*/; do
    [[ -d "$dir" ]] || continue
    local file_count
    file_count="$(find "$dir" -type f -not -name '.snapshot-meta' 2>/dev/null | wc -l)"
    [[ "$file_count" -gt 0 ]] && latest="$(basename "$dir")"
  done

  if [[ -z "$latest" ]]; then
    log_error "No valid snapshots found (all empty)"
    return 1
  fi

  log_info "Rolling back to: $latest"
  snapshot_restore "$latest"
}

# =============================================================================
# Snapshot diff — preview differences
# =============================================================================

snapshot_diff() {
  local snapshot_id="$1"
  local snapshot_path="$BACKUP_DIR/$snapshot_id"

  if [[ ! -d "$snapshot_path" ]]; then
    log_error "Snapshot not found: $snapshot_id"
    return 1
  fi

  log_step "Changes since snapshot: $snapshot_id"
  for dir in "$snapshot_path"/*/; do
    [[ -d "$dir" ]] || continue
    local config_name
    config_name="$(basename "$dir")"

    find "$dir" -type f -not -name '.snapshot-meta' -print0 | while IFS= read -r -d '' file; do
      local relative="${file#"$dir"}"
      local current="$HOME/$relative"

      if [[ ! -e "$current" && ! -L "$current" ]]; then
        echo -e "  \033[31mdeleted\033[0m   ~/$relative"
      elif [[ -L "$current" ]]; then
        echo -e "  \033[33mreplaced\033[0m  ~/$relative → symlink"
      elif ! diff -q "$file" "$current" &>/dev/null; then
        echo -e "  \033[33mmodified\033[0m  ~/$relative"
      fi
    done
  done
}

# =============================================================================
# Snapshot cleanup — keep N most recent
# =============================================================================

snapshot_cleanup() {
  local keep="${1:-5}"

  if [[ ! -d "$BACKUP_DIR" ]]; then
    return 0
  fi

  local snapshots=()
  for dir in "$BACKUP_DIR"/*/; do
    [[ -d "$dir" ]] && snapshots+=("$dir")
  done

  local total=${#snapshots[@]}
  if [[ "$total" -le "$keep" ]]; then
    log_dim "Only $total snapshots — nothing to clean"
    return 0
  fi

  local to_remove=$((total - keep))
  log_info "Removing $to_remove old snapshot(s), keeping $keep most recent"

  for ((i = 0; i < to_remove; i++)); do
    local dir="${snapshots[$i]}"
    rm -rf "$dir"
    log_dim "  removed: $(basename "$dir")"
  done
}

# =============================================================================
# Stow operations
# =============================================================================

apply_stow_config() {
  local config_dir="$1"
  local config_name="$2"
  local do_backup="${3:-true}"

  if [[ ! -d "$config_dir/$config_name" ]]; then
    log_warn "Config directory not found: $config_dir/$config_name"
    return 1
  fi

  export DOTFILES_CONFIG_DIR="$config_dir"

  # Snapshot BEFORE stow — captures real content, resolves symlinks
  if [[ "$do_backup" == "true" ]]; then
    snapshot_create "pre-stow" "$config_name" >/dev/null
  fi

  log_dim "Applying config: $config_name"
  (cd "$config_dir" && stow -t "$HOME" --adopt "$config_name" 2>/dev/null) || {
    log_error "Failed to stow $config_name"
    return 1
  }

  # After --adopt, restore our dotfiles version from git
  (cd "$config_dir" && git checkout -- "$config_name" 2>/dev/null) || true
}

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

  _cleanup_empty_dirs "$config_dir/$config_name"
}

_cleanup_empty_dirs() {
  local config_source="$1"

  while IFS= read -r -d '' dir; do
    local relative="${dir#"$config_source/"}"
    local target_dir="$HOME/$relative"

    while [[ "$target_dir" != "$HOME" && "$target_dir" != "/" ]]; do
      if [[ -d "$target_dir" ]] && [[ -z "$(ls -A "$target_dir" 2>/dev/null)" ]]; then
        rmdir "$target_dir" 2>/dev/null || break
        target_dir="$(dirname "$target_dir")"
      else
        break
      fi
    done
  done < <(find "$config_source" -type d -print0 2>/dev/null | sort -rz)
}

# Legacy compat
list_backups() { log_step "Snapshots"; snapshot_list; }
restore_backup() { snapshot_restore "$@"; }

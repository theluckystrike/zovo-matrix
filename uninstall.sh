#!/usr/bin/env bash
# ============================================================
# zovo-matrix uninstaller
# Cleanly removes the Matrix Terminal Theme
# ============================================================
set -euo pipefail

# ── Colors ───────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
BGREEN='\033[1;32m'
DGREEN='\033[2;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

info()    { printf "${GREEN}[*]${RESET} %s\n" "$*"; }
success() { printf "${BGREEN}[+]${RESET} %s\n" "$*"; }
warn()    { printf "${YELLOW}[!]${RESET} %s\n" "$*"; }
error()   { printf "${RED}[-]${RESET} %s\n" "$*"; }

BACKUP_DIR="$HOME/.zovo-matrix-backup"
MARKER="# Matrix Theme"

echo ""
printf "${BGREEN}  zovo-matrix uninstaller${RESET}\n"
printf "${GREEN}[*]${RESET} Disconnecting from the Matrix...\n"
echo ""

# ── Remove Matrix Theme block from .zshrc ────────────────────
if [[ -f "$HOME/.zshrc" ]] && grep -q "$MARKER" "$HOME/.zshrc" 2>/dev/null; then
    info "Restoring simulation in .zshrc..."

    # Find the "============" separator line immediately before "# Matrix Theme"
    # The block starts at the first "===..." line that precedes "# Matrix Theme"
    # and runs to the end of the file.
    ZSHRC="$HOME/.zshrc"

    # Get the line number of "# Matrix Theme"
    marker_line=$(grep -n "^# Matrix Theme" "$ZSHRC" | head -1 | cut -d: -f1)

    if [[ -n "$marker_line" ]]; then
        # The separator line is one above
        start_line=$((marker_line - 1))

        # Verify it is indeed a separator line
        line_content=$(sed -n "${start_line}p" "$ZSHRC")
        if [[ "$line_content" =~ ^#\ =+ ]]; then
            # Keep everything before the separator
            head -n "$((start_line - 1))" "$ZSHRC" > "$ZSHRC.tmp"
            # Remove trailing blank lines
            sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$ZSHRC.tmp" > "$ZSHRC"
            rm -f "$ZSHRC.tmp"
            success "Removed Matrix Theme block from .zshrc"
        else
            # Fallback: just remove from the marker line onward
            head -n "$((marker_line - 1))" "$ZSHRC" > "$ZSHRC.tmp"
            mv "$ZSHRC.tmp" "$ZSHRC"
            success "Removed Matrix Theme block from .zshrc (fallback method)"
        fi
    else
        warn "Found marker but could not determine line number; skipping .zshrc cleanup"
    fi
else
    info "No Matrix Theme block found in .zshrc -- nothing to remove"
fi

# ── Remove installed theme files ─────────────────────────────
info "Unplugging construct..."

remove_if_exists() {
    if [[ -f "$1" ]]; then
        rm "$1"
        success "Removed $1"
    fi
}

remove_if_exists "$HOME/.p10k-matrix.zsh"
remove_if_exists "$HOME/.matrix-motd.sh"
remove_if_exists "$HOME/.config/fastfetch/config.jsonc"

# ── Restore backed-up files ──────────────────────────────────
if [[ -d "$BACKUP_DIR" ]]; then
    info "Restoring simulation from $BACKUP_DIR ..."

    restore_if_exists() {
        local backup="$BACKUP_DIR/$1"
        local target="$2"
        if [[ -f "$backup" ]]; then
            cp "$backup" "$target"
            success "Restored $target"
        fi
    }

    restore_if_exists "zshrc"                  "$HOME/.zshrc"
    restore_if_exists "p10k.zsh"               "$HOME/.p10k.zsh"
    restore_if_exists "p10k-matrix.zsh"        "$HOME/.p10k-matrix.zsh"
    restore_if_exists "matrix-motd.sh"         "$HOME/.matrix-motd.sh"
    restore_if_exists "fastfetch-config.jsonc"  "$HOME/.config/fastfetch/config.jsonc"

    rm -rf "$BACKUP_DIR"
    success "Removed backup directory"
else
    info "No backup directory found -- skipping restore"
fi

# ── Optionally remove brew packages ─────────────────────────
echo ""
read -rp "$(printf "${YELLOW}[?]${RESET} Remove brew packages (cmatrix, fastfetch, zsh-syntax-highlighting, zsh-autosuggestions, tree)? [y/N] ")" remove_pkgs
if [[ "$remove_pkgs" =~ ^[Yy]$ ]]; then
    BREW_PACKAGES=(cmatrix fastfetch zsh-syntax-highlighting zsh-autosuggestions tree)
    for pkg in "${BREW_PACKAGES[@]}"; do
        if brew list "$pkg" &>/dev/null; then
            brew uninstall "$pkg"
            success "Uninstalled $pkg"
        else
            info "$pkg not installed -- skipping"
        fi
    done
else
    info "Keeping brew packages"
fi

echo ""
printf "${DGREEN}"
cat << 'EOF'
  ┌──────────────────────────────────────────────────────┐
  │                                                      │
  │   Matrix Theme has been removed.                     │
  │                                                      │
  │   You have taken the blue pill. Goodbye.             │
  │                                                      │
  │   Restart your terminal to complete the process.     │
  │                                                      │
  └──────────────────────────────────────────────────────┘
EOF
printf "${RESET}"
echo ""

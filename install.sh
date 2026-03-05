#!/usr/bin/env bash
# ============================================================
# zovo-matrix installer
# Matrix Terminal Theme for macOS / zsh
# ============================================================
set -euo pipefail

# ── Colors ───────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
BGREEN='\033[1;32m'
DGREEN='\033[2;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# ── Helpers ──────────────────────────────────────────────────
info()    { printf "${GREEN}[*]${RESET} %s\n" "$*"; }
success() { printf "${BGREEN}[+]${RESET} %s\n" "$*"; }
warn()    { printf "${YELLOW}[!]${RESET} %s\n" "$*"; }
error()   { printf "${RED}[-]${RESET} %s\n" "$*"; }
fatal()   { error "$*"; exit 1; }

matrix_quote() {
  local q=(
    "There is no spoon."
    "Follow the white rabbit."
    "The Matrix has you..."
    "Free your mind."
    "I know kung fu."
    "Whoa."
  )
  printf "${DGREEN}  \"%s\"${RESET}\n" "${q[$((RANDOM % ${#q[@]}))]}"
}

# ── Matrix Visual Effects ─────────────────────────────────
MATRIX_CHARS="アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン0123456789ABCDEFZ"

matrix_rain() {
    local lines="${1:-2}"
    local cols
    cols=$(tput cols 2>/dev/null || echo 80)
    printf "${GREEN}"
    for ((l=0; l<lines; l++)); do
        local line=""
        for ((c=0; c<cols; c++)); do
            if (( RANDOM % 3 == 0 )); then
                local idx=$(( RANDOM % ${#MATRIX_CHARS} ))
                line+="${MATRIX_CHARS:$idx:1}"
            else
                line+=" "
            fi
        done
        printf "%s\n" "$line"
        sleep 0.01
    done
    printf "${RESET}"
}

matrix_spinner() {
    local msg="$1"
    local duration="${2:-1}"
    local spin_chars='|/-\\'
    local end_time=$(( $(date +%s) + duration ))
    printf "${GREEN}[*]${RESET} %s " "$msg"
    while (( $(date +%s) < end_time )); do
        for ((i=0; i<${#spin_chars}; i++)); do
            printf "\b%s" "${spin_chars:$i:1}"
            sleep 0.1
        done
    done
    printf "\b \n"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_DIR="$SCRIPT_DIR/theme"
BACKUP_DIR="$HOME/.zovo-matrix-backup"
MARKER="# Matrix Theme"

# ── Uninstall ────────────────────────────────────────────────
do_uninstall() {
    info "Disconnecting from the Matrix..."
    echo ""

    # Remove Matrix Theme block from .zshrc
    if grep -q "$MARKER" "$HOME/.zshrc" 2>/dev/null; then
        info "Restoring simulation in .zshrc..."
        # Delete from the "===...===" line before "# Matrix Theme" to end of file
        sed -i '' '/^# =\+$/,/^# =\+$/{
            /# Matrix Theme/,$ d
        }' "$HOME/.zshrc" 2>/dev/null || true
        # More robust: delete from the marker line block to EOF
        # Find the line number of the first "============" before "# Matrix Theme"
        local start_line
        start_line=$(grep -n "^# =\{5,\}" "$HOME/.zshrc" | tail -1 | cut -d: -f1)
        if [[ -n "$start_line" ]]; then
            head -n "$((start_line - 1))" "$HOME/.zshrc" > "$HOME/.zshrc.tmp"
            mv "$HOME/.zshrc.tmp" "$HOME/.zshrc"
            success "Removed Matrix Theme block from .zshrc"
        else
            warn "Could not locate Matrix Theme block boundaries; manual cleanup may be needed"
        fi
    else
        info "No Matrix Theme block found in .zshrc — skipping"
    fi

    # Restore backed-up files
    if [[ -d "$BACKUP_DIR" ]]; then
        info "Restoring simulation..."
        for backup_file in "$BACKUP_DIR"/*; do
            [[ -f "$backup_file" ]] || continue
            local base
            base="$(basename "$backup_file")"
            local target="$HOME/.$base"
            cp "$backup_file" "$target"
            success "Restored $target"
        done
        rm -rf "$BACKUP_DIR"
    else
        info "No backup directory found — skipping restore"
    fi

    # Remove installed theme files
    [[ -f "$HOME/.p10k-matrix.zsh" ]] && rm "$HOME/.p10k-matrix.zsh" && success "Removed ~/.p10k-matrix.zsh"
    [[ -f "$HOME/.matrix-motd.sh" ]]  && rm "$HOME/.matrix-motd.sh"  && success "Removed ~/.matrix-motd.sh"
    if [[ -f "$HOME/.config/fastfetch/config.jsonc" ]]; then
        rm "$HOME/.config/fastfetch/config.jsonc"
        success "Removed ~/.config/fastfetch/config.jsonc"
    fi

    # Optionally remove brew packages
    echo ""
    read -rp "$(printf "${YELLOW}[?]${RESET} Remove brew packages (cmatrix, fastfetch, zsh-syntax-highlighting, zsh-autosuggestions, tree)? [y/N] ")" remove_pkgs
    if [[ "$remove_pkgs" =~ ^[Yy]$ ]]; then
        local pkgs=(cmatrix fastfetch zsh-syntax-highlighting zsh-autosuggestions tree)
        for pkg in "${pkgs[@]}"; do
            if brew list "$pkg" &>/dev/null; then
                brew uninstall "$pkg"
                success "Uninstalled $pkg"
            fi
        done
    fi

    echo ""
    success "You have taken the blue pill. Goodbye."
    info "Restart your terminal for changes to take effect."
    exit 0
}

# ── Parse flags ──────────────────────────────────────────────
if [[ "${1:-}" == "--uninstall" ]]; then
    do_uninstall
fi

# ── Banner ───────────────────────────────────────────────────
matrix_rain 3
echo ""
printf "${BGREEN}"
cat << 'BANNER'
  ███████╗ ██████╗ ██╗   ██╗ ██████╗       ███╗   ███╗ █████╗ ████████╗██████╗ ██╗██╗  ██╗
  ╚══███╔╝██╔═══██╗██║   ██║██╔═══██╗      ████╗ ████║██╔══██╗╚══██╔══╝██╔══██╗██║╚██╗██╔╝
    ███╔╝ ██║   ██║██║   ██║██║   ██║█████╗██╔████╔██║███████║   ██║   ██████╔╝██║ ╚███╔╝
   ███╔╝  ██║   ██║╚██╗ ██╔╝██║   ██║╚════╝██║╚██╔╝██║██╔══██║   ██║   ██╔══██╗██║ ██╔██╗
  ███████╗╚██████╔╝ ╚████╔╝ ╚██████╔╝      ██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║██║██╔╝ ██╗
  ╚══════╝ ╚═════╝   ╚═══╝   ╚═════╝       ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝
BANNER
printf "${RESET}"
echo ""
info "Matrix Terminal Theme Installer"
echo ""
matrix_spinner "Connecting to the Matrix..." 1

# ── OS Detection ─────────────────────────────────────────────
OS="$(uname -s)"
if [[ "$OS" == "Darwin" ]]; then
    success "Detected macOS"
elif [[ "$OS" == "Linux" ]]; then
    warn "Linux detected -- this theme is designed for macOS."
    warn "Some features (Terminal.app colors, osascript) will be skipped."
    read -rp "$(printf "${YELLOW}[?]${RESET} Continue anyway? [y/N] ")" linux_continue
    [[ "$linux_continue" =~ ^[Yy]$ ]] || exit 0
else
    fatal "Unsupported OS: $OS"
fi

# ── Dependency Checks ────────────────────────────────────────
info "Initiating connection..."

# zsh
if command -v zsh &>/dev/null; then
    success "zsh found: $(zsh --version | head -1)"
else
    fatal "zsh is required but not found. Please install zsh first."
fi

# Homebrew
if command -v brew &>/dev/null; then
    success "Homebrew found"
else
    fatal "Homebrew is required but not found. Install from https://brew.sh"
fi

# Oh My Zsh
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    success "Oh My Zsh found"
else
    fatal "Oh My Zsh is required but not found. Install from https://ohmyz.sh"
fi

# Powerlevel10k
P10K_FOUND=false
if [[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    P10K_FOUND=true
    success "Powerlevel10k found (oh-my-zsh custom theme)"
elif brew list powerlevel10k &>/dev/null; then
    P10K_FOUND=true
    success "Powerlevel10k found (Homebrew)"
fi
if [[ "$P10K_FOUND" == false ]]; then
    fatal "Powerlevel10k is required but not found. Install via: brew install powerlevel10k"
fi

matrix_quote
echo ""

# ── Install Brew Packages ────────────────────────────────────
BREW_PACKAGES=(cmatrix fastfetch zsh-syntax-highlighting zsh-autosuggestions tree)

info "Downloading construct..."
for pkg in "${BREW_PACKAGES[@]}"; do
    if brew list "$pkg" &>/dev/null; then
        success "$pkg already installed"
    else
        info "Installing $pkg..."
        if brew install "$pkg"; then
            success "$pkg installed"
        else
            warn "Failed to install $pkg -- continuing anyway"
        fi
    fi
done

matrix_quote
echo ""

# ── Backup Existing Files ────────────────────────────────────
info "Backing up existing files to $BACKUP_DIR ..."
mkdir -p "$BACKUP_DIR"

backup_if_exists() {
    local src="$1"
    local name="$2"
    if [[ -f "$src" ]]; then
        cp "$src" "$BACKUP_DIR/$name"
        success "Backed up $src"
    fi
}

backup_if_exists "$HOME/.p10k.zsh"       "p10k.zsh"
backup_if_exists "$HOME/.p10k-matrix.zsh" "p10k-matrix.zsh"
backup_if_exists "$HOME/.matrix-motd.sh"  "matrix-motd.sh"
backup_if_exists "$HOME/.config/fastfetch/config.jsonc" "fastfetch-config.jsonc"

echo ""

# ── Copy Theme Files ─────────────────────────────────────────
info "Loading the construct..."

# p10k-matrix.zsh
cp "$THEME_DIR/p10k-matrix.zsh" "$HOME/.p10k-matrix.zsh"
success "Installed ~/.p10k-matrix.zsh"

# matrix-motd.sh
cp "$THEME_DIR/matrix-motd.sh" "$HOME/.matrix-motd.sh"
chmod +x "$HOME/.matrix-motd.sh"
success "Installed ~/.matrix-motd.sh"

# fastfetch config
mkdir -p "$HOME/.config/fastfetch"
cp "$THEME_DIR/fastfetch-config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
success "Installed ~/.config/fastfetch/config.jsonc"

matrix_quote
echo ""

# ── Patch .zshrc ─────────────────────────────────────────────
info "Rewriting reality..."

if grep -q "$MARKER" "$HOME/.zshrc" 2>/dev/null; then
    success "Matrix Theme block already present in .zshrc -- skipping"
else
    # Backup .zshrc
    cp "$HOME/.zshrc" "$BACKUP_DIR/zshrc"
    success "Backed up ~/.zshrc"

    # Append the Matrix block
    printf "\n" >> "$HOME/.zshrc"
    cat "$THEME_DIR/zshrc-matrix-block.sh" >> "$HOME/.zshrc"
    success "Added Matrix Theme block to .zshrc"
fi

matrix_quote
echo ""

# ── Terminal.app Colors (macOS only) ─────────────────────────
if [[ "$OS" == "Darwin" ]]; then
    info "Jacking into Terminal.app..."
    osascript -e '
    tell application "Terminal"
        set bgColor to {0, 0, 0}
        set txtColor to {0, 52428, 0}
        set boldColor to {0, 65535, 0}
        set curColor to {0, 65535, 0}
        try
            set background color of settings set "Basic" to bgColor
            set normal text color of settings set "Basic" to txtColor
            set bold text color of settings set "Basic" to boldColor
            set cursor color of settings set "Basic" to curColor
        end try
        try
            set current settings of front window to settings set "Basic"
        end try
    end tell
    ' 2>/dev/null && success "Terminal.app colors set" || warn "Could not set Terminal.app colors (are you using a different terminal?)"
fi

echo ""

# ── Success Message ──────────────────────────────────────────
matrix_rain 2
echo ""
printf "${DGREEN}"
cat << 'EOF'
  ┌──────────────────────────────────────────────────────┐
  │                                                      │
  │   M A T R I X   T H E M E   I N S T A L L E D       │
  │                                                      │
  │   "The Matrix is everywhere. It is all around us."   │
  │                                                      │
  │   You are now in The Matrix.                         │
  │                                                      │
  │   Commands:                                          │
  │     matrix       - Launch cmatrix screensaver        │
  │     neo          - System dashboard                  │
  │     red-pill     - System info via fastfetch         │
  │     wake-up-neo  - The classic typewriter intro      │
  │     scan [dir]   - Matrix-style directory scan       │
  │     decode TEXT  - Typewriter text effect             │
  │                                                      │
  │   To uninstall:                                      │
  │     ./install.sh --uninstall                         │
  │                                                      │
  └──────────────────────────────────────────────────────┘
EOF
printf "${RESET}"
echo ""

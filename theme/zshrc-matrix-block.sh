# ============================================================
# Matrix Theme
# ============================================================

# Matrix green LS_COLORS (GNU/Linux style)
export LS_COLORS='di=1;92:ex=0;92:ln=0;32:*.tar=0;32:*.gz=0;32:*.zip=0;32:*.7z=0;32:*.bz2=0;32:*.xz=0;32:*.rar=0;32'
# macOS BSD LSCOLORS (11 pairs: dir, symlink, socket, pipe, exec, block, char, setuid, setgid, sticky-dir, no-sticky-dir)
export LSCOLORS='CxcxxxxxBxxxxxxxxxxxxx'

# Grep highlight in green
export GREP_COLOR='1;32'

# Matrix aliases
alias matrix='cmatrix -b -C green'

wake-up-neo() {
  local lines=("Wake up, Neo..." "The Matrix has you..." "Follow the white rabbit.")
  for line in "${lines[@]}"; do
    for (( i=0; i<${#line}; i++ )); do
      printf '\033[1;32m%s\033[0m' "${line:$i:1}"
      sleep 0.05
    done
    echo
    sleep 0.8
  done
}

red-pill() { fastfetch; }

# Terminal title: show "The Matrix" or current directory
precmd_matrix_title() {
  print -Pn "\e]2;The Matrix [%~]\a"
}
[[ -z "$precmd_functions" ]] && precmd_functions=()
precmd_functions+=(precmd_matrix_title)

# ── Matrix Utility Commands ──────────────────────────────────

# neo — System dashboard with key info in a formatted green table
neo() {
  local G='\033[0;32m' BG='\033[1;32m' DG='\033[2;32m' R='\033[0m'
  echo ""
  printf "${BG}  %-12s${R} ${G}%s${R}\n" "Host" "$(scutil --get ComputerName)"
  printf "${BG}  %-12s${R} ${G}%s${R}\n" "OS" "$(sw_vers -productName) $(sw_vers -productVersion)"
  printf "${BG}  %-12s${R} ${G}%s${R}\n" "Shell" "$SHELL ($ZSH_VERSION)"
  printf "${BG}  %-12s${R} ${G}%s${R}\n" "CPU" "$(sysctl -n machdep.cpu.brand_string)"
  printf "${BG}  %-12s${R} ${G}%s${R}\n" "Memory" "$(( $(sysctl -n hw.memsize) / 1073741824 )) GB"
  printf "${BG}  %-12s${R} ${G}%s${R}\n" "Disk" "$(df -h / | awk 'NR==2{print $3 " used / " $2 " (" $5 ")"}')"
  printf "${BG}  %-12s${R} ${G}%s${R}\n" "Battery" "$(pmset -g batt | grep -o '[0-9]*%' | head -1)"
  printf "${BG}  %-12s${R} ${G}%s${R}\n" "IP" "$(ipconfig getifaddr en0 2>/dev/null || echo 'offline')"
  printf "${BG}  %-12s${R} ${G}%s${R}\n" "Uptime" "$(uptime | sed 's/.*up //' | sed 's/,.*//')"
  echo ""
}

# decode — Render text char-by-char like a Matrix terminal (0.02s per char)
decode() {
  local text="${*:-Access granted.}"
  local G='\033[1;32m' R='\033[0m'
  for (( i=0; i<${#text}; i++ )); do
    printf "${G}%s${R}" "${text:$i:1}"
    sleep 0.02
  done
  echo ""
}

# scan — Matrix-style directory summary
scan() {
  local dir="${1:-.}"
  local G='\033[0;32m' BG='\033[1;32m' DG='\033[2;32m' R='\033[0m'
  local files=$(find "$dir" -maxdepth 1 -type f | wc -l | tr -d ' ')
  local dirs=$(find "$dir" -maxdepth 1 -type d | wc -l | tr -d ' ')
  dirs=$((dirs - 1))
  local size=$(du -sh "$dir" 2>/dev/null | cut -f1)
  echo ""
  printf "  ${BG}Scanning${R} ${G}%s${R}\n" "$(realpath "$dir")"
  printf "  ${DG}─────────────────────────────${R}\n"
  printf "  ${G}Files${R}       %s\n" "$files"
  printf "  ${G}Dirs${R}        %s\n" "$dirs"
  printf "  ${G}Total size${R}  %s\n" "$size"
  echo ""
}

# tree-scan — Green-tinted tree view (replaces blue dirs with green)
alias tree-scan='tree -C --dirsfirst -L 2 | sed "s/\x1b\[01;34m/\x1b[1;32m/g"'

# Syntax highlighting — Matrix green theme
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=green'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=034'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=034'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=034'
ZSH_HIGHLIGHT_STYLES[default]='fg=green'

# Autosuggestions — dim green for subtle hints
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=022'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Matrix MOTD welcome message
source ~/.matrix-motd.sh

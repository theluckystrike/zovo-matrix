#!/bin/bash
# Matrix MOTD — clean edition

G='\033[0;32m'      # green
BG='\033[1;32m'     # bold green
DG='\033[2;32m'     # dim green
IT='\033[2;3;32m'   # dim italic green
R='\033[0m'         # reset

W=52  # inner width

row() {
  # Print a row with content padded to exact inner width
  # Usage: row "visible text" "formatted text"
  # $1 = plain text (for length calc), $2 = formatted text (for display)
  local plain="$1"
  local formatted="$2"
  local pad=$(( W - ${#plain} ))
  printf "  ${DG}│${R} %b%*s ${DG}│${R}\n" "$formatted" "$pad" ""
}

# Gather data
cur_date=$(date '+%a %b %d, %Y')
cur_time=$(date '+%H:%M:%S')
cur_up=$(uptime | sed 's/.*up //' | sed 's/,.*//')

# Quotes
quotes=(
  "There is no spoon."
  "Welcome to the real world."
  "The Matrix has you..."
  "Follow the white rabbit."
  "I know kung fu."
  "Free your mind."
  "Not like this... not like this."
  "Denial is the most predictable of all human responses."
  "Everything that has a beginning has an end."
  "What is real? How do you define real?"
)
quote="${quotes[$((RANDOM % ${#quotes[@]}))]}"

# Draw box
echo ""
printf "  ${DG}┌"; printf '─%.0s' $(seq 1 $W); printf "┐${R}\n"

printf "  ${DG}│${R}                                                    ${DG}│${R}\n"
printf "  ${DG}│${R}  ${BG}███╗   ███╗ █████╗ ████████╗██████╗ ██╗██╗  ██╗${R}  ${DG}│${R}\n"
printf "  ${DG}│${R}  ${BG}████╗ ████║██╔══██╗╚══██╔══╝██╔══██╗██║╚██╗██╔╝${R}  ${DG}│${R}\n"
printf "  ${DG}│${R}  ${BG}██╔████╔██║███████║   ██║   ██████╔╝██║ ╚███╔╝${R}   ${DG}│${R}\n"
printf "  ${DG}│${R}  ${G}██║╚██╔╝██║██╔══██║   ██║   ██╔══██╗██║ ██╔██╗${R}   ${DG}│${R}\n"
printf "  ${DG}│${R}  ${G}██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║██║██╔╝ ██╗${R}  ${DG}│${R}\n"
printf "  ${DG}│${R}  ${DG}╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝${R}  ${DG}│${R}\n"
printf "  ${DG}│${R}                                                    ${DG}│${R}\n"
row " Date    ${cur_date}" " ${G}Date${R}    ${cur_date}"
row " Time    ${cur_time}" " ${G}Time${R}    ${cur_time}"
row " Uptime  ${cur_up}" " ${G}Uptime${R}  ${cur_up}"
row "" ""

printf "  ${DG}└"; printf '─%.0s' $(seq 1 $W); printf "┘${R}\n"

# Quote below the box
echo ""
echo -e "    ${IT}\"${quote}\"${R}"
echo ""

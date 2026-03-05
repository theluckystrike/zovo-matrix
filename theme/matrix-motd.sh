#!/bin/bash
# Matrix MOTD — clean edition

G='\033[0;32m'      # green
BG='\033[1;32m'     # bold green
DG='\033[2;32m'     # dim green
IT='\033[2;3;32m'   # dim italic green
R='\033[0m'         # reset

W=52  # inner width

matrix_rain() {
  local chars=(ﾊ ﾐ ﾋ ｰ ｳ ｼ ﾅ ﾓ ﾆ ｻ ﾜ ﾂ ｵ ﾘ ｱ ﾎ ﾃ ﾏ ｹ ﾒ ｴ ｶ ｷ ﾑ ﾕ ﾗ ｾ ﾈ ｽ ﾀ ﾇ ﾍ 0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
  local nchars=${#chars[@]}
  local shades=('\033[1;32m' '\033[0;32m' '\033[0;32m' '\033[0;32m' '\033[0;32m' '\033[2;32m' '\033[2;32m' '\033[2;32m' '\033[1;32m' '\033[1;32m')
  local nshades=${#shades[@]}
  local line row_idx
  for row_idx in 1 2 3 4 5 6 7 8; do
    line="  "
    for i in $(seq 1 27); do
      local c="${chars[$((RANDOM % nchars))]}"
      local s="${shades[$((RANDOM % nshades))]}"
      if (( i < 27 )); then
        line+="${s}${c}\033[0m "
      else
        line+="${s}${c}\033[0m"
      fi
    done
    printf "%b\n" "$line"
  done
}

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
  "Guns. Lots of guns."
  "The answer is out there, Neo."
  "You have to let it all go. Fear, doubt, and disbelief."
  "Choice. The problem is choice."
  "Do you believe in fate, Neo?"
  "I've been looking for you, Neo."
  "Remember, all I'm offering is the truth."
  "To deny our own impulses is to deny the very thing that makes us human."
  "You've been living in a dream world, Neo."
  "Hope. It is the quintessential human delusion."
)
quote="${quotes[$((RANDOM % ${#quotes[@]}))]}"

# Matrix rain wall
echo ""
matrix_rain
echo ""

# Draw box
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

# # # #!/bin/bash

# # # # WRF_DIR="/wrf-project/v1_bretagne_9km_24h/src/WRF"
# # # # WRF_DIR="../src/WRF"
# # # WRF_DIR="/mnt/d/Users/steph/Documents/projet_meteo/wrf-bretagne-local-forecast/v1_bretagne_9km_24h/src/WRF"

# # # while true; do
# # #   clear
# # #   echo "Compilation WRF - suivi"
# # #   echo "------------------------"

# # #   echo ""
# # #   echo "Exécutables :"
# # #   ls -lh "$WRF_DIR/main/"*.exe 2>/dev/null || echo "Aucun .exe pour le moment"

# # #   echo ""
# # #   echo "Dernière étape :"
# # #   tail -20 "$WRF_DIR/compile.log" | grep -E "Entering directory|wrf.exe|real.exe|ndown.exe|tc.exe|Error|error|fatal|undefined" || true

# # #   echo ""
# # #   sleep 10
# # # done


# # #!/bin/bash

# # WRF_DIR="/mnt/d/Users/steph/Documents/projet_meteo/wrf-bretagne-local-forecast/v1_bretagne_9km_24h/src/WRF"
# # LOG="$WRF_DIR/compile.log"

# # GREEN="\033[0;32m"
# # RED="\033[0;31m"
# # YELLOW="\033[1;33m"
# # BLUE="\033[0;34m"
# # CYAN="\033[0;36m"
# # NC="\033[0m"

# # steps=("external" "frame" "phys" "dyn_em" "wrf.exe" "ndown.exe" "tc.exe" "real.exe")

# # while true; do
# #   clear
# #   echo -e "${CYAN}Compilation WRF - suivi avancé${NC}"
# #   echo "================================"

# #   done=0

# #   for step in "${steps[@]}"; do
# #     if grep -q "$step" "$LOG" 2>/dev/null || ls "$WRF_DIR/main/$step" >/dev/null 2>&1; then
# #       echo -e "${GREEN}✅ $step${NC}"
# #       ((done++))
# #     else
# #       echo -e "${YELLOW}⏳ $step${NC}"
# #     fi
# #   done

# #   percent=$((done * 100 / ${#steps[@]}))
# #   filled=$((percent / 5))
# #   empty=$((20 - filled))

# #   bar=$(printf "%${filled}s" | tr ' ' '█')
# #   space=$(printf "%${empty}s" | tr ' ' '░')

# #   echo ""
# #   echo -e "Progression : ${BLUE}${bar}${space}${NC} ${percent}%"

# #   echo ""
# #   echo -e "${CYAN}Exécutables :${NC}"
# #   ls -lh "$WRF_DIR/main/"*.exe 2>/dev/null || echo "Aucun .exe"

# #   echo ""
# #   echo -e "${CYAN}Dernière activité :${NC}"
# #   tail -8 "$LOG" 2>/dev/null | grep -E "Entering directory|Leaving directory|mpif90|wrf.exe|real.exe|ndown.exe|tc.exe|error|Error|undefined|collect2" || true

# #   echo ""
# #   echo -e "${CYAN}Processus actifs :${NC}"
# #   ps aux | grep -E "mpif90|gfortran|ld|collect2" | grep -v grep || echo "Aucun processus actif"

# #   sleep 10
# # done

# #!/bin/bash

# WRF_DIR="${WRF_DIR:-/mnt/d/Users/steph/Documents/projet_meteo/wrf-bretagne-local-forecast/v1_bretagne_9km_24h/src/WRF}"
# LOG="$WRF_DIR/compile.log"
# REFRESH=10
# START_TIME=$(date +%s)

# GREEN="\033[0;32m"
# RED="\033[0;31m"
# YELLOW="\033[1;33m"
# BLUE="\033[0;34m"
# CYAN="\033[0;36m"
# WHITE="\033[1;37m"
# GRAY="\033[0;90m"
# NC="\033[0m"

# steps=("external" "frame" "share" "phys" "dyn_em" "wrf.exe" "ndown.exe" "tc.exe" "real.exe")

# bar() {
#   local percent=$1
#   local width=30
#   local filled=$((percent * width / 100))
#   local empty=$((width - filled))
#   printf "["
#   printf "%${filled}s" | tr ' ' '#'
#   printf "%${empty}s" | tr ' ' '-'
#   printf "]"
# }

# format_time() {
#   local seconds=$1
#   printf "%02dh %02dm %02ds" $((seconds/3600)) $(((seconds%3600)/60)) $((seconds%60))
# }

# exe_status() {
#   local exe="$1"
#   local file="$WRF_DIR/main/$exe"

#   if [ -f "$file" ]; then
#     local size
#     size=$(stat -c%s "$file" 2>/dev/null || echo 0)

#     if [ "$size" -gt 1000000 ]; then
#       echo -e "${GREEN}OK${NC}"
#     elif [ "$size" -eq 0 ]; then
#       echo -e "${YELLOW}LINKING${NC}"
#     else
#       echo -e "${YELLOW}SMALL${NC}"
#     fi
#   else
#     echo -e "${GRAY}WAIT${NC}"
#   fi
# }

# exe_size() {
#   local exe="$1"
#   local file="$WRF_DIR/main/$exe"

#   if [ -f "$file" ]; then
#     ls -lh "$file" | awk '{print $5}'
#   else
#     echo "-"
#   fi
# }

# current_stage() {
#   if pgrep -f "lto1" >/dev/null; then
#     echo "Link Time Optimization / création exécutable"
#   elif pgrep -f "ld" >/dev/null; then
#     echo "Linkage final"
#   elif pgrep -f "mpif90.*-o .*\.exe" >/dev/null; then
#     echo "Création exécutable WRF"
#   elif pgrep -f "mpif90|gfortran" >/dev/null; then
#     echo "Compilation Fortran"
#   elif [ -f "$LOG" ]; then
#     tail -50 "$LOG" | grep -E "Error|error|undefined|collect2" >/dev/null && echo "Erreur détectée" || echo "En attente / terminé"
#   else
#     echo "Log introuvable"
#   fi
# }

# error_count() {
#   if [ -f "$LOG" ]; then
#     grep -Ei "error|undefined reference|collect2" "$LOG" | wc -l
#   else
#     echo 0
#   fi
# }

# while true; do
#   clear

#   now=$(date +%s)
#   elapsed=$((now - START_TIME))

#   echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
#   echo -e "${CYAN}║${NC} ${WHITE}WRF Bretagne - Compilation Monitor${NC}                 ${CYAN}║${NC}"
#   echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
#   echo ""

#   echo -e "${WHITE}Dossier :${NC} $WRF_DIR"
#   echo -e "${WHITE}Durée   :${NC} $(format_time "$elapsed")"
#   echo -e "${WHITE}Étape   :${NC} $(current_stage)"
#   echo ""

#   done=0

#   echo -e "${CYAN}Étapes${NC}"
#   echo "------------------------------------------------------"

#   for step in "${steps[@]}"; do
#     if [[ "$step" == *.exe ]]; then
#       file="$WRF_DIR/main/$step"
#       if [ -f "$file" ] && [ "$(stat -c%s "$file" 2>/dev/null || echo 0)" -gt 1000000 ]; then
#         echo -e "${GREEN}✅ $step${NC}"
#         ((done++))
#       elif [ -f "$file" ]; then
#         echo -e "${YELLOW}🔧 $step en création${NC}"
#       else
#         echo -e "${GRAY}⏳ $step${NC}"
#       fi
#     else
#       if grep -q "$step" "$LOG" 2>/dev/null; then
#         echo -e "${GREEN}✅ $step${NC}"
#         ((done++))
#       else
#         echo -e "${GRAY}⏳ $step${NC}"
#       fi
#     fi
#   done

#   percent=$((done * 100 / ${#steps[@]}))

#   echo ""
#   echo -e "${CYAN}Progression${NC}"
#   echo "------------------------------------------------------"
#   echo -e "$(bar "$percent") ${BLUE}${percent}%${NC}"
#   echo ""

#   echo -e "${CYAN}Exécutables${NC}"
#   echo "------------------------------------------------------"
#   printf "%-12s %-12s %-10s\n" "Fichier" "Taille" "Statut"
#   printf "%-12s %-12s %-10b\n" "wrf.exe"   "$(exe_size wrf.exe)"   "$(exe_status wrf.exe)"
#   printf "%-12s %-12s %-10b\n" "real.exe"  "$(exe_size real.exe)"  "$(exe_status real.exe)"
#   printf "%-12s %-12s %-10b\n" "ndown.exe" "$(exe_size ndown.exe)" "$(exe_status ndown.exe)"
#   printf "%-12s %-12s %-10b\n" "tc.exe"    "$(exe_size tc.exe)"    "$(exe_status tc.exe)"
#   echo ""

#   echo -e "${CYAN}Charge système WRF${NC}"
#   echo "------------------------------------------------------"

#   lto_pid=$(pgrep -f "lto1" | head -1)
#   if [ -n "$lto_pid" ]; then
#     cpu=$(ps -p "$lto_pid" -o %cpu= | xargs)
#     ram_kb=$(ps -p "$lto_pid" -o rss= | xargs)
#     ram_mb=$((ram_kb / 1024))
#     echo -e "${GREEN}🚀 LTO actif${NC}  CPU: ${cpu}%  RAM: ${ram_mb} Mo"
#   fi

#   ps -eo pid,%cpu,%mem,comm,args \
#     | grep -E "mpif90|gfortran|collect2|ld|lto1" \
#     | grep -v grep \
#     | head -6

#   if ! pgrep -f "mpif90|gfortran|collect2|ld|lto1" >/dev/null; then
#     echo -e "${YELLOW}Aucun processus de compilation actif${NC}"
#   fi

#   echo ""
#   echo -e "${CYAN}Erreurs détectées${NC}"
#   echo "------------------------------------------------------"
#   errors=$(error_count)
#   if [ "$errors" -gt 0 ]; then
#     echo -e "${RED}$errors erreur(s) trouvée(s) dans le log${NC}"
#     grep -Ei "undefined reference|collect2|error:" "$LOG" 2>/dev/null | tail -5
#   else
#     echo -e "${GREEN}Aucune erreur détectée dans le log${NC}"
#   fi

#   echo ""
#   echo -e "${CYAN}Dernière activité${NC}"
#   echo "------------------------------------------------------"
#   tail -6 "$LOG" 2>/dev/null | sed 's/^/  /'

#   echo ""
#   echo -e "${GRAY}Rafraîchissement toutes les ${REFRESH}s - Ctrl+C pour quitter${NC}"

#   sleep "$REFRESH"
# done

#!/bin/bash

WRF_DIR="${WRF_DIR:-/mnt/d/Users/steph/Documents/projet_meteo/wrf-bretagne-local-forecast/v1_bretagne_9km_24h/src/WRF}"
LOG="${LOG:-$WRF_DIR/compile.log}"
REFRESH="${REFRESH:-10}"
START_TIME=$(date +%s)

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
WHITE="\033[1;37m"
GRAY="\033[0;90m"
NC="\033[0m"

steps=("external" "frame" "share" "phys" "dyn_em" "wrf.exe" "ndown.exe" "tc.exe" "real.exe")
executables=("wrf.exe" "ndown.exe" "tc.exe" "real.exe")

format_time() {
  local s=$1
  printf "%02dh %02dm %02ds" $((s/3600)) $(((s%3600)/60)) $((s%60))
}

bar() {
  local percent=$1
  local width=34
  local filled=$((percent * width / 100))
  local empty=$((width - filled))

  printf "["
  printf "%${filled}s" | tr ' ' '#'
  printf "%${empty}s" | tr ' ' '-'
  printf "]"
}

file_size_bytes() {
  [ -f "$1" ] && stat -c%s "$1" 2>/dev/null || echo 0
}

file_size_human() {
  [ -f "$1" ] && du -h "$1" 2>/dev/null | awk '{print $1}' || echo "-"
}

exe_state() {
  local exe="$1"
  local file="$WRF_DIR/main/$exe"
  local size
  size=$(file_size_bytes "$file")

  if [ "$size" -gt 10000000 ]; then
    echo -e "${GREEN}VALID${NC}"
  elif [ "$size" -gt 0 ]; then
    echo -e "${YELLOW}PARTIAL${NC}"
  elif [ -f "$file" ]; then
    echo -e "${YELLOW}LINKING${NC}"
  else
    echo -e "${GRAY}WAIT${NC}"
  fi
}

current_stage() {
  if pgrep -f "lto1" >/dev/null; then
    echo "Optimisation finale LTO"
  elif pgrep -f "mpif90.*-o .*\.exe" >/dev/null; then
    echo "Création d'un exécutable"
  elif pgrep -f "gfortran|mpif90|ld|collect2" >/dev/null; then
    echo "Compilation / linkage"
  elif [ -f "$LOG" ] && grep -Ei "undefined reference|collect2: error|error:" "$LOG" >/dev/null; then
    echo "Erreur détectée"
  else
    echo "En attente ou terminé"
  fi
}

count_done() {
  local done=0

  for step in "${steps[@]}"; do
    if [[ "$step" == *.exe ]]; then
      local size
      size=$(file_size_bytes "$WRF_DIR/main/$step")
      [ "$size" -gt 10000000 ] && ((done++))
    else
      grep -q "$step" "$LOG" 2>/dev/null && ((done++))
    fi
  done

  echo "$done"
}

show_header() {
  clear
  echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC} ${WHITE}WRF Bretagne Local Forecast - Build Dashboard${NC}          ${CYAN}║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
}

show_summary() {
  local done=$1
  local total=${#steps[@]}
  local percent=$((done * 100 / total))
  local now elapsed eta total_est

  now=$(date +%s)
  elapsed=$((now - START_TIME))

  if [ "$percent" -gt 0 ]; then
    total_est=$((elapsed * 100 / percent))
    eta=$((total_est - elapsed))
  else
    eta=0
  fi

  echo -e "${WHITE}Dossier :${NC} $WRF_DIR"
  echo -e "${WHITE}Log     :${NC} $LOG"
  echo -e "${WHITE}Étape   :${NC} $(current_stage)"
  echo -e "${WHITE}Durée   :${NC} $(format_time "$elapsed")"
  echo -e "${WHITE}ETA     :${NC} $(format_time "$eta")"
  echo ""
  echo -e "${CYAN}Progression${NC}"
  echo "--------------------------------------------------------------"
  echo -e "$(bar "$percent") ${BLUE}${percent}%${NC}  ($done/$total)"
}

show_steps() {
  echo ""
  echo -e "${CYAN}Étapes WRF${NC}"
  echo "--------------------------------------------------------------"

  for step in "${steps[@]}"; do
    if [[ "$step" == *.exe ]]; then
      local size
      size=$(file_size_bytes "$WRF_DIR/main/$step")

      if [ "$size" -gt 10000000 ]; then
        echo -e "${GREEN}✓${NC} $step"
      elif [ -f "$WRF_DIR/main/$step" ]; then
        echo -e "${YELLOW}●${NC} $step en création"
      else
        echo -e "${GRAY}○${NC} $step"
      fi
    else
      if grep -q "$step" "$LOG" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $step"
      else
        echo -e "${GRAY}○${NC} $step"
      fi
    fi
  done
}

show_executables() {
  echo ""
  echo -e "${CYAN}Exécutables générés${NC}"
  echo "--------------------------------------------------------------"
  printf "%-12s %-12s %-12s\n" "Fichier" "Taille" "Statut"

  for exe in "${executables[@]}"; do
    local file="$WRF_DIR/main/$exe"
    printf "%-12s %-12s %-12b\n" "$exe" "$(file_size_human "$file")" "$(exe_state "$exe")"
  done
}

show_system() {
  echo ""
  echo -e "${CYAN}Charge système${NC}"
  echo "--------------------------------------------------------------"

  free -h | awk '/Mem:/ {print "RAM     : " $3 " / " $2}'
  uptime | awk -F'load average:' '{print "Load    :" $2}'

  local lto_count
  lto_count=$(pgrep -f "lto1" | wc -l)

  if [ "$lto_count" -gt 0 ]; then
    echo -e "LTO     : ${GREEN}actif${NC} ($lto_count processus)"
  else
    echo -e "LTO     : ${GRAY}inactif${NC}"
  fi

  echo ""
  ps -eo pid,%cpu,%mem,comm,args \
    | grep -E "mpif90|gfortran|collect2|ld|lto1" \
    | grep -v grep \
    | sort -k2 -nr \
    | head -8
}

show_errors() {
  echo ""
  echo -e "${CYAN}Diagnostic erreurs${NC}"
  echo "--------------------------------------------------------------"

  if [ ! -f "$LOG" ]; then
    echo -e "${YELLOW}Log introuvable${NC}"
    return
  fi

  local errors
  errors=$(grep -Ei "undefined reference|collect2: error|error:" "$LOG" | wc -l)

  if [ "$errors" -gt 0 ]; then
    echo -e "${RED}$errors erreur(s) détectée(s)${NC}"
    grep -Ei "undefined reference|collect2: error|error:" "$LOG" | tail -5
  else
    echo -e "${GREEN}Aucune erreur critique détectée${NC}"
  fi
}

show_activity() {
  echo ""
  echo -e "${CYAN}Dernière activité du log${NC}"
  echo "--------------------------------------------------------------"

  tail -8 "$LOG" 2>/dev/null | sed 's/^/  /'
}

while true; do
  done=$(count_done)

  show_header
  show_summary "$done"
  show_steps
  show_executables
  show_system
  show_errors
  show_activity

  echo ""
  echo -e "${GRAY}Rafraîchissement toutes les ${REFRESH}s - Ctrl+C pour quitter${NC}"

  sleep "$REFRESH"
done

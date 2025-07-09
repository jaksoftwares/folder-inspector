#!/bin/bash

# ==========================================
# 📄 tree-view.sh
# ------------------------------------------
# Displays directory structure in a tree format.
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

clear
echo -e "${BLUE}=========================================="
echo -e "📂 FOLDER INSPECTOR - Tree View"
echo -e "==========================================${RESET}"
echo -e "${CYAN}This tool displays the folder structure as a tree."
echo -e "You can enter a custom path or press ENTER to use:"
echo -e "${YELLOW}Current Directory → $(pwd)${RESET}"
echo ""
read -p "📁 Enter directory path: " user_input

# Use current directory if none provided
if [[ -z "$user_input" ]]; then
  target_dir="."
else
  target_dir="$user_input"
fi

# Validate directory
if [[ ! -d "$target_dir" ]]; then
  echo -e "${YELLOW}❌ Error: '${target_dir}' is not a valid directory.${RESET}"
  exit 1
fi

echo ""
echo -e "${BLUE}🌲 Tree structure of: $target_dir${RESET}"
echo "------------------------------------------"

# Recursive tree printer
print_tree() {
  local dir="$1"
  local prefix="$2"
  local items=("$dir"/*)
  local count=0
  local total=${#items[@]}

  for item in "${items[@]}"; do
    count=$((count + 1))
    local connector="├──"
    [[ $count -eq $total ]] && connector="└──"

    if [[ -d "$item" ]]; then
      echo -e "${prefix}${connector} ${CYAN}$(basename "$item")${RESET}/"
      print_tree "$item" "$prefix$( [[ $count -eq $total ]] && echo "    " || echo "│   ")"
    elif [[ -f "$item" ]]; then
      echo -e "${prefix}${connector} ${GREEN}$(basename "$item")${RESET}"
    fi
  done
}

# Print root and begin recursion
echo -e "${CYAN}$(basename "$target_dir")${RESET}/"
print_tree "$target_dir" ""

echo -e "${BLUE}==========================================${RESET}"

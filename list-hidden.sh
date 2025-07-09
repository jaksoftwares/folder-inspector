#!/bin/bash

# ==========================================
# 📄 list-hidden.sh
# ------------------------------------------
# Lists all hidden files and directories.
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

clear
echo -e "${BLUE}=========================================="
echo -e "📂 FOLDER INSPECTOR - List Hidden Files"
echo -e "==========================================${RESET}"
echo -e "${CYAN}This tool lists hidden files and folders (dotfiles)."
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
echo -e "${BLUE}🔎 Scanning for hidden files in: $target_dir${RESET}"
echo "------------------------------------------"

# Find hidden files and directories, excluding . and ..
found_hidden=0
while IFS= read -r -d '' hidden_item; do
  name=$(basename "$hidden_item")
  echo -e "🙈 ${GREEN}$name${RESET}"
  ((found_hidden++))
done < <(find "$target_dir" -maxdepth 1 -name ".*" ! -name "." ! -name ".." -print0)

# Summary
echo "------------------------------------------"
if [[ $found_hidden -eq 0 ]]; then
  echo -e "${YELLOW}⚠️  No hidden files or folders found.${RESET}"
else
  echo -e "${CYAN}✅ Total hidden items found: $found_hidden${RESET}"
fi
echo -e "${BLUE}==========================================${RESET}"

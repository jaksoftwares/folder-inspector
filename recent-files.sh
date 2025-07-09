#!/bin/bash

# ==========================================
# 📄 recent-files.sh
# ------------------------------------------
# Lists files modified in the last N days.
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

clear
echo -e "${BLUE}=========================================="
echo -e "📂 FOLDER INSPECTOR - Recent Files"
echo -e "==========================================${RESET}"
echo -e "${CYAN}This tool lists files modified in the last N days."
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

# Ask for number of days
echo ""
read -p "📅 Enter number of days to look back: " days
if ! [[ "$days" =~ ^[0-9]+$ ]]; then
  echo -e "${YELLOW}❌ Please enter a valid number of days (e.g. 3)${RESET}"
  exit 1
fi

echo ""
echo -e "${BLUE}🔍 Searching for files modified in the last $days day(s)${RESET}"
echo "------------------------------------------"

# Find and list files
found_files=0
while IFS= read -r -d '' file; do
  mod_time=$(date -r "$file" "+%Y-%m-%d %H:%M")
  filename=$(basename "$file")
  echo -e "📄 ${GREEN}$filename${RESET} — ${CYAN}$mod_time${RESET}"
  ((found_files++))
done < <(find "$target_dir" -type f -mtime -"$days" -print0)

# Summary
echo "------------------------------------------"
if [[ $found_files -eq 0 ]]; then
  echo -e "${YELLOW}⚠️  No files modified in the last $days day(s).${RESET}"
else
  echo -e "${CYAN}✅ Total recently modified files: $found_files${RESET}"
fi
echo -e "${BLUE}==========================================${RESET}"

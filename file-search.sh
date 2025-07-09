#!/bin/bash

# ==========================================
# 📄 file-search.sh
# ------------------------------------------
# Searches for files by name or pattern.
# Supports wildcards like *.txt or exact terms.
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

clear
echo -e "${BLUE}=========================================="
echo -e "📂 FOLDER INSPECTOR - File Search"
echo -e "==========================================${RESET}"
echo -e "${CYAN}This tool searches for files by name or pattern."
echo -e "Use patterns like '*.txt', 'report', or 'logo*.png'"
echo -e "Press ENTER to use the current directory:"
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
read -p "🔎 Enter search pattern (e.g. *.pdf or report): " pattern

if [[ -z "$pattern" ]]; then
  echo -e "${YELLOW}⚠️  No search pattern provided. Exiting.${RESET}"
  exit 1
fi

echo ""
echo -e "${BLUE}🔍 Searching in: $target_dir${RESET}"
echo -e "📌 Pattern: '${pattern}'"
echo "------------------------------------------"

# Search and display results
matches=0
while IFS= read -r -d '' file; do
  echo -e "📄 ${GREEN}$file${RESET}"
  ((matches++))
done < <(find "$target_dir" -type f -name "$pattern" -print0)

echo "------------------------------------------"
if [[ $matches -eq 0 ]]; then
  echo -e "${YELLOW}⚠️  No matching files found.${RESET}"
else
  echo -e "${CYAN}✅ Matches found: $matches${RESET}"
fi
echo -e "${BLUE}==========================================${RESET}"

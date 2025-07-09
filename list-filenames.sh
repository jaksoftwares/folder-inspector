#!/bin/bash

# ==========================================
# 📄 list-filenames.sh
# ------------------------------------------
# Lists all file names in a directory.
# Prompts the user to select a folder or uses current.
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

clear
echo -e "${BLUE}=========================================="
echo -e "📂 FOLDER INSPECTOR - List File Names"
echo -e "==========================================${RESET}"
echo -e "${CYAN}This tool lists all file names in a directory."
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
echo -e "${BLUE}🔍 Scanning directory: $target_dir${RESET}"
echo "------------------------------------------"

# Initialize counter
found_files=0

# Loop and list files
for file in "$target_dir"/*; do
  if [[ -f "$file" ]]; then
    filename=$(basename -- "$file")
    echo -e "📄 ${GREEN}$filename${RESET}"
    ((found_files++))
  fi
done

# Summary
echo "------------------------------------------"
if [[ $found_files -eq 0 ]]; then
  echo -e "${YELLOW}⚠️  No files found in '$target_dir'${RESET}"
else
  echo -e "${CYAN}✅ Total files found: ${found_files}${RESET}"
fi
echo -e "${BLUE}==========================================${RESET}"

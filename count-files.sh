#!/bin/bash

# ==========================================
# 📄 count-files.sh
# ------------------------------------------
# Counts files, folders, and hidden items in a directory.
# Provides a summary report.
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

clear
echo -e "${BLUE}=========================================="
echo -e "📂 FOLDER INSPECTOR - Count Files & Folders"
echo -e "==========================================${RESET}"
echo -e "${CYAN}This tool counts files, folders, and hidden items."
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
echo -e "${BLUE}🔍 Analyzing: $target_dir${RESET}"
echo "------------------------------------------"

# File counts
total_files=$(find "$target_dir" -type f | wc -l)
total_dirs=$(find "$target_dir" -type d | wc -l)
hidden_files=$(find "$target_dir" -name ".*" | wc -l)
unique_exts=$(find "$target_dir" -type f -name "*.*" | sed 's|.*\.||' | sort -u | wc -l)

# Display summary
echo -e "📄 ${GREEN}Total Files:${RESET}           $total_files"
echo -e "📁 ${GREEN}Total Directories:${RESET}     $total_dirs"
echo -e "🙈 ${GREEN}Hidden Files/Folders:${RESET}  $hidden_files"
echo -e "🔠 ${GREEN}Unique File Extensions:${RESET} $unique_exts"

echo "------------------------------------------"
echo -e "${CYAN}✅ Done. Directory scanned successfully.${RESET}"
echo -e "${BLUE}==========================================${RESET}"

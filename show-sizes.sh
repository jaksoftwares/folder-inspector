#!/bin/bash

# ==========================================
# 📄 show-sizes.sh
# ------------------------------------------
# Shows individual file sizes and total folder size.
# Uses human-readable format.
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

clear
echo -e "${BLUE}=========================================="
echo -e "📂 FOLDER INSPECTOR - Show File Sizes"
echo -e "==========================================${RESET}"
echo -e "${CYAN}This tool shows file sizes and total folder size."
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
echo -e "${BLUE}📏 Calculating file sizes in: $target_dir${RESET}"
echo "------------------------------------------"

# Show file sizes
found_files=0
while IFS= read -r -d '' file; do
  filesize=$(du -sh "$file" 2>/dev/null | cut -f1)
  filename=$(basename "$file")
  echo -e "📄 ${GREEN}$filename${RESET} — ${CYAN}$filesize${RESET}"
  ((found_files++))
done < <(find "$target_dir" -maxdepth 1 -type f -print0)

if [[ $found_files -eq 0 ]]; then
  echo -e "${YELLOW}⚠️  No files found in '$target_dir'${RESET}"
fi

# Total folder size
total_size=$(du -sh "$target_dir" 2>/dev/null | cut -f1)

echo "------------------------------------------"
echo -e "📦 ${GREEN}Total Folder Size:${RESET} ${CYAN}$total_size${RESET}"
echo -e "${BLUE}==========================================${RESET}"

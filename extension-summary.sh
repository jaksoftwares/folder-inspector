#!/bin/bash

# ==========================================
# 📄 extension-summary.sh
# ------------------------------------------
# Groups files by extension and summarizes counts and sizes.
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

clear
echo -e "${BLUE}=========================================="
echo -e "📂 FOLDER INSPECTOR - Extension Summary"
echo -e "==========================================${RESET}"
echo -e "${CYAN}This tool summarizes file counts and sizes by extension."
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
echo -e "${BLUE}🔍 Grouping files in: $target_dir${RESET}"
echo "------------------------------------------"

declare -A ext_count
declare -A ext_size
found=0

# Loop through files and accumulate data
while IFS= read -r -d '' file; do
  filename=$(basename "$file")
  ext="${filename##*.}"
  if [[ "$filename" == "$ext" ]]; then
    ext="(none)"
  fi

  size=$(stat -c%s "$file")
  ext_count["$ext"]=$((ext_count["$ext"] + 1))
  ext_size["$ext"]=$((ext_size["$ext"] + size))
  ((found++))
done < <(find "$target_dir" -type f -print0)

if [[ $found -eq 0 ]]; then
  echo -e "${YELLOW}⚠️  No files found in '$target_dir'${RESET}"
  echo -e "${BLUE}==========================================${RESET}"
  exit 0
fi

# Output table
printf "${CYAN}%-15s %-10s %-15s${RESET}\n" "Extension" "Count" "Total Size"
echo "------------------------------------------"

for ext in "${!ext_count[@]}"; do
  count=${ext_count[$ext]}
  size_bytes=${ext_size[$ext]}
  size_hr=$(numfmt --to=iec-i --suffix=B "$size_bytes" 2>/dev/null)
  printf "🔹 ${GREEN}%-13s${RESET} %-10s %-15s\n" "$ext" "$count" "$size_hr"
done

echo "------------------------------------------"
echo -e "${CYAN}✅ Files analyzed: $found${RESET}"
echo -e "${BLUE}==========================================${RESET}"

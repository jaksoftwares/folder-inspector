#!/bin/bash

# ==========================================
# 📄 duplicate-checker.sh
# ------------------------------------------
# Detects duplicate files by comparing content (MD5 hash).
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

clear
echo -e "${BLUE}=========================================="
echo -e "📂 FOLDER INSPECTOR - Duplicate Checker"
echo -e "==========================================${RESET}"
echo -e "${CYAN}This tool scans for duplicate files based on content."
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
echo -e "${BLUE}🔍 Checking for duplicate files in: $target_dir${RESET}"
echo "------------------------------------------"

# Temp file for hashes
declare -A file_hashes
declare -A hash_to_files
found_duplicates=0

while IFS= read -r -d '' file; do
  hash=$(md5sum "$file" | awk '{print $1}')
  file_hashes["$file"]=$hash
  hash_to_files["$hash"]+="$file|"
done < <(find "$target_dir" -type f -print0)

# Display duplicates
for hash in "${!hash_to_files[@]}"; do
  IFS='|' read -ra files <<< "${hash_to_files[$hash]}"
  if [[ ${#files[@]} -gt 1 ]]; then
    echo -e "${YELLOW}⚠️  Duplicate group:${RESET}"
    for f in "${files[@]}"; do
      [[ -n "$f" ]] && echo -e "📄 ${GREEN}$f${RESET}"
    done
    echo "------------------------------------------"
    ((found_duplicates++))
  fi
done

# Summary
if [[ $found_duplicates -eq 0 ]]; then
  echo -e "${CYAN}✅ No duplicate files found.${RESET}"
else
  echo -e "${CYAN}✔ Found $found_duplicates group(s) of duplicate files.${RESET}"
fi
echo -e "${BLUE}==========================================${RESET}"

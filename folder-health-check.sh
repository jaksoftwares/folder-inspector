#!/bin/bash

# ==========================================
# 📄 folder-health-check.sh
# ------------------------------------------
# All-in-one directory scanner for structure, duplicates,
# hidden files, permissions, and large items.
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

clear
echo -e "${BLUE}=========================================="
echo -e "📂 FOLDER INSPECTOR - Health Check"
echo -e "==========================================${RESET}"
echo -e "${CYAN}This full scan summarizes key aspects of folder health.${RESET}"
echo -e "Press ENTER to use the current directory:"
echo -e "${YELLOW}Current Directory → $(pwd)${RESET}"
echo ""
read -p "📁 Enter directory path: " user_input

# Default to current
if [[ -z "$user_input" ]]; then
  target_dir="."
else
  target_dir="$user_input"
fi

# Validate
if [[ ! -d "$target_dir" ]]; then
  echo -e "${RED}❌ Error: '$target_dir' is not a valid directory.${RESET}"
  exit 1
fi

echo ""
echo -e "${BLUE}🔍 Scanning: $target_dir${RESET}"
echo "------------------------------------------"

# === 1. File & Folder Count
total_files=$(find "$target_dir" -type f | wc -l)
total_dirs=$(find "$target_dir" -type d | wc -l)
hidden_items=$(find "$target_dir" -name ".*" ! -name "." ! -name ".." | wc -l)

echo -e "📁 ${CYAN}Directories:${RESET}      $total_dirs"
echo -e "📄 ${CYAN}Files:${RESET}            $total_files"
echo -e "🙈 ${CYAN}Hidden items:${RESET}     $hidden_items"

# === 2. Large Files
echo ""
echo -e "📦 ${CYAN}Large Files (>5MB):${RESET}"
large_files=$(find "$target_dir" -type f -size +5M)
if [[ -z "$large_files" ]]; then
  echo -e "${GREEN}✔ None${RESET}"
else
  echo "$large_files" | while read f; do
    size=$(du -sh "$f" | cut -f1)
    echo -e "⚠️  $f (${YELLOW}$size${RESET})"
  done
fi

# === 3. Duplicate Files (by md5)
echo ""
echo -e "🧬 ${CYAN}Duplicate Files:${RESET}"
declare -A hashes
declare -A dupes
while IFS= read -r -d '' f; do
  h=$(md5sum "$f" | awk '{print $1}')
  if [[ -n "${hashes[$h]}" ]]; then
    dupes["$h"]+="$f|"
  else
    hashes["$h"]="$f"
  fi
done < <(find "$target_dir" -type f -print0)

found_dupes=0
for h in "${!dupes[@]}"; do
  IFS='|' read -ra files <<< "${dupes[$h]}"
  echo -e "🔁 ${YELLOW}Duplicate Group${RESET}:"
  for d in "${files[@]}"; do
    echo -e "    📄 $d"
  done
  ((found_dupes++))
done
[[ $found_dupes -eq 0 ]] && echo -e "${GREEN}✔ None${RESET}"

# === 4. Insecure Permissions
echo ""
echo -e "🔐 ${CYAN}Insecure Permissions:${RESET}"
insecure=0
while IFS= read -r -d '' f; do
  perms=$(stat -c "%A" "$f")
  if [[ "$perms" == *"w"* && "$perms" == *"o"* ]] || [[ "$perms" =~ ^[-d]rwxrwxrwx ]]; then
    echo -e "⚠️  $f (${RED}$perms${RESET})"
    ((insecure++))
  fi
done < <(find "$target_dir" -type f -print0)

[[ $insecure -eq 0 ]] && echo -e "${GREEN}✔ No risky permissions${RESET}"

# === Summary Footer
echo "------------------------------------------"
echo -e "${CYAN}✅ Health check complete.${RESET}"
echo -e "${BLUE}==========================================${RESET}"

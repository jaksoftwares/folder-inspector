#!/bin/bash

# ==========================================
# 📄 permissions-check.sh
# ------------------------------------------
# Lists file and folder permissions with warnings.
# Highlights insecure (world-writable or overly permissive) items.
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
echo -e "📂 FOLDER INSPECTOR - Permissions Check"
echo -e "==========================================${RESET}"
echo -e "${CYAN}This tool lists file/folder permissions and flags insecure ones."
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

# Validate
if [[ ! -d "$target_dir" ]]; then
  echo -e "${YELLOW}❌ Error: '${target_dir}' is not a valid directory.${RESET}"
  exit 1
fi

echo ""
echo -e "${BLUE}🔐 Scanning permissions in: $target_dir${RESET}"
echo "------------------------------------------"

total=0
flagged=0

while IFS= read -r -d '' item; do
  perms=$(stat -c "%A" "$item")
  owner=$(stat -c "%U" "$item")
  size=$(stat -c "%s" "$item")
  name=$(basename "$item")

  if [[ "$perms" == *"w"* && "$perms" == *"o"* ]]; then
    echo -e "⚠️  ${RED}$perms${RESET}  $name ${YELLOW}(World-writable)${RESET}"
    ((flagged++))
  elif [[ "$perms" =~ ^[-d]rwxrwxrwx ]]; then
    echo -e "🚨 ${RED}$perms${RESET}  $name ${YELLOW}(777 permissions)${RESET}"
    ((flagged++))
  else
    echo -e "✅ ${GREEN}$perms${RESET}  $name"
  fi
  ((total++))
done < <(find "$target_dir" -maxdepth 1 ! -name '.' -print0)

echo "------------------------------------------"
echo -e "${CYAN}🔍 Scanned: $total item(s)${RESET}"
if [[ $flagged -gt 0 ]]; then
  echo -e "${RED}⚠️  Insecure items detected: $flagged${RESET}"
else
  echo -e "${GREEN}✔ No insecure permissions found.${RESET}"
fi
echo -e "${BLUE}==========================================${RESET}"

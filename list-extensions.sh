#!/bin/bash

# ==========================================
# 📄 list-extensions.sh
# ------------------------------------------
# Lists all unique file extensions in a directory.
# Optionally displays how many files per extension.
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

clear
echo -e "${BLUE}=========================================="
echo -e "📂 FOLDER INSPECTOR - List File Extensions"
echo -e "==========================================${RESET}"
echo -e "${CYAN}This tool lists all unique file extensions in a folder."
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

# Temporary file to store extensions
tmpfile=$(mktemp)

# Extract extensions
for file in "$target_dir"/*; do
  if [[ -f "$file" ]]; then
    filename=$(basename -- "$file")
    ext="${filename##*.}"
    # Only count if there's an extension
    if [[ "$filename" != "$ext" ]]; then
      echo "$ext" >> "$tmpfile"
    fi
  fi
done

# Count and display
if [[ -s "$tmpfile" ]]; then
  echo -e "${CYAN}📄 File Extensions Found:${RESET}"
  sort "$tmpfile" | uniq -c | sort -nr | while read count ext; do
    echo -e "🔹 ${GREEN}.$ext${RESET} — ${count} file(s)"
  done
else
  echo -e "${YELLOW}⚠️  No files with extensions found in '$target_dir'${RESET}"
fi

# Cleanup
rm -f "$tmpfile"

echo -e "${BLUE}==========================================${RESET}"

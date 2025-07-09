#!/bin/bash

echo "=========================================="
echo "📂 File Lister Script"
echo "------------------------------------------"
echo "This script lists all files in a directory."
echo "You can specify a folder or press Enter to"
echo "use the current directory: $(pwd)"
echo "------------------------------------------"
echo "📝 Format: /absolute/path OR ./relative/path"
echo "=========================================="

# Prompt user input
read -p "📁 Enter directory path (or press Enter for current): " user_input

# Use current directory if none provided
if [[ -z "$user_input" ]]; then
  target_dir="."
else
  target_dir="$user_input"
fi

# Check if the directory exists
if [[ ! -d "$target_dir" ]]; then
  echo "❌ Error: '$target_dir' is not a valid directory."
  exit 1
fi

echo ""
echo "🔍 Scanning directory: $target_dir"
echo "------------------------------------------"

# Loop through the files
found_files=0
for file in "$target_dir"/*; do
  if [[ -f "$file" ]]; then
    filename=$(basename -- "$file")
    echo "📄 $filename"
    ((found_files++))
  fi
done

# Summary
if [[ $found_files -eq 0 ]]; then
  echo "⚠️  No files found in $target_dir"
else
  echo "✅ $found_files file(s) listed."
fi

echo "=========================================="

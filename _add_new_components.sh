#!/bin/bash
set -euo pipefail

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 SRC_INCLUDES_ROOT DST_INCLUDES_ROOT SRC_PAGES_ROOT DST_PAGES_ROOT"
  exit 1
fi

SRC_INCLUDES_ROOT=$1
DST_INCLUDES_ROOT=$2
SRC_PAGES_ROOT=$3
DST_PAGES_ROOT=$4

# Add new includes (no overwrite)
if [ -d "$SRC_INCLUDES_ROOT" ]; then
  ( cd "$SRC_INCLUDES_ROOT" && find . -type f ) | while read -r rel; do
    src="$SRC_INCLUDES_ROOT/$rel"; dst="$DST_INCLUDES_ROOT/$rel"; dst_dir="$(dirname "$dst")"
    if [ ! -e "$dst" ]; then
      mkdir -p "$dst_dir" && cp "$src" "$dst" && echo "+ _includes/$rel"
    fi
  done
fi

# Add new pages (no overwrite)
if [ -d "$SRC_PAGES_ROOT" ]; then
  ( cd "$SRC_PAGES_ROOT" && find . -type f ) | while read -r rel; do
    src="$SRC_PAGES_ROOT/$rel"; dst="$DST_PAGES_ROOT/$rel"; dst_dir="$(dirname "$dst")"
    if [ ! -e "$dst" ]; then
      mkdir -p "$dst_dir" && cp "$src" "$dst" && echo "+ pages/$rel"
    fi
  done
fi


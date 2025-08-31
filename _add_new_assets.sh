#!/bin/bash
set -euo pipefail

# Adds new asset files without overwriting existing ones.
# Usage: _add_new_assets.sh SRC_ASSETS_ROOT DST_ASSETS_ROOT

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 SRC_ASSETS_ROOT DST_ASSETS_ROOT"
  exit 1
fi

SRC_ASSETS_ROOT=$1
DST_ASSETS_ROOT=$2

mkdir -p "$DST_ASSETS_ROOT"
( cd "$SRC_ASSETS_ROOT" && find . -type f ) | while read -r rel; do
  src="$SRC_ASSETS_ROOT/$rel"; dst="$DST_ASSETS_ROOT/$rel"; dst_dir="$(dirname "$dst")"
  if [ ! -e "$dst" ]; then
    mkdir -p "$dst_dir" && cp "$src" "$dst" && echo "+ assets/$rel"
  fi
done


#!/bin/bash
set -euo pipefail

# Overwrites asset files from source to destination.
# Usage: _update_existing_assets.sh SRC_ASSETS_ROOT DST_ASSETS_ROOT

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 SRC_ASSETS_ROOT DST_ASSETS_ROOT"
  exit 1
fi

SRC_ASSETS_ROOT=$1
DST_ASSETS_ROOT=$2

mkdir -p "$DST_ASSETS_ROOT"
( cd "$SRC_ASSETS_ROOT" && find . -type f ) | while read -r rel; do
  if [[ "$rel" == "./custom.css" || "$rel" == "./theme.css" ]]; then
    continue
  fi
  src="$SRC_ASSETS_ROOT/$rel"
  dst="$DST_ASSETS_ROOT/$rel"
  dst_dir="$(dirname "$dst")"
  mkdir -p "$dst_dir"
  cp "$src" "$dst"
done
echo "~ assets updated (site.css refreshed; theme.css/custom.css preserved)"

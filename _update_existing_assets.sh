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
cp -R "$SRC_ASSETS_ROOT/." "$DST_ASSETS_ROOT/"
echo "~ assets updated"


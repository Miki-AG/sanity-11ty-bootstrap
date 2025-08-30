#!/bin/bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 SRC_SCHEMA_ROOT DST_SCHEMA_ROOT"
  exit 1
fi

SRC_SCHEMA_ROOT=$1
DST_SCHEMA_ROOT=$2

if [ ! -d "$SRC_SCHEMA_ROOT" ]; then
  echo "Source schemas not found: $SRC_SCHEMA_ROOT"
  exit 0
fi

mkdir -p "$DST_SCHEMA_ROOT"
( cd "$SRC_SCHEMA_ROOT" && find . -type f ) | while read -r rel; do
  src="$SRC_SCHEMA_ROOT/$rel"; dst="$DST_SCHEMA_ROOT/$rel"; dst_dir="$(dirname "$dst")"
  if [ ! -e "$dst" ]; then
    mkdir -p "$dst_dir" && cp "$src" "$dst" && echo "+ cms/schemaTypes/$rel"
  fi
done


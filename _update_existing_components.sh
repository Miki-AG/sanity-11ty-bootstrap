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

# Overwrite includes
if [ -d "$SRC_INCLUDES_ROOT" ]; then
  mkdir -p "$DST_INCLUDES_ROOT"
  cp -R "$SRC_INCLUDES_ROOT/." "$DST_INCLUDES_ROOT/"
  echo "~ _includes updated"
else
  echo "Note: includes source not found: $SRC_INCLUDES_ROOT"
fi

# Overwrite pages
if [ -d "$SRC_PAGES_ROOT" ]; then
  mkdir -p "$DST_PAGES_ROOT"
  cp -R "$SRC_PAGES_ROOT/." "$DST_PAGES_ROOT/"
  echo "~ pages updated"
else
  echo "Note: pages source not found: $SRC_PAGES_ROOT"
fi


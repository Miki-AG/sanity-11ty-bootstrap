#!/bin/bash
set -euo pipefail

# Copies only Eleventy data files from bootstrap into the target web project.
# Usage: _update_data.sh SCRIPT_DIR WEB_DIR

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 SCRIPT_DIR WEB_DIR"
  exit 1
fi

SCRIPT_DIR=$1
WEB_DIR=$2

SRC_DATA="$SCRIPT_DIR/bootstrap/web/src/_data"
DST_DATA="$WEB_DIR/src/_data"

mkdir -p "$DST_DATA"
if [ -d "$SRC_DATA" ]; then
  cp -R "$SRC_DATA/." "$DST_DATA/"
  echo "~ web/src/_data updated"
else
  echo "Note: source data directory not found: $SRC_DATA"
fi


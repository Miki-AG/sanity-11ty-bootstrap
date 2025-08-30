#!/bin/bash
set -euo pipefail

# Updates Eleventy support scripts in the web folder:
# - src/_data/*
# - .eleventy.js
# - listen.js

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
fi

if [ -f "$SCRIPT_DIR/bootstrap/web/.eleventy.js" ]; then
  cp -R "$SCRIPT_DIR/bootstrap/web/.eleventy.js" "$WEB_DIR/.eleventy.js"
  echo "~ web/.eleventy.js updated"
fi

if [ -f "$SCRIPT_DIR/bootstrap/web/listen.js" ]; then
  cp -R "$SCRIPT_DIR/bootstrap/web/listen.js" "$WEB_DIR/listen.js"
  echo "~ web/listen.js updated"
fi


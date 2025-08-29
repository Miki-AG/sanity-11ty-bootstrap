#!/bin/bash

# This script updates parts of an existing project.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$1" ]; then
  echo "Error: Project directory not provided."
  echo "Usage: ./update.sh /path/to/your/project"
  exit 1
fi

PROJECT_DIR=$1

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: Project directory '$PROJECT_DIR' not found."
  exit 1
fi

WEB_DIR="$PROJECT_DIR/web"

if [ ! -d "$WEB_DIR" ]; then
  echo "Error: Web directory '$WEB_DIR' not found."
  exit 1
fi

echo "What would you like to update?"
echo "  1) Get new templates/pages only"
echo "  2) Get new templates/pages and update existing templates/pages"
echo "  3) Update scripts"
echo "  4) Update all (templates/pages + scripts)"
read -r -p "Enter choice [1-4]: " choice

SRC_INCLUDES_ROOT="$SCRIPT_DIR/bootstrap/web/src/_includes"
DST_INCLUDES_ROOT="$WEB_DIR/src/_includes"
SRC_PAGES_ROOT="$SCRIPT_DIR/bootstrap/web/src/pages"
DST_PAGES_ROOT="$WEB_DIR/src/pages"

mkdir -p "$DST_INCLUDES_ROOT" "$DST_PAGES_ROOT"

case "$choice" in
  1)
    echo "Adding new templates/pages (no overwrite)..."
    # _includes (all templates under includes, including blocks)
    ( cd "$SRC_INCLUDES_ROOT" && find . -type f ) | while read -r rel; do
      src="$SRC_INCLUDES_ROOT/$rel"; dst="$DST_INCLUDES_ROOT/$rel"; dst_dir="$(dirname "$dst")"
      if [ ! -e "$dst" ]; then
        mkdir -p "$dst_dir" && cp "$src" "$dst" && echo "+ _includes/$rel"
      fi
    done
    # pages
    ( cd "$SRC_PAGES_ROOT" && find . -type f ) | while read -r rel; do
      src="$SRC_PAGES_ROOT/$rel"; dst="$DST_PAGES_ROOT/$rel"; dst_dir="$(dirname "$dst")"
      if [ ! -e "$dst" ]; then
        mkdir -p "$dst_dir" && cp "$src" "$dst" && echo "+ pages/$rel"
      fi
    done
    echo "Done. New templates/pages added."
    ;;
  2)
    echo "Updating templates/pages (add + overwrite)..."
    cp -R "$SRC_INCLUDES_ROOT/." "$DST_INCLUDES_ROOT/"
    cp -R "$SRC_PAGES_ROOT/." "$DST_PAGES_ROOT/"
    echo "Templates/pages updated."
    ;;
  3)
    echo "Updating scripts (_data + .eleventy.js + listen.js + serve.sh + stop.sh + update.sh)..."
    # _data
    mkdir -p "$WEB_DIR/src/_data"
    cp -R "$SCRIPT_DIR/bootstrap/web/src/_data/." "$WEB_DIR/src/_data/"
    # Eleventy + listener
    cp -R "$SCRIPT_DIR/bootstrap/web/.eleventy.js" "$WEB_DIR/.eleventy.js"
    cp -R "$SCRIPT_DIR/bootstrap/web/listen.js" "$WEB_DIR/listen.js"
    # Root scripts
    cp -R "$SCRIPT_DIR/serve.sh" "$PROJECT_DIR/serve.sh"
    cp -R "$SCRIPT_DIR/stop.sh" "$PROJECT_DIR/stop.sh"
    cp -R "$SCRIPT_DIR/update.sh" "$PROJECT_DIR/update.sh"
    echo "Scripts updated."
    ;;
  4)
    echo "Updating templates/pages (add + overwrite) and scripts..."
    # Templates/pages
    cp -R "$SRC_INCLUDES_ROOT/." "$DST_INCLUDES_ROOT/"
    cp -R "$SRC_PAGES_ROOT/." "$DST_PAGES_ROOT/"
    echo "Templates/pages updated."
    # Scripts
    mkdir -p "$WEB_DIR/src/_data"
    cp -R "$SCRIPT_DIR/bootstrap/web/src/_data/." "$WEB_DIR/src/_data/"
    cp -R "$SCRIPT_DIR/bootstrap/web/.eleventy.js" "$WEB_DIR/.eleventy.js"
    cp -R "$SCRIPT_DIR/bootstrap/web/listen.js" "$WEB_DIR/listen.js"
    cp -R "$SCRIPT_DIR/serve.sh" "$PROJECT_DIR/serve.sh"
    cp -R "$SCRIPT_DIR/stop.sh" "$PROJECT_DIR/stop.sh"
    cp -R "$SCRIPT_DIR/update.sh" "$PROJECT_DIR/update.sh"
    echo "Scripts updated."
    ;;
  *)
    echo "Invalid choice. Nothing changed."
    exit 1
    ;;
esac

echo "Update complete."

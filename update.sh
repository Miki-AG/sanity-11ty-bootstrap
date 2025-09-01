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
echo "  1) Add new templates/pages/schemas (no overwrite)"
echo "  2) Add + update templates/pages/schemas (overwrite)"
echo "  3) Update scripts (listen.js)"
echo "  4) Choose theme (copy to web/src/assets/theme.css)"
read -r -p "Enter choice [1-4]: " choice

SRC_INCLUDES_ROOT="$SCRIPT_DIR/bootstrap/web/src/_includes"
DST_INCLUDES_ROOT="$WEB_DIR/src/_includes"
SRC_PAGES_ROOT="$SCRIPT_DIR/bootstrap/web/src/pages"
DST_PAGES_ROOT="$WEB_DIR/src/pages"
SRC_SCHEMA_ROOT="$SCRIPT_DIR/bootstrap/cms/schemaTypes"
CMS_DIR="$PROJECT_DIR/cms"
DST_SCHEMA_ROOT="$CMS_DIR/schemaTypes"
SRC_ASSETS_ROOT="$SCRIPT_DIR/bootstrap/web/src/assets"
DST_ASSETS_ROOT="$WEB_DIR/src/assets"

mkdir -p "$DST_INCLUDES_ROOT" "$DST_PAGES_ROOT"

case "$choice" in
  1)
    mkdir -p "$DST_INCLUDES_ROOT" "$DST_PAGES_ROOT"
    bash "$SCRIPT_DIR/_add_new_components.sh" "$SRC_INCLUDES_ROOT" "$DST_INCLUDES_ROOT" "$SRC_PAGES_ROOT" "$DST_PAGES_ROOT"
    # assets (non-destructive add)
    if [ -d "$SRC_ASSETS_ROOT" ]; then
      bash "$SCRIPT_DIR/_add_new_assets.sh" "$SRC_ASSETS_ROOT" "$DST_ASSETS_ROOT"
    fi
    if [ -d "$CMS_DIR" ] && [ -d "$SRC_SCHEMA_ROOT" ]; then
      bash "$SCRIPT_DIR/_add_new_schemas.sh" "$SRC_SCHEMA_ROOT" "$DST_SCHEMA_ROOT"
    else
      echo "Note: Skipped schemas (cms/ missing or source schemas not found)."
    fi
    bash "$SCRIPT_DIR/_update_data.sh" "$SCRIPT_DIR" "$WEB_DIR"
    echo "Done."
    ;;
  2)
    mkdir -p "$DST_INCLUDES_ROOT" "$DST_PAGES_ROOT"
    bash "$SCRIPT_DIR/_update_existing_components.sh" "$SRC_INCLUDES_ROOT" "$DST_INCLUDES_ROOT" "$SRC_PAGES_ROOT" "$DST_PAGES_ROOT"
    # assets (overwrite)
    if [ -d "$SRC_ASSETS_ROOT" ]; then
      bash "$SCRIPT_DIR/_update_existing_assets.sh" "$SRC_ASSETS_ROOT" "$DST_ASSETS_ROOT"
    fi
    if [ -d "$CMS_DIR" ] && [ -d "$SRC_SCHEMA_ROOT" ]; then
      bash "$SCRIPT_DIR/_update_existing_schemas.sh" "$SRC_SCHEMA_ROOT" "$DST_SCHEMA_ROOT"
    else
      echo "Note: Skipped schemas (cms/ missing or source schemas not found)."
    fi
    bash "$SCRIPT_DIR/_update_data.sh" "$SCRIPT_DIR" "$WEB_DIR"
    echo "Done."
    ;;
  3)
    bash "$SCRIPT_DIR/_update_listenjs.sh" "$SCRIPT_DIR" "$WEB_DIR"
    echo "Scripts updated."
    ;;
  4)
    THEME_DIR="$SCRIPT_DIR/bootstrap/web/src/assets/themes"
    if [ ! -d "$THEME_DIR" ]; then
      echo "No themes directory found at $THEME_DIR"
      exit 1
    fi
    echo "Available themes:"
    ( cd "$THEME_DIR" && ls -1 *.css | sed 's/.css$//' )
    read -r -p "Enter theme name: " THEME
    SRC_THEME="$THEME_DIR/$THEME.css"
    DST_THEME="$WEB_DIR/src/assets/theme.css"
    if [ ! -f "$SRC_THEME" ]; then
      echo "Theme '$THEME' not found at $SRC_THEME"
      exit 1
    fi
    mkdir -p "$(dirname "$DST_THEME")"
    cp "$SRC_THEME" "$DST_THEME"
    echo "Theme '$THEME' copied to $DST_THEME"
    ;;
  *)
    echo "Invalid choice. Nothing changed."
    exit 1
    ;;
esac

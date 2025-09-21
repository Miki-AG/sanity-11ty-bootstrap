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
echo "  1) Add new templates/pages/schemas (no overwrite, keeps existing base.njk)"
echo "  2) Add + update templates/pages/schemas (overwrite, keeps existing base.njk)"
echo "  3) Update scripts (.eleventy.js + listen.js + base.njk)"
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
      # Always refresh schema aggregator files so new components are registered
      for f in index.ts landingPage.ts; do
        if [ -f "$SRC_SCHEMA_ROOT/$f" ]; then
          cp "$SRC_SCHEMA_ROOT/$f" "$DST_SCHEMA_ROOT/$f"
          echo "~ cms/schemaTypes/$f updated"
        fi
      done
    else
      echo "Note: Skipped schemas (cms/ missing or source schemas not found)."
    fi
    bash "$SCRIPT_DIR/_update_data.sh" "$SCRIPT_DIR" "$WEB_DIR"
    echo "Done. base.njk unchanged (only updated via option 3)."
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
    echo "Done. base.njk unchanged (only updated via option 3)."
    ;;
  3)
    bash "$SCRIPT_DIR/_update_listenjs.sh" "$SCRIPT_DIR" "$WEB_DIR"
    if [ -f "$SRC_INCLUDES_ROOT/base.njk" ]; then
      mkdir -p "$DST_INCLUDES_ROOT"
      cp "$SRC_INCLUDES_ROOT/base.njk" "$DST_INCLUDES_ROOT/base.njk"
      echo "~ base.njk updated"
    fi
    echo "Scripts updated (base.njk refreshed)."
    ;;
  4)
    THEME_DIR="$SCRIPT_DIR/bootstrap/web/src/assets/themes"
    if [ ! -d "$THEME_DIR" ]; then
      echo "No themes directory found at $THEME_DIR"
      exit 1
    fi
    echo "Available themes:"
    i=1
    THEMES=()
    while IFS= read -r t; do
      name="${t%.css}"
      THEMES+=("$name")
      printf "  %d) %s\n" "$i" "$name"
      i=$((i+1))
    done < <(cd "$THEME_DIR" && ls -1 *.css)
    if [ ${#THEMES[@]} -eq 0 ]; then
      echo "No theme files found in $THEME_DIR"
      exit 1
    fi
    read -r -p "Pick a theme [1-${#THEMES[@]}]: " idx
    if ! [[ "$idx" =~ ^[0-9]+$ ]] || [ "$idx" -lt 1 ] || [ "$idx" -gt ${#THEMES[@]} ]; then
      echo "Invalid selection."
      exit 1
    fi
    THEME="${THEMES[$((idx-1))]}"
    SRC_THEME="$THEME_DIR/$THEME.css"
    DST_THEME="$WEB_DIR/src/assets/theme.css"
    mkdir -p "$(dirname "$DST_THEME")"
    cp "$SRC_THEME" "$DST_THEME"
    echo "Theme '$THEME' copied to $DST_THEME"
    ;;
  *)
    echo "Invalid choice. Nothing changed."
    exit 1
    ;;
esac

#!/bin/bash

# This script updates the Sanity schemas in an existing project.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$1" ]; then
  echo "Error: Project directory not provided."
  echo "Usage: ./update.sh /path/to/your/project"
  exit 1
fi

PROJECT_DIR=$1
CMS_DIR="$PROJECT_DIR/cms"
SCHEMA_DIR="$CMS_DIR/schemaTypes"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: Project directory '$PROJECT_DIR' not found."
  exit 1
fi

if [ ! -d "$CMS_DIR" ]; then
  echo "Error: CMS directory '$CMS_DIR' not found."
  exit 1
fi

echo "Updating schemas in '$SCHEMA_DIR'..."
cp -r "$SCRIPT_DIR/bootstrap/cms/schemaTypes" "$CMS_DIR"
echo "Schemas updated successfully."

WEB_DIR="$PROJECT_DIR/web"
INCLUDES_DIR="$WEB_DIR/src/_includes"

if [ ! -d "$WEB_DIR" ]; then
  echo "Error: Web directory '$WEB_DIR' not found."
  exit 1
fi

if [ ! -d "$INCLUDES_DIR" ]; then
  echo "Error: Includes directory '$INCLUDES_DIR' not found."
  exit 1
fi

echo "Syncing all Nunjucks includes in '$INCLUDES_DIR'..."
mkdir -p "$INCLUDES_DIR"
cp -R "$SCRIPT_DIR/bootstrap/web/src/_includes/." "$INCLUDES_DIR/"
echo "Includes updated successfully."

# --- Sync all data definitions ---
echo "Syncing all data definitions in 'web/src/_data'..."
mkdir -p "$WEB_DIR/src/_data"
cp -R "$SCRIPT_DIR/bootstrap/web/src/_data/." "$WEB_DIR/src/_data/"
echo "Data definitions updated."

# --- Sync Eleventy config (registers filters, etc.) ---
ELEVENTY_SRC="$SCRIPT_DIR/bootstrap/web/.eleventy.js"
ELEVENTY_DST="$WEB_DIR/.eleventy.js"
if [ -f "$ELEVENTY_SRC" ]; then
  if [ -f "$ELEVENTY_DST" ]; then
    cp "$ELEVENTY_DST" "$ELEVENTY_DST.bak"
    echo "Backed up existing .eleventy.js to .eleventy.js.bak"
  fi
  cp "$ELEVENTY_SRC" "$ELEVENTY_DST"
  echo ".eleventy.js updated."
fi

# --- Sync listener script (for live rebuilds) ---
LISTENER_SRC="$SCRIPT_DIR/bootstrap/web/listen.js"
LISTENER_DST="$WEB_DIR/listen.js"
if [ -f "$LISTENER_SRC" ]; then
  cp "$LISTENER_SRC" "$LISTENER_DST"
  echo "listen.js updated."
fi

# --- Sync pages (copy all templates under pages/) ---
PAGES_DIR_SRC="$SCRIPT_DIR/bootstrap/web/src/pages"
PAGES_DIR_DST="$WEB_DIR/src/pages"
mkdir -p "$PAGES_DIR_DST"
echo "Syncing pages from '$PAGES_DIR_SRC' to '$PAGES_DIR_DST'..."
cp -R "$PAGES_DIR_SRC/." "$PAGES_DIR_DST/"
echo "Pages updated."

echo "Update complete."

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

if [ ! -d "$WEB_DIR" ]; then
  echo "Error: Web directory '$WEB_DIR' not found."
  exit 1
fi

echo "Syncing entire web/src from bootstrap (cp -R merge, keep extras)..."
mkdir -p "$WEB_DIR/src"
cp -R "$SCRIPT_DIR/bootstrap/web/src/." "$WEB_DIR/src/"
echo "web/src updated."

echo "Syncing Eleventy root files..."
cp -R "$SCRIPT_DIR/bootstrap/web/.eleventy.js" "$WEB_DIR/.eleventy.js"
cp -R "$SCRIPT_DIR/bootstrap/web/listen.js" "$WEB_DIR/listen.js"
echo "Root files updated."

echo "Update complete."

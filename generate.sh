#!/bin/bash

# This script generates a new Sanity + 11ty project in the current directory.
# It reads configuration from a .env file in the same directory.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_DIR=$(pwd)

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Read .env file ---
if [ -f "$PROJECT_DIR/.env" ]; then
  set -a # automatically export all variables
  source "$PROJECT_DIR/.env"
  set +a # stop exporting
else
  echo "Error: .env file not found in the current directory. Please create one."
  exit 1
fi

# --- Check for required variables ---
if [ -z "$PROJECT_NAME" ] || [ -z "$SANITY_PROJECT_ID" ] || [ -z "$SANITY_DATASET" ]; then
  echo "Error: PROJECT_NAME, SANITY_PROJECT_ID, and SANITY_DATASET must be set in the .env file."
  exit 1
fi

# --- Check for Sanity CLI and login status ---
if ! command_exists sanity; then
    echo "Error: Sanity CLI not found. Please run 'npm install -g @sanity/cli'."
    exit 1
fi

echo "Checking Sanity login status..."
if ! sanity projects list > /dev/null 2>&1; then
  echo "Error: Could not list Sanity projects. Please ensure you are logged in with 'sanity login'."
  exit 1
fi
echo "Sanity login status: OK"

# --- Start project setup ---

if [ -d "$PROJECT_DIR/cms" ] || [ -d "$PROJECT_DIR/web" ]; then
  echo "Warning: 'cms' or 'web' directory already exists. Deleting them to start fresh."
  rm -rf "$PROJECT_DIR/cms" "$PROJECT_DIR/web"
fi

echo "Creating project in '$PROJECT_DIR'..."

WEB_DIR="$PROJECT_DIR/web"
CMS_DIR="$PROJECT_DIR/cms"
mkdir -p "$WEB_DIR"
mkdir -p "$CMS_DIR"

# --- Setup web (11ty) ---
echo "Setting up 11ty site in $WEB_DIR..."
(
  cd "$WEB_DIR" || exit
  npm init -y > /dev/null 2>&1
  npm pkg set type="module" > /dev/null 2>&1
  npm install @11ty/eleventy nunjucks @sanity/client dotenv groq > /dev/null 2>&1

  echo "Copying bootstrap files for 11ty..."
  cp "$SCRIPT_DIR/bootstrap/web/.eleventy.js" .
  cp "$SCRIPT_DIR/bootstrap/web/listen.js" .
  cp -r "$SCRIPT_DIR/bootstrap/web/src" .

  # Create .env file in web directory
  cat << EOF > .env
SANITY_PROJECT_ID=$SANITY_PROJECT_ID
SANITY_DATASET=$SANITY_DATASET
SANITY_API_VERSION=2025-01-01
EOF
  echo "Created .env file in web/ with your Sanity credentials."
)
echo "Eleventy setup complete in web directory."

# --- Setup cms (Sanity Studio) ---
echo "Setting up Sanity Studio in $CMS_DIR..."
(
  cd "$CMS_DIR" || exit
  # Create package.json
  cat << EOF > package.json
{
  "name": "cms",
  "private": true,
  "version": "1.0.0",
  "main": "package.json",
  "license": "UNLICENSED",
  "scripts": {
    "dev": "sanity dev",
    "start": "sanity start",
    "build": "sanity build",
    "deploy": "sanity deploy",
    "deploy-graphql": "sanity graphql deploy"
  },
  "dependencies": {
    "@sanity/vision": "^4.0.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "sanity": "^4.0.0",
    "styled-components": "^6.1.15"
  },
  "devDependencies": {
    "@types/react": "^19.0.0",
    "typescript": "^5.0.0"
  }
}
EOF

  npm install > /dev/null 2>&1
  echo "Updating Sanity dependencies..."
  npm update > /dev/null 2>&1

  echo "Copying schemas..."
  cp -r "$SCRIPT_DIR/bootstrap/cms/schemaTypes" .

  echo "Creating Sanity configuration..."
  # Create sanity.config.ts
  cat << EOF > sanity.config.ts
import {defineConfig} from 'sanity'
import {structureTool} from 'sanity/structure'
import {visionTool} from '@sanity/vision'
import {schemaTypes} from './schemaTypes'

export default defineConfig({
  name: 'default',
  title: '$PROJECT_NAME',
  projectId: '$SANITY_PROJECT_ID',
  dataset: '$SANITY_DATASET',
  plugins: [structureTool(), visionTool()],
  schema: {
    types: schemaTypes,
  },
})
EOF

  # Create sanity.cli.ts
  cat << EOF > sanity.cli.ts
import {defineCliConfig} from 'sanity/cli'

export default defineCliConfig({
  api: {
    projectId: "$SANITY_PROJECT_ID",
    dataset: "$SANITY_DATASET"
  }
})
EOF
)
echo "Sanity setup complete."

# --- Final instructions ---
echo "--------------------------------------------------------------------------------"
echo "Setup complete!"
echo ""
echo "To run the development servers, run the following command from the generator directory:"
echo "$SCRIPT_DIR/serve.sh $PROJECT_DIR"
echo ""
echo "To stop the development servers, run the following command from the generator directory:"
echo "$SCRIPT_DIR/stop.sh $PROJECT_DIR"
echo "--------------------------------------------------------------------------------"

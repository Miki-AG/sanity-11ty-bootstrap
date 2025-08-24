#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ask for project name
read -p "Enter the project name: " project_name

# Create project directory
mkdir -p "$project_name"
cd "$project_name" || exit

# Create web and cms directories
mkdir -p web cms

# --- Setup web (11ty) ---
cd web || exit
echo "Setting up 11ty site in web/..."
npm init -y > /dev/null 2>&1
npm pkg set type="module" > /dev/null 2>&1
npm install @11ty/eleventy nunjucks @sanity/client dotenv groq > /dev/null 2>&1

echo "Copying bootstrap files for 11ty..."
cp ../../bootstrap/web/.eleventy.js .
cp -r ../../bootstrap/web/src .

echo "Eleventy setup complete in web directory."

# --- Setup cms (Sanity Studio) ---
cd ../cms || exit
echo "Setting up Sanity Studio in cms/..."

# Install Sanity CLI if not present
if ! command_exists sanity;
    then
    echo "Installing Sanity CLI globally..."
    npm install -g @sanity/cli
fi

# Run sanity init interactively
echo "--------------------------------------------------------------------------------"
echo "When prompted by 'sanity init', please choose the following options:"
echo "1. Log in or create a new account."
echo "2. Choose 'Create new project'."
echo "3. Select the 'Clean project with no predefined schemas' template."
echo "4. When asked about project output path, confirm the default."
echo "5. Select 'TypeScript' when asked."
echo "--------------------------------------------------------------------------------"
sanity init

# Wait for confirmation
read -p "Press enter after completing sanity init..."

if [ -f sanity.config.ts ]; then
  echo "Copying bootstrap schemas for Sanity..."
  rm -rf schemaTypes
  cp -r ../../bootstrap/cms/schemaTypes .

  echo "Updating sanity.config.ts..."
  # Add import for schemaTypes if it's not there
  grep -q "import {schemaTypes} from './schemaTypes'" sanity.config.ts || sed -i '' "/import {defineConfig} from 'sanity'/a\\
import {schemaTypes} from './schemaTypes'\n" sanity.config.ts

  # Replace the empty types array with our schemaTypes
  sed -i '' 's/types: \[ \]/types: schemaTypes/' sanity.config.ts
else
  echo "Error: sanity.config.ts not found."
  echo "Please ensure you run 'sanity init' and select a TypeScript project."
  exit 1
fi

echo "Sanity setup complete."

# --- Link web and cms ---
echo "Linking Sanity project to the 11ty site..."
read -p "Enter your Sanity Project ID: " project_id
read -p "Enter your Sanity Dataset (default: production): " dataset
dataset=${dataset:-production}

# Create .env file in web directory
cd ../web || exit
cat << EOF > .env
SANITY_PROJECT_ID=$project_id
SANITY_DATASET=$dataset
SANITY_API_VERSION=2025-01-01
EOF
echo "Created .env file in web/ with your Sanity credentials."

echo "--------------------------------------------------------------------------------"
echo "Setup complete!"
echo ""
echo "To run the 11ty development server:"
echo "cd web && npm install && npx @11ty/eleventy --serve"

echo "To run the Sanity Studio:"
echo "cd cms && npm install && npm run dev"
echo "--------------------------------------------------------------------------------"

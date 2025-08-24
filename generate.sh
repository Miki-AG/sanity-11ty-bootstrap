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

# Setup web (11ty with Nunjucks)
cd web || exit
npm init -y > /dev/null 2>&1
npm install @11ty/eleventy nunjucks @sanity/client @sanity/image-url dotenv --save > /dev/null 2>&1

# Create .eleventy.js
cat << EOF > .eleventy.js
require('dotenv').config();
const {createClient} = require('@sanity/client');
const imageUrlBuilder = require('@sanity/image-url');

const client = createClient({
  projectId: process.env.SANITY_PROJECT_ID,
  dataset: process.env.SANITY_DATASET,
  apiVersion: '2023-01-01',
  useCdn: true
});

const builder = imageUrlBuilder(client);

function urlFor(source) {
  return builder.image(source).url();
}

module.exports = function(eleventyConfig) {
  eleventyConfig.setTemplateFormats(["njk"]);

  // Add Nunjucks filter for Sanity images
  eleventyConfig.addNunjucksFilter("sanityImage", function(image) {
    return urlFor(image);
  });

  return {
    dir: {
      input: "src",
      output: "_site"
    }
  };
};
EOF

# Create src directory and a sample index.njk
mkdir -p src
cat << EOF > src/index.njk
---
title: Home
---
<h1>{{ title }}</h1>
{% for landing in landingPages %}
  <h2>{{ landing.title }}</h2>
  {% for section in landing.sections %}
    {% if section._type == "imageWithCaption" %}
      <img src="{{ section.image | sanityImage }}" alt="{{ section.caption }}">
      <p>{{ section.caption }}</p>
    {% elseif section._type == "twoColumnText" %}
      <div style="display: flex;">
        <div>{{ section.left }}</div>
        <div>{{ section.right }}</div>
      </div>
    {% endif %}
  {% endfor %}
{% endfor %}
EOF

# Create _data directory and landingPages.js
mkdir -p src/_data
cat << EOF > src/_data/landingPages.js
const {createClient} = require('@sanity/client');

const client = createClient({
  projectId: process.env.SANITY_PROJECT_ID,
  dataset: process.env.SANITY_DATASET,
  apiVersion: '2023-01-01',
  useCdn: true
});

module.exports = async function() {
  const query = '*[_type == "landingPage"]';
  return await client.fetch(query);
};
EOF

# Create .env
cat << EOF > .env.example
SANITY_PROJECT_ID=
SANITY_DATASET=
EOF
cp .env.example .env

echo "Eleventy setup complete in web directory."

# Setup cms (Sanity Studio)
cd ../cms || exit

# Install Sanity CLI if not present
if ! command_exists sanity; then
    echo "Installing Sanity CLI globally..."
    npm install -g @sanity/cli
fi

# Run sanity init interactively
echo "Setting up Sanity Studio. Follow the prompts to log in, create/select project, and dataset."
sanity init

# Wait for confirmation
read -p "Press enter after completing sanity init..."

# Determine if TypeScript or JavaScript
is_typescript=false
if [ -f sanity.config.ts ]; then
  is_typescript=true
fi

# Add custom schemas
mkdir -p schemas

if $is_typescript; then
  # For TypeScript - overwrite schemaTypes/index.ts
  cat << EOF > schemaTypes/index.ts
import {defineType, defineField, defineArrayMember} from 'sanity'

// Image with Caption
export const imageWithCaption = defineType({
  name: 'imageWithCaption',
  title: 'Image with Caption',
  type: 'object',
  fields: [
    defineField({
      name: 'image',
      title: 'Image',
      type: 'image',
      options: { hotspot: true }
    }),
    defineField({
      name: 'caption',
      title: 'Caption',
      type: 'string'
    })
  ]
});

// Two Column Text
export const twoColumnText = defineType({
  name: 'twoColumnText',
  title: 'Two Column Text',
  type: 'object',
  fields: [
    defineField({
      name: 'left',
      title: 'Left Column',
      type: 'text'
    }),
    defineField({
      name: 'right',
      title: 'Right Column',
      type: 'text'
    })
  ]
});

// Landing Page Document
export const landingPage = defineType({
  name: 'landingPage',
  title: 'Landing Page',
  type: 'document',
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string'
    }),
    defineField({
      name: 'sections',
      title: 'Sections',
      type: 'array',
      of: [
        defineArrayMember({ type: 'imageWithCaption' }),
        defineArrayMember({ type: 'twoColumnText' })
      ]
    })
  ]
});

// Export all schema types
export const schemaTypes = [landingPage, imageWithCaption, twoColumnText]
EOF

  # Update sanity.config.ts to ensure import and schema.types
  if [ -f sanity.config.ts ]; then
    # Add import if not present
    grep -q "import {schemaTypes} from './schemas'" sanity.config.ts || sed -i '' "/import {deskTool} from 'sanity\/desk'/a\\
import {schemaTypes} from './schemas'\\
" sanity.config.ts

    # Update types if not already set
    grep -q "types: schemaTypes" sanity.config.ts || sed -i '' "s/types: \[\]/types: schemaTypes/g" sanity.config.ts
  else
    echo "Warning: sanity.config.ts not found. Manually update your config to include the schemaTypes."
  fi
else
  # For JavaScript (fallback)
  mkdir -p schemas/documents schemas/objects

  # imageWithCaption.js
  cat << EOF > schemas/objects/imageWithCaption.js
export default {
  name: 'imageWithCaption',
  title: 'Image with Caption',
  type: 'object',
  fields: [
    {
      name: 'image',
      title: 'Image',
      type: 'image',
      options: { hotspot: true }
    },
    {
      name: 'caption',
      title: 'Caption',
      type: 'string'
    }
  ]
};
EOF

  # twoColumnText.js
  cat << EOF > schemas/objects/twoColumnText.js
export default {
  name: 'twoColumnText',
  title: 'Two Column Text',
  type: 'object',
  fields: [
    {
      name: 'left',
      title: 'Left Column',
      type: 'text'
    },
    {
      name: 'right',
      title: 'Right Column',
      type: 'text'
    }
  ]
};
EOF

  # landingPage.js
  cat << EOF > schemas/documents/landingPage.js
export default {
  name: 'landingPage',
  title: 'Landing Page',
  type: 'document',
  fields: [
    {
      name: 'title',
      title: 'Title',
      type: 'string'
    },
    {
      name: 'sections',
      title: 'Sections',
      type: 'array',
      of: [
        { type: 'imageWithCaption' },
        { type: 'twoColumnText' }
      ]
    }
  ]
};
EOF

  # Overwrite or create schemaTypes/index.js
  cat << EOF > schemaTypes/index.js
import landingPage from './documents/landingPage'
import imageWithCaption from './objects/imageWithCaption'
import twoColumnText from './objects/twoColumnText'

export const schemaTypes = [landingPage, imageWithCaption, twoColumnText]
EOF

fi

# Ask for Sanity details to link with web
read -p "Enter Sanity Project ID: " project_id
read -p "Enter Sanity Dataset (e.g., production): " dataset
dataset=${dataset:-production}

# Update web/.env
cd ../web || exit
echo "SANITY_PROJECT_ID=$project_id" > .env
echo "SANITY_DATASET=$dataset" >> .env

echo "Setup complete!"
echo "To run Eleventy: cd web && npx @11ty/eleventy --serve"
echo "To run Sanity Studio: cd cms && npm run dev"
echo "The image URLs are handled via the 'sanityImage' Nunjucks filter."
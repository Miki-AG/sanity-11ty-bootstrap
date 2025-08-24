#!/bin/bash

# This script stops the development servers for a Sanity + 11ty project.

if [ -z "$1" ]; then
  echo "Error: Project directory not provided."
  echo "Usage: ./stop.sh /path/to/your/project"
  exit 1
fi

PROJECT_DIR=$1

# --- Read .env file ---
if [ -f "$PROJECT_DIR/.env" ]; then
  set -a # automatically export all variables
  source "$PROJECT_DIR/.env"
  set +a # stop exporting
else
  echo "Error: .env file not found in $PROJECT_DIR. Please ensure it exists."
  exit 1
fi

# Stop processes if running
if pm2 pid "11ty-$PROJECT_NAME" > /dev/null; then
  echo "Stopping 11ty server for project '$PROJECT_NAME'..."
  pm2 stop "11ty-$PROJECT_NAME"
  pm2 delete "11ty-$PROJECT_NAME"
else
  echo "11ty server for project '$PROJECT_NAME' is not running."
fi

if pm2 pid "sanity-$PROJECT_NAME" > /dev/null; then
  echo "Stopping Sanity Studio for project '$PROJECT_NAME'..."
  pm2 stop "sanity-$PROJECT_NAME"
  pm2 delete "sanity-$PROJECT_NAME"
else
  echo "Sanity Studio for project '$PROJECT_NAME' is not running."
fi

if pm2 pid "listener-$PROJECT_NAME" > /dev/null; then
  echo "Stopping Sanity listener for project '$PROJECT_NAME'..."
  pm2 stop "listener-$PROJECT_NAME"
  pm2 delete "listener-$PROJECT_NAME"
else
  echo "Sanity listener for project '$PROJECT_NAME' is not running."
fi

echo "All servers for project '$PROJECT_NAME' stopped."

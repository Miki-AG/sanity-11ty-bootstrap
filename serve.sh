#!/bin/bash

# This script starts the development servers for a Sanity + 11ty project.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$1" ]; then
  echo "Error: Project directory not provided."
  echo "Usage: ./serve.sh /path/to/your/project"
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

WEB_DIR="$PROJECT_DIR/web"
CMS_DIR="$PROJECT_DIR/cms"
LOG_DIR="$SCRIPT_DIR/logs"

if [ ! -d "$WEB_DIR" ] || [ ! -d "$CMS_DIR" ]; then
  echo "Error: 'web' or 'cms' directory not found in $PROJECT_DIR. Please run generate.sh first."
  exit 1
fi

rm -rf "$LOG_DIR/$PROJECT_NAME"
mkdir -p "$LOG_DIR/$PROJECT_NAME"

# Preflight: run a one-off 11ty build to catch template errors
echo "Running preflight 11ty build to catch template errors..."
if ! ( cd "$WEB_DIR" && npx @11ty/eleventy > "$LOG_DIR/$PROJECT_NAME/11ty-preflight.log" 2>&1 ); then
  echo "Preflight build FAILED. See $LOG_DIR/$PROJECT_NAME/11ty-preflight.log for details."
  echo "Tip: run 'npx @11ty/eleventy' in $WEB_DIR to reproduce locally."
  exit 1
fi
echo "Preflight build passed. Starting dev servers..."

# Start 11ty server with pm2
echo "Starting 11ty server for project '$PROJECT_NAME' ભા"
pm2 start "npx @11ty/eleventy --serve" \
  --name "11ty-$PROJECT_NAME" \
  --cwd "$WEB_DIR" \
  --output "$LOG_DIR/$PROJECT_NAME/11ty-out.log" \
  --error "$LOG_DIR/$PROJECT_NAME/11ty-error.log" || { echo "Failed to start 11ty"; exit 1; }

# Start Sanity server with pm2
echo "Starting Sanity Studio for project '$PROJECT_NAME' ભા"
pm2 start "export NODE_OPTIONS=--openssl-legacy-provider && npm run dev" \
  --name "sanity-$PROJECT_NAME" \
  --cwd "$CMS_DIR" \
  --output "$LOG_DIR/$PROJECT_NAME/sanity-out.log" \
  --error "$LOG_DIR/$PROJECT_NAME/sanity-error.log" || { echo "Failed to start Sanity"; exit 1; }

# Start Sanity listener with pm2
echo "Starting Sanity listener for project '$PROJECT_NAME' ભા"
pm2 start "node ./listen.js" \
  --name "listener-$PROJECT_NAME" \
  --cwd "$WEB_DIR" \
  --output "$LOG_DIR/$PROJECT_NAME/listener-out.log" \
  --error "$LOG_DIR/$PROJECT_NAME/listener-error.log" || { echo "Failed to start listener"; exit 1; }

# Wait a bit for servers to start
echo "Waiting for servers to start..."
sleep 8

# Open browser tabs in Google Chrome
echo "Opening browser tabs in Google Chrome..."
osascript <<'END'

tell application "Google Chrome"
    if not (exists window 1) then make new window
    set screen_bounds to bounds of window 1
    set screen_width to item 3 of screen_bounds
    set screen_height to item 4 of screen_bounds
    set half_width to screen_width / 2

    set window1 to make new window with properties {bounds:{0, 22, half_width, screen_height}}
    set URL of active tab of window1 to "http://localhost:8080"

    set window2 to make new window with properties {bounds:{half_width, 22, screen_width, screen_height}}
    set URL of active tab of window2 to "http://localhost:3333"

    activate
end tell
END

echo "Servers are running under pm2. Use '$SCRIPT_DIR/stop.sh $PROJECT_DIR' to stop them, or 'pm2 logs' to view logs."

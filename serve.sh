#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --- Read .env file ---
if [ -f "$SCRIPT_DIR/.env" ]; then
  set -a # automatically export all variables
  source "$SCRIPT_DIR/.env"
  set +a # stop exporting
else
  echo "Error: .env file not found in $SCRIPT_DIR. Please create one from .env.example."
  exit 1
fi

if [ -z "$PROJECT_NAME" ]; then
  echo "Error: PROJECT_NAME must be set in the .env file."
  exit 1
fi

PROJECT_DIR="$SCRIPT_DIR/$PROJECT_NAME"
WEB_DIR="$PROJECT_DIR/web"
CMS_DIR="$PROJECT_DIR/cms"
LOG_DIR="$SCRIPT_DIR/logs"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Project directory '$PROJECT_DIR' not found. Please run ./generate.sh first."
  exit 1
fi

rm -rf "$LOG_DIR"
mkdir -p "$LOG_DIR"

# Start 11ty server with pm2
echo "Starting 11ty server... (logs: $LOG_DIR/11ty-out.log and $LOG_DIR/11ty-error.log)"
pm2 start "npx @11ty/eleventy --serve" \
  --name 11ty \
  --cwd "$WEB_DIR" \
  --output "$LOG_DIR/11ty-out.log" \
  --error "$LOG_DIR/11ty-error.log" || { echo "Failed to start 11ty"; exit 1; }

# Start Sanity server with pm2
echo "Starting Sanity Studio... (logs: $LOG_DIR/sanity-out.log and $LOG_DIR/sanity-error.log)"
pm2 start "export NODE_OPTIONS=--openssl-legacy-provider && npm run dev" \
  --name sanity \
  --cwd "$CMS_DIR" \
  --output "$LOG_DIR/sanity-out.log" \
  --error "$LOG_DIR/sanity-error.log" || { echo "Failed to start Sanity"; exit 1; }

# Start Sanity listener with pm2
echo "Starting Sanity listener for real-time updates... (logs: $LOG_DIR/listener-out.log and $LOG_DIR/listener-error.log)"
pm2 start "node ./listen.js" \
  --name listener \
  --cwd "$WEB_DIR" \
  --output "$LOG_DIR/listener-out.log" \
  --error "$LOG_DIR/listener-error.log" || { echo "Failed to start listener"; exit 1; }

# Wait a bit for servers to start
echo "Waiting for servers to start..."
sleep 5

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

echo "Servers are running under pm2. Use ./stop.sh to stop them, or 'pm2 logs' to view logs."
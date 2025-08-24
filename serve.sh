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
PID_DIR="$SCRIPT_DIR/.pids"
LOG_DIR="$SCRIPT_DIR/logs"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Project directory '$PROJECT_DIR' not found. Please run ./generate.sh first."
  exit 1
fi

mkdir -p "$PID_DIR"
mkdir -p "$LOG_DIR"

# Start 11ty server
echo "Starting 11ty server... (log: $LOG_DIR/11ty.log)"
(
  cd "$WEB_DIR" || exit
  npx @11ty/eleventy --serve &> "$LOG_DIR/11ty.log" &
  PID=$!
  PGID=$(ps -o pgid= -p $PID | grep -o '[0-9]*')
  echo $PGID > "$PID_DIR/11ty.pgid"
)

# Start Sanity server
echo "Starting Sanity Studio... (log: $LOG_DIR/sanity.log)"
(
  cd "$CMS_DIR" || exit
  npm run dev &> "$LOG_DIR/sanity.log" &
  PID=$!
  PGID=$(ps -o pgid= -p $PID | grep -o '[0-9]*')
  echo $PGID > "$PID_DIR/sanity.pgid"
)

# Start Sanity listener
echo "Starting Sanity listener for real-time updates... (log: $LOG_DIR/listener.log)"
(
  cd "$WEB_DIR" || exit
  node ./listen.js &> "$LOG_DIR/listener.log" &
  PID=$!
  PGID=$(ps -o pgid= -p $PID | grep -o '[0-9]*')
  echo $PGID > "$PID_DIR/listener.pgid"
)

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

echo "Servers are running in the background. Use ./stop.sh to stop them."

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

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Project directory '$PROJECT_DIR' not found. Please run ./generate.sh first."
  exit 1
fi

mkdir -p "$PID_DIR"

# Start 11ty server
echo "Starting 11ty server..."
(
  cd "$WEB_DIR" || exit
  npx @11ty/eleventy --serve &
  echo $! > "$PID_DIR/11ty.pid"
)

# Start Sanity server
echo "Starting Sanity Studio..."
(
  cd "$CMS_DIR" || exit
  npm run dev &
  echo $! > "$PID_DIR/sanity.pid"
)

# Start Sanity listener
echo "Starting Sanity listener for real-time updates..."
(
  cd "$WEB_DIR" || exit
  node ./listen.js &
  echo $! > "$PID_DIR/listener.pid"
)

# Wait a bit for servers to start
echo "Waiting for servers to start..."
sleep 8

# Open browser tabs
echo "Opening browser tabs..."
open http://localhost:8080
open http://localhost:3333

echo "Servers are running in the background. Use ./stop.sh to stop them."

#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PID_DIR="$SCRIPT_DIR/.pids"

if [ -f "$PID_DIR/11ty.pid" ]; then
  PID=$(cat "$PID_DIR/11ty.pid")
  echo "Stopping 11ty server (PID: $PID)..."
  kill "$PID" &> /dev/null
  rm "$PID_DIR/11ty.pid"
else
  echo "11ty server is not running."
fi

if [ -f "$PID_DIR/sanity.pid" ]; then
  PID=$(cat "$PID_DIR/sanity.pid")
  echo "Stopping Sanity Studio (PID: $PID)..."
  kill "$PID" &> /dev/null
  rm "$PID_DIR/sanity.pid"
else
  echo "Sanity Studio is not running."
fi

if [ -f "$PID_DIR/listener.pid" ]; then
  PID=$(cat "$PID_DIR/listener.pid")
  echo "Stopping Sanity listener (PID: $PID)..."
  kill "$PID" &> /dev/null
  rm "$PID_DIR/listener.pid"
else
  echo "Sanity listener is not running."
fi

# Clean up pid directory if empty
if [ -d "$PID_DIR" ] && [ -z "$(ls -A $PID_DIR)" ]; then
   rmdir "$PID_DIR"
fi

echo "All servers stopped."

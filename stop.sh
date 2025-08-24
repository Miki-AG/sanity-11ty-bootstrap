#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PID_DIR="$SCRIPT_DIR/.pids"

if [ -f "$PID_DIR/11ty.pgid" ]; then
  PGID=$(cat "$PID_DIR/11ty.pgid")
  echo "Stopping 11ty server (PGID: $PGID)..."
  kill -- -"$PGID" &> /dev/null
  rm "$PID_DIR/11ty.pgid"
else
  echo "11ty server is not running."
fi

if [ -f "$PID_DIR/sanity.pgid" ]; then
  PGID=$(cat "$PID_DIR/sanity.pgid")
  echo "Stopping Sanity Studio (PGID: $PGID)..."
  kill -- -"$PGID" &> /dev/null
  rm "$PID_DIR/sanity.pgid"
else
  echo "Sanity Studio is not running."
fi

if [ -f "$PID_DIR/listener.pgid" ]; then
  PGID=$(cat "$PID_DIR/listener.pgid")
  echo "Stopping Sanity listener (PGID: $PGID)..."
  kill -- -"$PGID" &> /dev/null
  rm "$PID_DIR/listener.pgid"
else
  echo "Sanity listener is not running."
fi

# Clean up pid directory if empty
if [ -d "$PID_DIR" ] && [ -z "$(ls -A $PID_DIR)" ]; then
   rmdir "$PID_DIR"
fi

echo "All servers stopped."

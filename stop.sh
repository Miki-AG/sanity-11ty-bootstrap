#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Stop processes if running
if pm2 pid 11ty > /dev/null; then
  echo "Stopping 11ty server..."
  pm2 stop 11ty
  pm2 delete 11ty
else
  echo "11ty server is not running."
fi

if pm2 pid sanity > /dev/null; then
  echo "Stopping Sanity Studio..."
  pm2 stop sanity
  pm2 delete sanity
else
  echo "Sanity Studio is not running."
fi

if pm2 pid listener > /dev/null; then
  echo "Stopping Sanity listener..."
  pm2 stop listener
  pm2 delete listener
else
  echo "Sanity listener is not running."
fi

echo "All servers stopped."
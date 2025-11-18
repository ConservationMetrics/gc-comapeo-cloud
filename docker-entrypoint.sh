#!/usr/bin/env bash
set -e

# Default to /data if STORAGE_DIR isn't set (CapRover will set it)
STORAGE_DIR="${STORAGE_DIR:-/data}"

echo "Using STORAGE_DIR=${STORAGE_DIR}"

# Create directory if it doesn't exist and ensure node user owns it
if [ -n "${STORAGE_DIR}" ]; then
  mkdir -p "${STORAGE_DIR}"
  chown -R node:node "${STORAGE_DIR}"
fi

# Drop privileges to node user and exec the original CMD from base image
exec gosu node "$@"


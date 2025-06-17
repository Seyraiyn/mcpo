#!/bin/bash

# Check whether the configuration file path is passed as a parameter
if [ -n "$1" ]; then
  CONFIG_FILE="$1"
fi

# Check if the configuration file exists
if [ -f "$CONFIG_FILE" ]; then
  echo "Use profiles: $CONFIG_FILE"
  uvx mcpo --host 0.0.0.0 --port 8000 --config "$CONFIG_FILE"
else
  echo "The configuration file was not found: $CONFIG_FILE.  Use the default time server."
  uvx mcpo --host 0.0.0.0 --port 8000 -- uvx mcp-server-time --local-timezone=Europe/London
fi

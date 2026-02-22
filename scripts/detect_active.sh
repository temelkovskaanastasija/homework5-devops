#!/bin/bash
set -e

if grep -q "app-blue" ./nginx/active_upstream.conf; then
  echo "blue"
elif grep -q "app-green" ./nginx/active_upstream.conf; then
  echo "green"
else
  echo "unknown"
  exit 1
fi
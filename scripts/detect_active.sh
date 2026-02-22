#!/bin/bash
set -e

ACTIVE_CONF=$(docker exec bg-nginx cat /etc/nginx/conf.d/active_upstream.conf)

if echo "$ACTIVE_CONF" | grep -q "app-blue"; then
  echo "blue"
elif echo "$ACTIVE_CONF" | grep -q "app-green"; then
  echo "green"
else
  echo "unknown"
  exit 1
fi
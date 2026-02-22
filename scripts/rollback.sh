#!/bin/bash
set -e

if grep -q "app-blue" ./nginx/active_upstream.conf; then
  cp ./nginx/upstream_green.conf ./nginx/active_upstream.conf
  docker exec bg-nginx nginx -s reload
  echo "Rollback -> GREEN"
else
  cp ./nginx/upstream_blue.conf ./nginx/active_upstream.conf
  docker exec bg-nginx nginx -s reload
  echo "Rollback -> BLUE"
fi
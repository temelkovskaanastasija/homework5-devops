#!/bin/bash
set -e

cp ./nginx/upstream_green.conf ./nginx/active_upstream.conf
docker exec bg-nginx nginx -s reload
echo "Switched traffic to GREEN"
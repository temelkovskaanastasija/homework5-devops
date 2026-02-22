#!/bin/bash
set -e

docker cp ./nginx/upstream_blue.conf bg-nginx:/etc/nginx/conf.d/active_upstream.conf
docker exec bg-nginx nginx -s reload

echo "Switched traffic to BLUE"
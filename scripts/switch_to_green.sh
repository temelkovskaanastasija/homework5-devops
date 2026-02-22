#!/bin/bash
set -e

docker exec bg-nginx sh -c 'cat > /etc/nginx/conf.d/active_upstream.conf <<EOF
upstream active_backend {
    server app-green:8080;
}
EOF'

docker exec bg-nginx nginx -s reload

echo "Switched traffic to GREEN"
#!/bin/bash
set -e

ACTIVE=$(./scripts/detect_active.sh)

if [ "$ACTIVE" = "blue" ]; then
  ./scripts/switch_to_green.sh
  echo "Rollback -> GREEN"
else
  ./scripts/switch_to_blue.sh
  echo "Rollback -> BLUE"
fi
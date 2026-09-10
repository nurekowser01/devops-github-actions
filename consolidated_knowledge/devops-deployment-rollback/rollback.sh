#!/usr/bin/env bash
# rollback.sh
# Reverts a Docker Compose stack to the previous image SHA if a deployment fails.

set -euo pipefail

COMPOSE_FILE="docker-compose.yml"
PREVIOUS_SHA="${1:-}"

if [[ -z "$PREVIOUS_SHA" ]]; then
    echo "[ERROR] Previous SHA tag not provided."
    echo "Usage: ./rollback.sh <PREVIOUS_SHA>"
    exit 1
fi

echo "[CRITICAL] Deployment healthcheck failed! Triggering automatic rollback."

# Revert the compose file to the previous known good SHA
sed -i "s|image: .*:sha-.*|image: ghcr.io/nurekowser01/devops-docker-api:sha-${PREVIOUS_SHA}|g" "$COMPOSE_FILE"

echo "[*] Redeploying previous stable stack (sha-${PREVIOUS_SHA})..."
docker compose pull
docker compose up -d

echo "[SUCCESS] Rollback to sha-${PREVIOUS_SHA} completed."
# Note: Add webhook notification to Slack/PagerDuty here

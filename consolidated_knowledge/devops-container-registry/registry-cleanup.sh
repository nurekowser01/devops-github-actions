#!/usr/bin/env bash
# registry-cleanup.sh
# Prunes old packages from GitHub Container Registry (GHCR) to prevent storage bloat.

set -euo pipefail

# Configuration
ORG_NAME="nurekowser01"
PACKAGE_NAME="devops-docker-api"
KEEP_VERSIONS=15
TOKEN="${GH_PAT_TOKEN:-}"

if [[ -z "$TOKEN" ]]; then
  echo "[ERROR] GH_PAT_TOKEN environment variable is required."
  exit 1
fi

echo "[*] Fetching package versions for ${ORG_NAME}/${PACKAGE_NAME}..."

# Fetch all versions (requires delete:packages scope)
VERSIONS=$(curl -s -H "Authorization: Bearer ${TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/orgs/${ORG_NAME}/packages/container/${PACKAGE_NAME}/versions" \
  | jq -r '.[].id')

TOTAL=$(echo "$VERSIONS" | wc -w)

if [ "$TOTAL" -le "$KEEP_VERSIONS" ]; then
    echo "[OK] Only ${TOTAL} versions exist. No pruning required."
    exit 0
fi

DELETE_COUNT=$((TOTAL - KEEP_VERSIONS))
echo "[*] Found ${TOTAL} versions. Deleting the oldest ${DELETE_COUNT}..."

# Skip the first $KEEP_VERSIONS and delete the rest
for VERSION_ID in $(echo "$VERSIONS" | tail -n "$DELETE_COUNT"); do
    echo "Deleting version ID: ${VERSION_ID}"
    curl -s -X DELETE -H "Authorization: Bearer ${TOKEN}" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/orgs/${ORG_NAME}/packages/container/${PACKAGE_NAME}/versions/${VERSION_ID}"
done

echo "[SUCCESS] Cleanup complete."

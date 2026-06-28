#!/usr/bin/env bash
# deploy-preview.sh — Deploy preview site to Cloudflare Pages
# Usage: deploy-preview.sh <lead_id> [<slug>]
set -euo pipefail

LEAD_ID="${1:?Usage: deploy-preview.sh <lead_id> [slug]}"
SLUG="${2:-$LEAD_ID}"
PREVIEW_DIR="/tmp/preview-${SLUG}"
VAULT_DIR="$HOME/wingman/vault-sales/${LEAD_ID}"
CF_ENV="$HOME/.hermes/cloudflare.env"

if [ ! -f "${PREVIEW_DIR}/index.html" ]; then
    echo "ERROR: ${PREVIEW_DIR}/index.html not found" >&2
    exit 1
fi

if [ ! -f "$CF_ENV" ]; then
    echo "ERROR: $CF_ENV not found" >&2
    exit 1
fi

source "$CF_ENV"

PROJECT_NAME="${SLUG}"
SUBDOMAIN="${SLUG}.coreflux.studio"
ZONE_ID="2f6176c9af7dd3670cc83287f18f5f57"

echo "Deploying ${SLUG} to Cloudflare Pages..."

# Deploy to CF Pages (creates project on first run)
CLOUDFLARE_API_TOKEN="$CF_TOKEN" CLOUDFLARE_ACCOUNT_ID="$CF_ACCOUNT_ID" npx wrangler pages deploy "${PREVIEW_DIR}/"     --project-name "${PROJECT_NAME}"     --branch main     --commit-dirty true 2>&1

# Add custom subdomain DNS record if not exists
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records"     -H "Authorization: Bearer $CF_TOKEN"     -H "Content-Type: application/json"     --data "{
        \"type\": \"CNAME\",
        \"name\": \"${SLUG}\",
        \"content\": \"${PROJECT_NAME}.pages.dev\",
        \"proxied\": true,
        \"ttl\": 1
    }" > /dev/null 2>&1 || true

PREVIEW_URL="https://${SUBDOMAIN}/"
mkdir -p "${VAULT_DIR}"
echo "${PREVIEW_URL}" > "${VAULT_DIR}/preview_url.txt"
echo "Preview live: ${PREVIEW_URL}"

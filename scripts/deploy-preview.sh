#!/usr/bin/env bash
# deploy-preview.sh — Deploy preview to Cloudflare Pages on coreflux.studio
# Usage: deploy-preview.sh <lead_id> [<slug>]
set -euo pipefail

LEAD_ID="${1:?Usage: deploy-preview.sh <lead_id> [slug]}"
SLUG="${2:-$LEAD_ID}"
PREVIEW_DIR="/tmp/preview-${SLUG}"
VAULT_DIR="$HOME/wingman/vault-sales/${LEAD_ID}"
CF_ENV="$HOME/.hermes/cloudflare.env"
ZONE_ID="2f6176c9af7dd3670cc83287f18f5f57"

if [ ! -f "${PREVIEW_DIR}/index.html" ]; then
    echo "ERROR: ${PREVIEW_DIR}/index.html not found" >&2; exit 1
fi
if [ ! -f "$CF_ENV" ]; then
    echo "ERROR: $CF_ENV not found" >&2; exit 1
fi

source "$CF_ENV"
export CLOUDFLARE_API_TOKEN="$CF_TOKEN"
export CLOUDFLARE_ACCOUNT_ID="$CF_ACCOUNT_ID"

PROJECT_NAME="${SLUG}"

# Strip manifest comment block (LLM builder guide — not needed in deployed HTML,
# causes premature comment close on mobile due to --> inside the block)
python3 - "${PREVIEW_DIR}/index.html" << 'PYEOF'
import sys
path = sys.argv[1]
with open(path) as f:
    lines = f.readlines()
s = e = None
for i, l in enumerate(lines):
    if l.rstrip() == '<!--' and s is None:
        s = i
    elif l.rstrip() == '-->' and s is not None:
        e = i
        break
if s is not None and e is not None:
    lines = lines[:s] + lines[e+1:]
with open(path, 'w') as f:
    f.writelines(lines)
PYEOF

echo "Deploying ${SLUG} to Cloudflare Pages..."

# Create project if not exists (idempotent: ignore error if already exists)
npx wrangler pages project create "${PROJECT_NAME}" --production-branch main 2>&1 \
  | grep -v 'already exists' || true

# Deploy
npx wrangler pages deploy "${PREVIEW_DIR}/" \
    --project-name "${PROJECT_NAME}" \
    --branch main \
    --commit-dirty true 2>&1

# Add CNAME {slug}.coreflux.studio -> {slug}.pages.dev (proxied, idempotent)
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
    -H "Authorization: Bearer $CF_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"type\": \"CNAME\",
      \"name\": \"${SLUG}\",
      \"content\": \"${PROJECT_NAME}.pages.dev\",
      \"proxied\": true,
      \"ttl\": 1
    }" > /dev/null 2>&1 || true

# Add custom domain to CF Pages project (idempotent)
curl -s -X POST \
  "https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/pages/projects/${PROJECT_NAME}/domains" \
  -H "Authorization: Bearer $CF_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"${SLUG}.coreflux.studio\"}" > /dev/null 2>&1 || true

PREVIEW_URL="https://${SLUG}.coreflux.studio/"
mkdir -p "${VAULT_DIR}"
echo "${PREVIEW_URL}" > "${VAULT_DIR}/preview_url.txt"
echo "Preview live: ${PREVIEW_URL}"

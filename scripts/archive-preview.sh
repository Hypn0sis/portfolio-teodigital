#!/usr/bin/env bash
# archive-preview.sh — Archive preview site after lead responds or on TTL expiry
# Usage: archive-preview.sh <lead_id> [reason]
set -euo pipefail

LEAD_ID="${1:?Usage: archive-preview.sh <lead_id> [reason]}"
REASON="${2:-manual}"
VAULT_DIR="$HOME/wingman/vault-sales/${LEAD_ID}"
CF_ENV="$HOME/.hermes/cloudflare.env"
ZONE_ID="2f6176c9af7dd3670cc83287f18f5f57"

[ -d "$VAULT_DIR" ] || { echo "ERROR: vault dir not found: $VAULT_DIR" >&2; exit 1; }

source "$CF_ENV"
export CLOUDFLARE_API_TOKEN="$CF_TOKEN"
export CLOUDFLARE_ACCOUNT_ID="$CF_ACCOUNT_ID"

SLUG="$LEAD_ID"

echo "Archiving preview for $LEAD_ID (reason: $REASON)..."

# Save HTML to vault archive
if [ -f "/tmp/preview-${SLUG}/index.html" ]; then
    mkdir -p "$VAULT_DIR/site-archive"
    cp -r "/tmp/preview-${SLUG}/." "$VAULT_DIR/site-archive/"
    echo "HTML archived to $VAULT_DIR/site-archive/"
fi

# Delete CF Pages project
npx wrangler pages project delete "$SLUG" --yes 2>&1 | grep -E "(Deleted|Error|not found)" || true

# Remove CNAME DNS record
RECORD_ID=$(curl -s "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?name=${SLUG}.coreflux.studio" \
    -H "Authorization: Bearer $CF_TOKEN" | python3 -c "
import sys, json
data = json.load(sys.stdin)
result = data.get('result', [])
print(result[0]['id'] if result else '')
")
if [ -n "$RECORD_ID" ]; then
    curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
        -H "Authorization: Bearer $CF_TOKEN" > /dev/null
    echo "Removed CNAME ${SLUG}.coreflux.studio"
fi

# Append to outreach_log.md
if [ -f "$VAULT_DIR/outreach_log.md" ]; then
    echo "archived_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$VAULT_DIR/outreach_log.md"
    echo "archive_reason: $REASON" >> "$VAULT_DIR/outreach_log.md"
fi

rm -f "$VAULT_DIR/preview_url.txt"
echo "Done: $LEAD_ID archived"

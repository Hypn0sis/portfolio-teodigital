#!/usr/bin/env bash
# send-hookmail.sh <lead_id> [mock_email]
# Sends via Brevo SMTP (SPF-aligned with coreflux.studio).
set -euo pipefail

LEAD_ID="${1:?Usage: send-hookmail.sh <lead_id> [mock_email]}"
MOCK_EMAIL="${2:-}"
VAULT="$HOME/wingman/vault-sales/$LEAD_ID"
PROFILE="$VAULT/profile.md"
PREVIEW_URL_FILE="$VAULT/preview_url.txt"

[[ -f "$PROFILE" ]] || { echo "ERROR: profile.md not found"; exit 1; }

NOME=$(grep "^nome:" "$PROFILE" | cut -d: -f2- | xargs)
CITTA=$(grep "^citta:" "$PROFILE" | cut -d: -f2- | xargs)
CATEGORIA_RAW=$(grep "^categoria:" "$PROFILE" | cut -d: -f2- | xargs | tr "[:upper:]" "[:lower:]")
LEAD_EMAIL=$(grep "^email:" "$PROFILE" | cut -d: -f2- | xargs)

case "$CATEGORIA_RAW" in
  parrucchiere*) TIPO="un parrucchiere" ;;
  macelleria*)   TIPO="una macelleria" ;;
  panificio*)    TIPO="un panificio" ;;
  pasticceria*)  TIPO="una pasticceria" ;;
  ristorante*|trattoria*|osteria*) TIPO="un ristorante" ;;
  bar*)          TIPO="un bar" ;;
  *)             TIPO="una attivita come la vostra" ;;
esac

[[ -f "$PREVIEW_URL_FILE" ]] && PREVIEW_URL=$(cat "$PREVIEW_URL_FILE") || PREVIEW_URL=""

if [[ -n "$MOCK_EMAIL" ]]; then TO="$MOCK_EMAIL"
elif [[ -n "$LEAD_EMAIL" ]]; then TO="$LEAD_EMAIL"
else echo "ERROR: no recipient"; exit 1; fi

OUTREACH_LOG="$VAULT/outreach_log.md"
if [[ -z "$MOCK_EMAIL" && -f "$OUTREACH_LOG" ]] && grep -q "^status: sent" "$OUTREACH_LOG"; then
  echo "SKIP: already contacted"; exit 0; fi

BODY_HTML=$(NOME="$NOME" CITTA="$CITTA" TIPO="$TIPO" PREVIEW_URL="$PREVIEW_URL" python3 ~/wingman/scripts/hookmail_body.py)

echo "Sending to: $TO"
source "$HOME/.hermes/.env"

MSG_ID=$(python3 ~/wingman/scripts/hookmail_send.py \
  "$TO" "ho preparato qualcosa per voi" "$BODY_HTML" \
  "$BREVO_SMTP_SERVER" "$BREVO_SMTP_PORT" "$BREVO_SMTP_LOGIN" "$BREVO_SMTP_KEY" \
  "$COREFLUX_FROM" "$COREFLUX_FROM_NAME")

echo "MSG_ID: $MSG_ID"
[[ -z "$MSG_ID" ]] && { echo "ERROR: send failed"; exit 1; }

TO="$TO" MOCK_EMAIL="$MOCK_EMAIL" MSG_ID="$MSG_ID" PREVIEW_URL="$PREVIEW_URL" OUTREACH_LOG="$OUTREACH_LOG" python3 ~/wingman/scripts/hookmail_log.py
echo "OK: sent, message_id=$MSG_ID"

#!/usr/bin/env python3
"""auto-archive-previews.py — Archive previews older than TTL_DAYS without response. Run via cron."""
import os, subprocess, datetime

TTL_DAYS = 30
VAULT_BASE = os.path.expanduser('~/wingman/vault-sales')
ARCHIVE_SCRIPT = os.path.expanduser('~/wingman/scripts/archive-preview.sh')

today = datetime.date.today()
archived, skipped = [], []

for lead_dir in sorted(os.listdir(VAULT_BASE)):
    lead_path = os.path.join(VAULT_BASE, lead_dir)
    outreach_log = os.path.join(lead_path, 'outreach_log.md')
    preview_url = os.path.join(lead_path, 'preview_url.txt')

    if not os.path.exists(outreach_log) or not os.path.exists(preview_url):
        continue

    with open(outreach_log) as f:
        log_content = f.read()

    if 'archived_at' in log_content:
        continue

    send_date = None
    for line in log_content.splitlines():
        if line.startswith('data:'):
            try:
                send_date = datetime.date.fromisoformat(line.split(':', 1)[1].strip()[:10])
            except Exception:
                pass
            break

    if not send_date:
        skipped.append(lead_dir)
        continue

    age_days = (today - send_date).days
    if age_days >= TTL_DAYS:
        print(f'Archiving {lead_dir} (sent {send_date}, age {age_days}d)')
        result = subprocess.run(['bash', ARCHIVE_SCRIPT, lead_dir, 'ttl_expired'],
                                capture_output=True, text=True)
        archived.append(lead_dir) if result.returncode == 0 else None
        print('  OK' if result.returncode == 0 else f'  ERROR: {result.stderr.strip()}')
    else:
        skipped.append(f'{lead_dir} ({age_days}d/{TTL_DAYS}d)')

print(f'Done. Archived: {len(archived)}, Skipped/Active: {len(skipped)}')

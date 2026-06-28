#!/usr/bin/env python3
"""Sync vault outreach_log status → pipeline CSV.
Scans all vault entries with outreach_log.md status:sent and marks CSV CONTATTATO.
Run after pipeline tasks complete, or as a cron.
"""
import csv, json, os, re, shutil, sys
from datetime import date

VAULT_DIR = os.path.expanduser('~/wingman/vault-sales')
CSV_PATH = os.path.expanduser('~/wingman/pipeline-lead-bergamo.csv')
SKIP_STATUSES = {'CONTATTATO', 'CLIENTE', 'ARCHIVIATO', 'CHIUSO OK', 'CHIUSO KO'}

def get_sent_leads():
    sent = {}
    for entry in os.listdir(VAULT_DIR):
        log = os.path.join(VAULT_DIR, entry, 'outreach_log.md')
        if not os.path.isfile(log):
            continue
        with open(log) as f:
            content = f.read()
        if 'status: sent' not in content:
            continue
        m = re.match(r'lead-(\d+)-', entry)
        if m:
            sent[m.group(1)] = entry
    return sent

def sync():
    sent = get_sent_leads()
    if not sent:
        print('No sent leads found in vault.')
        return

    rows, fieldnames, updated = [], None, []
    with open(CSV_PATH, newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        fieldnames = [fn for fn in reader.fieldnames if fn is not None]
        for row in reader:
            clean = {k: v for k, v in row.items() if k is not None}
            num = clean.get('#', '').strip()
            if num in sent and clean.get('Stato', '').strip() not in SKIP_STATUSES:
                clean['Stato'] = 'CONTATTATO'
                if not clean.get('Data 1 Contatto', '').strip():
                    clean['Data 1 Contatto'] = date.today().strftime('%d/%m/%Y')
                updated.append(num)
            rows.append(clean)

    if not updated:
        print('CSV already in sync.')
        return

    tmp = CSV_PATH + '.tmp'
    with open(tmp, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction='ignore')
        writer.writeheader()
        writer.writerows(rows)
    shutil.move(tmp, CSV_PATH)
    print(json.dumps({'synced': updated, 'date': date.today().isoformat()}))

if __name__ == '__main__':
    sync()

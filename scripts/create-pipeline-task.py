#!/usr/bin/env python3
"""Create a kanban task for sales-pipeline-runner.
Usage: python3 create-pipeline-task.py --mock-email zio.ted@gmail.com [--lead-id 5]"""
import hashlib, json, os, sqlite3, sys, time

KANBAN_DB = os.path.expanduser('~/.hermes/kanban/boards/sales/kanban.db')

def task_id():
    return 't_' + hashlib.md5(str(time.time()).encode()).hexdigest()[:8]

def main():
    mock_email = lead_num = None
    if '--mock-email' in sys.argv:
        mock_email = sys.argv[sys.argv.index('--mock-email') + 1]
    if '--lead-id' in sys.argv:
        lead_num = sys.argv[sys.argv.index('--lead-id') + 1]

    tid = task_id()
    now = int(time.time())
    lines = ['task_type: preview-site-pipeline']
    if mock_email: lines.append(f'mock_email: {mock_email}')
    if lead_num:   lines.append(f'lead_num: {lead_num}')
    lines += ['', 'Avvia pipeline lead gen completa:', '1. pick lead DA CONTATTARE',
              '2. scraping GMaps + IG + PG + sito', '3. template injection + LLM copy',
              '4. deploy GitHub Pages preview', '5. hookmail a mock_email']
    body = '\n'.join(lines)

    db = sqlite3.connect(KANBAN_DB)
    db.execute(
        'INSERT INTO tasks (id,title,body,assignee,status,priority,created_at,'
        'workspace_kind,consecutive_failures,goal_mode,model_override,max_runtime_seconds) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        (tid, 'Lead pipeline: preview + hookmail', body,
         'sales-pipeline-runner', 'todo', 0, now, 'scratch', 0, 1,
         'deepseek-v4-flash-free', 1800)
    )
    db.commit(); db.close()

    print(json.dumps({'task_id': tid, 'assignee': 'sales-pipeline-runner',
                      'mock_email': mock_email, 'lead_num': lead_num,
                      'message': 'Task created. Dispatcher picks up within 60s.'}, indent=2))

if __name__ == '__main__': main()

import os, datetime
now = datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
content = (
    "data: " + now + "\n"
    "canale: email (gws gmail)\n"
    "to: " + os.environ["TO"] + "\n"
    "mock: " + (os.environ["MOCK_EMAIL"] or "no") + "\n"
    "message_id: " + os.environ["MSG_ID"] + "\n"
    "preview_url: " + (os.environ["PREVIEW_URL"] or "none") + "\n"
    "status: sent\n"
)
with open(os.environ["OUTREACH_LOG"], "w") as f:
    f.write(content)

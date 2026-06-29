import sys, smtplib, uuid
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

to, subject, body_html, smtp_server, smtp_port, login, key, from_addr, from_name = sys.argv[1:10]

msg = MIMEMultipart("alternative")
msg["From"] = f"{from_name} <{from_addr}>"
msg["To"] = to
msg["Subject"] = subject
msg["Message-ID"] = f"<{uuid.uuid4()}@coreflux.studio>"
msg.attach(MIMEText(body_html, "html", "utf-8"))

with smtplib.SMTP(smtp_server, int(smtp_port)) as s:
    s.starttls()
    s.login(login, key)
    s.sendmail(from_addr, to, msg.as_string())

# Return fake id for log (Brevo doesn't return message id via SMTP)
print(f"brevo-{uuid.uuid4().hex[:16]}")

#!/usr/bin/env python

import smtplib
from email.mime.text import MIMEText

sender = 'hamid.najafi@legace.ir'
receiver = 'info@example.com'

msg = MIMEText('This is test mail')

msg['Subject'] = 'Test mail'
msg['From'] = 'hamid.najafi@legace.ir'
msg['To'] = 'info@example.com'

user = 'hamid.najafi@legace.ir'
password = 'Mailpass.24'

with smtplib.SMTP('mail.legace.ir', 25) as server:

    server.login(user, password)
    server.sendmail(sender, receiver, msg.as_string())
    print("mail successfully sent")

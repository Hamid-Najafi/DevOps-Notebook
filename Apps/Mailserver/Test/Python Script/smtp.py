#!/usr/bin/env python

import smtplib
from email.mime.text import MIMEText

sender = 'sales@vir-gol.ir'
receiver = 'sales@vir-gol.ir'

msg = MIMEText('This is test mail')

msg['Subject'] = 'Test mail'
msg['From'] = 'sales@vir-gol.ir'
msg['To'] = 'sales@vir-gol.ir'

user = 'sales@vir-gol.ir'
password = 'Mailpass.2476'

with smtplib.SMTP('mail.vir-gol.ir', 25) as server:

    server.login(user, password)
    server.sendmail(sender, receiver, msg.as_string())
    print("mail successfully sent")

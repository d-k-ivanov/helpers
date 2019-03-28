#!/usr/bin/env python
# -*- coding: utf-8 -*-

import dns.resolver
import mimetypes
import os
import re
import smtplib

from email.message import EmailMessage
from sql_reports.config import CONFIG


def is_validated_email_address(email):
    EMAIL_REGEX = re.compile(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
    if EMAIL_REGEX.match(email):
        return True
    else:
        return False


def is_email_exist(email):
    ''' This function not wokring for most of servers. So it just for information '''
    # Set addres from which check recipient
    fromAddress = CONFIG['email_error']

    # Get domain name
    domain = email.split('@')[1]

    # DNS MX records
    records = dns.resolver.query(domain, 'MX')
    mxRecord = records[0].exchange
    mxRecord = str(mxRecord)

    # SMTP session
    s = smtplib.SMTP()
    # s.set_debuglevel(True)
    s.connect(mxRecord)
    s.helo(s.local_hostname)
    s.mail(fromAddress)
    code, message = s.rcpt(email)
    s.quit()

    if code == 250:
        return True
    else:
        return False


def send_message(message: dict, email_to):
    ''' Send E-mail '''
    # Check email address:
    if not is_validated_email_address(email_to):
        broken_email_address = email_to
        email_to = CONFIG['email_error']
        message['body'] = (message['body'] + "\n\nError in target email address: " + broken_email_address)

    msg = EmailMessage()
    msg.set_content(message['body'])
    msg['Subject'] = message['subj']
    msg['From'] = CONFIG['email_from']
    msg['To'] = email_to

    if message['path'] and os.path.isfile(message['path']):
        ctype, encoding = mimetypes.guess_type(message['path'])
        if ctype is None or encoding is not None:
            ctype = 'application/octet-stream'
        maintype, subtype = ctype.split('/', 1)

        with open(message['path'], 'rb') as fp:
            msg.add_attachment(fp.read(),
                               maintype=maintype,
                               subtype=subtype,
                               filename=os.path.basename(message['path']))

    s = smtplib.SMTP(CONFIG['email_smtp_server'], CONFIG['email_smtp_port'])
    # s.set_debuglevel(True)
    s.ehlo()
    s.starttls()
    s.ehlo()
    s.login(CONFIG['email_user'], CONFIG['email_pass'])
    s.send_message(msg)
    s.quit()

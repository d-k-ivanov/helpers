#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import smtplib
from email.message import EmailMessage

from git_cleaner.config import CONFIG


def is_validated_email_address(email):
    EMAIL_REGEX = re.compile(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
    if EMAIL_REGEX.match(email):
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

    s = smtplib.SMTP(CONFIG['email_smtp_server'], CONFIG['email_smtp_port'])
    # s.set_debuglevel(True)
    s.ehlo()
    s.starttls()
    s.ehlo()
    s.login(CONFIG['email_user'], CONFIG['email_pass'])
    s.send_message(msg)
    s.quit()

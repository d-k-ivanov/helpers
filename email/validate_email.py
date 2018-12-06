#!/usr/bin/env python
# -*- coding: utf-8 -*-
import dns.resolver
import re
import smtplib
import sys
from email.message import EmailMessage

def is_email_exist(email):
    # Set addres from which check recipient
    fromAddress = 'd.k.ivanov@live.com'

    # Get domain name
    domain = str(email.split('@')[1])

    # DNS MX records
    records = dns.resolver.query(domain, 'MX')
    mxRecord = records[0].exchange
    mxRecord = str(mxRecord)

    # SMTP session
    s = smtplib.SMTP(timeout=10)
    s.set_debuglevel(True)
    s.connect(mxRecord)
    s.helo(s.local_hostname)
    s.mail(fromAddress)
    code, message = s.rcpt(email)
    s.quit()

    if code == 250:
        return True
    else:
        return False

if __name__ == "__main__":
    import argparse
    # Options
    parser = argparse.ArgumentParser(description='Check email address exist on remote server', formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument("-e", dest="email", help="Database name", metavar="DATABASE_NAME")
    args = parser.parse_args()

    if not args.email:
        print("Check email address exist on remote server")
        print(" Usage:")
        print("\t" + str(__file__) + " -e email_address")
        sys.exit(1)

    if is_email_exist(args.email):
        print('Address {} is exit on remote server')
    else:
        print('Address {} is exit on remote server')

    sys.exit(0)

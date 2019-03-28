#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import uuid

CONFIG = dict(
    db_url='',
    db_name='',
    db_user='',
    db_password='',
    email_from='',
    email_to='',
    email_smtp_server='',
    email_smtp_port='',
    email_user='',
    email_pass='',
    email_error='',
)


def load_base_config():
    ''' Define initial config '''
    for key in CONFIG.keys():
        if key.upper() in os.environ:
            CONFIG[key.lower()] = os.getenv(key.upper())
        else:
            print("ERROR: You need to set {} as environment variable or .env entry".format(key.upper()))
            exit(1)


def load_runtime_config():
    CONFIG['session_id'] = str(uuid.uuid4())

#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import uuid

CONFIG = dict(
    git_provider='',
    git_user='',
    git_repo_name='',
    email_from='',
    email_smtp_server='',
    email_smtp_port='',
    email_user='',
    email_pass='',
    email_error='',
    oauth_client_id='',
    oauth_client_secret='',
    oauth_uri_access_token='',
    oauth_uri_authorization='',
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
    from git_cleaner.oauth import get_oauth_token
    from git_cleaner.branches import protected_branches

    CONFIG['session_id'] = str(uuid.uuid4())
    CONFIG['oauth_token'] = get_oauth_token()
    CONFIG['protected_branches'] = protected_branches()

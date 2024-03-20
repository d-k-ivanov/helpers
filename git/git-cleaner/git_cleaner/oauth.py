#!/usr/bin/env python
# -*- coding: utf-8 -*-

from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session

from git_cleaner.config import CONFIG


def get_oauth_token():
    ''' Get OAUTH token from OAUTH provider '''
    access_token_url = CONFIG['oauth_uri_access_token']
    client_id = CONFIG['oauth_client_id']
    client_secret = CONFIG['oauth_client_secret']
    client = BackendApplicationClient(client_id=client_id)
    oauth = OAuth2Session(client=client)
    token = oauth.fetch_token(
            token_url=access_token_url,
            client_id=client_id,
            client_secret=client_secret)
    return token['access_token']

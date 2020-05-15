#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import json
import uuid
import oauth
import dotenv
import requests

from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session


CONFIG = dict(
    git_provider='',
    git_user='',
    git_repo_name='',
    oauth_client_id='',
    oauth_client_secret='',
    oauth_uri_access_token='',
    oauth_uri_authorization=''
)


def load_base_config():
    ''' Define initial config '''
    for key in CONFIG.keys():
        if key.upper() in os.environ:
            CONFIG[key.lower()] = os.getenv(key.upper())
        else:
            print("ERROR: You need to set {} as environment variable or .env entry".format(key.upper()))
            exit(1)


def load_oauth_token():
    # Get OAUTH token from OAUTH provider
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


def load_runtime_config():
    CONFIG['session_id'] = str(uuid.uuid4())
    CONFIG['oauth_token'] = get_oauth_token()
    CONFIG['branch'] = "fix/TKT-100-automatic-pr"


def create_pull_request():
    if CONFIG['git_provider'] == 'bitbucket.org':
        headers = {'Authorization': 'Bearer ' +
                   CONFIG['oauth_token'], 'Content-Type': 'application/json'}
        url = (
            "https://api."
            + CONFIG['git_provider']
            + "/2.0/repositories/"
            + CONFIG['git_user']
            + "/" + CONFIG['git_repo_name']
            + "/pullrequests")

        data = {
            "title": "Automatic PR",
            "description": "Automatic PR",
            "source": {
                "branch": {
                    "name": + CONFIG['branch'] +
                }
            },
            "close_source_branch": "True",
            "reviewers": [{}],
            "destination": {
                "branch": {
                    "name": "master"
                }
            }
        }

        req = requests.post(url, headers=headers, data=json.dumps(data))
    return req


def main():
    # Read .env file
    dotenv.load_dotenv(dotenv.find_dotenv())

    load_base_config()
    load_runtime_config()

    # Create pull request
    req = create_pr()
    if req.status_code == 201:
        print("PR was successfully created")
    else:
        print("PR creation operation failed with status code: ", req.status_code)
        print(req.content)


if __name__ == '__main__':
    main()

#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import json
import uuid
import click
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
    oauth_uri_authorization='',
)

members = set()


def load_base_config():
    ''' Define initial config '''
    for key in CONFIG.keys():
        if key.upper() in os.environ:
            CONFIG[key.lower()] = os.getenv(key.upper())
        else:
            print("ERROR: You need to set {} as environment variable or .env entry".format(key.upper()))
            exit(1)

    CONFIG['session_id'] = str(uuid.uuid4())
    CONFIG['oauth_token'] = get_oauth_token()


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


def generate_members():
    ''' Generate set of members '''
    headers = {'Authorization': 'Bearer ' + CONFIG['oauth_token']}
    url = (
        "https://api."
        + CONFIG['git_provider']
        + "/2.0/users/"
        + CONFIG['git_user']
        + "/members")

    while url:
        r = requests.get(url, headers=headers)
        content = json.loads(r.content.decode())
        if 'next' in content:
            url = content['next']
        else:
            url = None

        for member in content['values']:
            members.add(member['username'])

    print('List of members initialized')


@click.group()
@click.help_option('-h', '--help')
def cli():
    dotenv.load_dotenv(dotenv.find_dotenv())
    load_base_config()
    generate_members()


@cli.command('list-members')
def list_members():
    ''' List all members of organization '''
    for member in members:
        print(member)


@cli.command('list-emails')
def list_emails():
    ''' Return list of token owner emails '''
    headers = {'Authorization': 'Bearer ' + CONFIG['oauth_token']}
    url = (
        "https://api."
        + CONFIG['git_provider']
        + "/2.0/user/emails")

    r = requests.get(url, headers=headers)
    content = json.loads(r.content.decode())
    print(content)


if __name__ == "__main__":
    cli()
    sys.exit(0)

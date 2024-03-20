#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
# import logging
import markdown
import requests
# import http.client as http_client
from html.parser import HTMLParser

from git_cleaner.config import CONFIG


class WikiMarkdownParser(HTMLParser):
    protected_branches = []
    in_raw = False
    in_cell = False

    def handle_starttag(self, tag, attrs):
        if tag == 'tr':
            self.in_raw = True
        if tag == 'td':
            self.in_cell = True

    def handle_endtag(self, tag):
        if tag == 'td':
            self.in_raw = False
            self.in_cell = False

    def handle_data(self, data):
        if self.in_cell and self.in_raw:
            self.protected_branches.append(data)

    def get_protected_branches(self):
        return self.protected_branches


def protected_branches() -> list:
    ''' Returns list of protected branches '''
    # http_client.HTTPConnection.debuglevel = 1

    # You must initialize logging, otherwise you'll not see debug output.
    # logging.basicConfig()
    # logging.getLogger().setLevel(logging.DEBUG)
    # requests_log = logging.getLogger("requests.packages.urllib3")
    # requests_log.setLevel(logging.DEBUG)
    # requests_log.propagate = True

    if CONFIG['git_provider'] == 'bitbucket.org':
        headers = {'Authorization': 'Bearer ' + CONFIG['oauth_token']}
        url = (
            "https://api."
            + CONFIG['git_provider']
            + "/1.0/repositories/"
            + CONFIG['git_user']
            + "/"
            + CONFIG['git_repo_name']
            + "/wiki/Protected_branches")

        r = requests.get(url, headers=headers)
        content = json.loads(r.content.decode())

        md = markdown.markdown(
            content['data'],
            encoding="utf-8",
            extensions=['markdown.extensions.tables']
        )

        parser = WikiMarkdownParser()
        parser.feed(md)

        return parser.get_protected_branches()

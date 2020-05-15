#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This is AWS Lambda function to trigger ${url}
"""
from datetime import datetime
from urllib.request import urlopen, Request


def lambda_handler(event, context):
    req = Request('${url}')
    req.add_header('Referer', '${url}')
    req.add_header('User-Agent', 'Mozilla/5.0')
    now = datetime.now()
    with urlopen(req) as site:
        print("{}: ${url} triggered. Status: {}".format(now, site.status))

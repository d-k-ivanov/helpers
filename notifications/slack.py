#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests


def send_message_to_slack(message, color="#2eb886"):
    url = "https://hooks.slack.com/services/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    data = {"username": "Bot",
            "pretext": "",
            "text": f"_Bot:_\n {message}",
            "color": color}
    req = requests.post(url, json=data)
    return req


if __name__ == '__main__':
    req = send_message_to_slack("Hello, World!")
    if req.status_code == 200:
        print("Message sent")
    else:
        print("Operation failed with status code: ", req.status_code)
        print(req.content)

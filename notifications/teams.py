#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests


def send_message_to_teams(message, color="#2eb886"):
    url = "https://outlook.office.com/webhook/XXXXXXXXXXXXXXXXXXXX/IncomingWebhook/XXXXXXXXXXXXXXXXXXXXXXXXX"
    data = {"username": "Bot",
            "text": f"<h1>Bot:</h1>\n\n {message}",
            "themeColor": color}
    req = requests.post(url, json=data)
    return req


if __name__ == '__main__':
    req = send_message_to_teams("Hello, World!")
    if req.status_code == 200:
        print("Message sent")
    else:
        print("Operation failed with status code: ", req.status_code)
        print(req.content)

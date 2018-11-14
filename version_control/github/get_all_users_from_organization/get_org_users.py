#!/usr/bin/env python
# -*- coding: utf-8 -*-

global username
global password

import sys

from argparse import ArgumentParser
from github import Github, Organization
import getpass

try:
    import secrets
except ImportError:
    class secrets:
        username = None
        password = None
    print('File secret.py not found Processing arguments...')



def main():
    parser = ArgumentParser(description='Get all usernames from Particular GH organisation')
    parser.add_argument('-o', dest='organization', help='The GH organization name', metavar='organization')
    parser.add_argument('-u', dest='username', help='The GH username', metavar='username', default=None)
    parser.add_argument('-p', dest='password', help='The GH password', metavar='password', default=None)
    args = parser.parse_args()

    username = secrets.username
    password = secrets.password

    if username and password:
        pass
    elif args.username and args.password:
        username = args.username
        password = args.password
    else:
        print('It seemed that you don\'t any valid credentials')
        username = input("Enter GitHub username: ")
        password = getpass.getpass("Enter GitHub password: ")

    if not args.organization:
        parser.print_help()
        sys.exit(1)

    gh = Github(username, password)
    count = 0
    with open("output.txt", "a") as output:
        for user in gh.get_organization(args.organization).get_members():
            output.write(user.login + '\n')
            count += 1
    print('Total users: {:d}'.format(count))

    return 0


if __name__ == '__main__':
    result = main()
    sys.exit(result)

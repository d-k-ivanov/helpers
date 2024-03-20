#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import pytz
import atexit
import shutil
import tempfile
import threading
import subprocess

from datetime import datetime, timedelta

import git_cleaner.filters
import git_cleaner.formats
from git_cleaner.notifications import send_message
from git_cleaner.config import CONFIG


def construct_repo_url(token, provider, user, repo):
    ''' Construct repo URL with OAUTH token authorization '''
    fmt = 'https://x-token-auth:{0}@{1}/{2}/{3}.git'
    return fmt.format(token, provider, user, repo)


def cleanup_repo(path):
    ''' Remove downloaded repository from temporary folder '''
    print('Cleaning up cloned repo: {}'.format(path))
    os.chdir(tempfile.gettempdir())
    shutil.rmtree(path)


def get_target_repo():
    ''' Clone target repo and return destination folder '''
    repo_url = construct_repo_url(
                CONFIG['oauth_token'],
                CONFIG['git_provider'],
                CONFIG['git_user'],
                CONFIG['git_repo_name'])
    temp_dir = tempfile.gettempdir()
    dst = os.path.join(temp_dir, CONFIG['session_id'])
    # Development version:
    # dst = os.path.join(temp_dir, '_' + CONFIG['git_repo_name'])

    if not os.path.exists(dst):
        subprocess.run(['git', 'clone', repo_url, dst])
        atexit.register(cleanup_repo, dst)

    return dst


def get_branch_list(target, git_filter='--merged'):
    ''' Branch list '''
    result_list = list()
    os.chdir(get_target_repo())
    result = subprocess.run(['git', 'branch', '-a', git_filter, target], stdout=subprocess.PIPE, encoding='utf-8')
    for line in result.stdout.splitlines():
        if git_cleaner.filters.is_remote(line.strip()) and not git_cleaner.filters.is_protected(line.strip()):
            result_list.append(line.strip())
    return result_list


def get_git_data_runner(branch, dest_dict: dict):
    output = subprocess.run(
        ['git', 'log', '-1', '--no-merges', '--first-parent', '--format=%ci;%aN;%aE', branch],
        stdout=subprocess.PIPE, encoding='utf-8')
    last_commit_date, last_commit_name, last_commit_email = output.stdout.strip().split(';')
    dest_dict[branch] = (last_commit_date, last_commit_name, last_commit_email)


def get_branches(target, merged=True):
    ''' Get dict of branches: {branch: (date, name, email)} '''
    if merged:
        branches = get_branch_list(target, git_filter='--merged')
    else:
        branches = get_branch_list(target, git_filter='--no-merged')
    os.chdir(get_target_repo())
    dest_dict = dict()

    for branch in branches:
        threading.Thread(target=get_git_data_runner, args=(branch, dest_dict)).start()
    while threading.active_count() > 1:
        pass

    return dest_dict


def list_branches(target='master', age=0, merged=True):
    ''' List branches to stdout '''
    fmt_header = git_cleaner.formats.fmt_list_header
    fmt_body = git_cleaner.formats.fmt_list_body

    now = datetime.utcnow().replace(tzinfo=pytz.utc)
    delta = timedelta(age)
    branches = get_branches(target, merged)
    print(fmt_header.format('Repository', 'Date'))
    for branch, git_data in branches.items():
        date = datetime.strptime(git_data[0], "%Y-%m-%d %X %z")
        if date < (now - delta):
            print(fmt_body.format(branch[15:], date, git_data[2]))


def notify_developers(target='master', age=180, merged=True):
    '''  Notify developers about outdated branches '''
    fmt_message = git_cleaner.formats.fmt_notification_message
    url = ("https://" + CONFIG['git_provider'] + "/" + CONFIG['git_user'] + "/" + CONFIG['git_repo_name'])

    now = datetime.utcnow().replace(tzinfo=pytz.utc)
    delta = timedelta(age)
    branches = get_branches(target, merged)

    message = {}

    for branch, git_data in branches.items():
        date = datetime.strptime(git_data[0], "%Y-%m-%d %X %z")
        if date < (now - delta):
            message['subj'] = '[Git-Cleaner] Your branch is out of date'
            message['body'] = fmt_message.format(
                name=git_data[1],
                branch=branch[15:],
                date=date,
                merged=merged,
                repo=CONFIG['git_repo_name'],
                url=url + "/wiki/Protected_branches",
                url_branch=url + "/branch/" + branch[15:]
            )
            send_message(message, git_data[2])


def remove_branches(target='master', age=180, merged=True):
    ''' Remove outdated branches and notify last committer '''
    fmt_message = git_cleaner.formats.fmt_delete_message
    url = ("https://" + CONFIG['git_provider'] + "/" + CONFIG['git_user'] + "/" + CONFIG['git_repo_name'])

    now = datetime.utcnow().replace(tzinfo=pytz.utc)
    delta = timedelta(age)
    branches = get_branches(target, merged)

    message = {}

    for branch, git_data in branches.items():
        date = datetime.strptime(git_data[0], "%Y-%m-%d %X %z")
        if date < (now - delta):
            delete_branch(branch)
            message['subj'] = '[Git-Cleaner] Outdated branch was removed from bitbucket'
            message['body'] = fmt_message.format(
                name=git_data[1],
                branch=branch[15:],
                date=date,
                merged=merged,
                repo=CONFIG['git_repo_name'],
                url=url + "/wiki/Protected_branches",
                url_branch=url + "/branch/" + branch[15:]
            )
            send_message(message, git_data[2])


def delete_branch(branch):
    ''' Delete branch '''
    subprocess.run(
        ['git', 'push', 'origin', '--delete', branch[15:]],
        stdout=subprocess.PIPE, encoding='utf-8')
    message = {}
    message['subj'] = '[Git-Cleaner] Outdated branch was removed from bitbucket'
    message['body'] = '[deleted] ' + branch
    send_message(message, CONFIG['email_error'])

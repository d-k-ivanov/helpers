#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import click
import threading
import subprocess


@click.group()
@click.help_option('-h', '--help')
def cli():
    pass


@cli.command('list')
@click.help_option('-h', '--help')
@click.argument('path', type=click.Path(exists=True))
@click.argument('author')
@click.option('--merged/--no-merged', default=True, help='Merged or not merged branches')
def main(path, author, merged):
    ''' Get list of branches with certain author of last commit '''
    os.chdir(path)
    if merged:
        branches = get_branch_list(git_filter='--merged')
    else:
        branches = get_branch_list(git_filter='--no-merged')

    dest_dict = dict()
    for branch in branches:
        threading.Thread(target=get_git_data_runner, args=(branch, dest_dict)).start()

    while threading.active_count() > 1:
        pass

    fmt_list = '| {:70} | {:35} |'
    print(fmt_list.format('Repository', 'Email'))
    for branch, email in dest_dict.items():
        if email == author:
            print(fmt_list.format(branch, email))


def get_branch_list(git_filter='--merged'):
    ''' Branch list '''
    result_list = list()
    result = subprocess.run(['git', 'branch', '-a', git_filter, 'master'], stdout=subprocess.PIPE, encoding='utf-8')
    for branch in result.stdout.split('\n'):
        if branch.strip().startswith('remotes/origin') and 'origin/master' not in branch and 'origin/HEAD' not in branch:
            result_list.append(branch.strip())
    return result_list


def get_git_data_runner(branch, dest_dict: dict):
    last_commit_email = subprocess.run(
        ['git', 'log', '-1', '--format=%aE', branch],
        stdout=subprocess.PIPE, encoding='utf-8')
    dest_dict[branch] = last_commit_email.stdout.strip()


if __name__ == '__main__':
    cli()

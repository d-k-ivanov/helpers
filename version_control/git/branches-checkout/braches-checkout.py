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


@cli.command('checkout')
@click.help_option('-h', '--help')
@click.argument('repo_path', type=click.Path(exists=True))
@click.option('--merged/--no-merged', default=True, help='Merged or not merged branches')
def main(repo_path, merged):
    ''' Checkout merged or not merged branches for repo_path'''
    os.chdir(repo_path)
    if merged:
        branches = get_branch_list(git_filter='--merged')
    else:
        branches = get_branch_list(git_filter='--no-merged')

    for branch in branches:
        subprocess.run(['git', 'checkout', branch[15:]], stdout=subprocess.PIPE, encoding='utf-8')

    while threading.active_count() > 1:
        pass

    print("Done!")


def get_branch_list(git_filter='--merged'):
    ''' Branch list '''
    result_list = list()
    result = subprocess.run(['git', 'branch', '-a', git_filter, 'master'], stdout=subprocess.PIPE, encoding='utf-8')
    for branch in result.stdout.split('\n'):
        if branch.strip().startswith('remotes/origin') and 'origin/master' not in branch and 'origin/HEAD' not in branch:
            result_list.append(branch.strip())
    return result_list


if __name__ == '__main__':
    cli()

#!/usr/bin/env python
# -*- coding: utf-8 -*-

import click
import dotenv

import git_cleaner.git
import git_cleaner.formats
from git_cleaner.__version__ import __version__
from git_cleaner.config import CONFIG, load_base_config, load_runtime_config


@click.group()
@click.help_option('-h', '--help')
@click.version_option(__version__, '-v', '--version', message='%(prog)s %(version)s')
def cli():
    dotenv.load_dotenv(dotenv.find_dotenv())
    load_base_config()
    load_runtime_config()


@cli.command('show-config')
def cli_show_config():
    ''' Print config entries '''
    fmt_config = git_cleaner.formats.fmt_config
    print("Config entries:")
    for key, value in CONFIG.items():
        print(fmt_config.format(key, value))


# ---------------------- Listing ---------------------
@cli.command('list-merged')
@click.help_option('-h', '--help')
@click.option('--target', default='master', help='Name of merge branch')
@click.option('--age', default=0, help='Age of nearest branch')
def cli_list_merged_dates(target, age):
    ''' Print list of merged branches with dates '''
    git_cleaner.git.list_branches(target=target, age=age)


@cli.command('list-no-merged')
@click.help_option('-h', '--help')
@click.option('--target', default='master', help='Name of merge branch')
@click.option('--age', default=0, help='Age of nearest branch')
def cli_list_no_merged_dates(target, age):
    ''' Print list of not merged branches with dates '''
    git_cleaner.git.list_branches(target=target, age=age, merged=False)


# ---------------------- Actions ---------------------
@cli.command('notify-last-committer')
@click.help_option('-h', '--help')
@click.option('--target', default='master', help='Name of merge branch')
@click.option('--age', default=180, help='Age of nearest branch')
@click.option('--merged/--no-merged', default=True, help='Merged or not merged branches')
def cli_notify_last_committer(target, age, merged):
    ''' Notify developers about outdated branches '''
    git_cleaner.git.notify_developers(target=target, age=age, merged=merged)


@cli.command('remove-outdated-branches')
@click.help_option('-h', '--help')
@click.option('--target', default='master', help='Name of merge branch')
@click.option('--age', default=180, help='Age of nearest branch')
@click.option('--merged/--no-merged', default=True, help='Merged or not merged branches')
def cli_remove_outdated_branches(target, age, merged):
    ''' Delete outdated branches '''
    git_cleaner.git.remove_branches(target=target, age=age, merged=merged)


# ---------------------- Tests -----------------------
@cli.command('test')
def cli_test():
    ''' Test command for developers '''
    pass


# ---------------------- MAIN ------------------------
def main():
    cli()

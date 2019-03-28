#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import click
import dotenv

import sql_reports.reports
import sql_reports.formats
from sql_reports.__version__ import __version__
from sql_reports.config import CONFIG, load_base_config, load_runtime_config


@click.group()
@click.help_option('-h', '--help')
@click.version_option(__version__, '-v', '--version', message='%(prog)s %(version)s')
def cli():
    if os.path.isfile("/app/.env"):
        dotenv.load_dotenv(dotenv_path="/app/.env")
    else:
        dotenv.load_dotenv(dotenv.find_dotenv())
    load_base_config()
    load_runtime_config()


@cli.command('show-config')
def cli_show_config():
    ''' Print config entries '''
    fmt_config = sql_reports.formats.fmt_config
    print("Config entries:")
    for key, value in CONFIG.items():
        print(fmt_config.format(key, value))


# ---------------------- Listing ---------------------
@cli.command('lead-time-report')
@click.help_option('-h', '--help')
def lead_time_report():
    ''' Export SQL Report '''
    sql_reports.reports.sql_report()


# ---------------------- Tests -----------------------
@cli.command('test')
def cli_test():
    ''' Test command for developers '''
    pass


# ---------------------- MAIN ------------------------
def main():
    cli()

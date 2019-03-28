#!/usr/bin/env python
# -*- coding: utf-8 -*-

import atexit
import mysql.connector
import os
import pandas
import pytz
import shutil
import tempfile

from datetime import datetime

from sql_reports.formats import lead_time_report_message
from sql_reports.notifications import send_message
from sql_reports.config import CONFIG


def sql_report():
    now = datetime.utcnow().replace(tzinfo=pytz.utc)
    date = now.astimezone(pytz.timezone('US/Pacific'))
    date_format = '%Y-%m-%d'
    report_title = 'LeadTime ' + date.strftime(date_format)

    db_config = {
        'user': CONFIG['db_user'],
        'password': CONFIG['db_password'],
        'host': CONFIG['db_url'],
        'database': CONFIG['db_name'],
        'raise_on_warnings': True
    }

    query = ("""
    SELECT
        *
    FROM
        users u
    GROUP BY
        u.user_id
    ORDER BY
        user_id DESC;
    """)

    temp_dir = tempfile.gettempdir()
    report_path = os.path.join(temp_dir, CONFIG['session_id'])
    report_file = os.path.join(report_path, 'sql_report.xlsx')
    if not os.path.isdir(report_path):
        os.mkdir(report_path)
        atexit.register(shutil.rmtree, report_path)

    connection = mysql.connector.connect(**db_config)

    df = pandas.read_sql_query(query, connection)
    df.replace([None], 'Null', inplace=True)
    with pandas.ExcelWriter(report_file, engine='xlsxwriter') as writer:
        df.to_excel(writer, sheet_name=report_title, index=False)
        worksheet = writer.sheets[report_title]
        for idx, col in enumerate(df):
            series = df[col]
            max_len = max((
                series.astype(str).map(len).max(),
                len(str(series.name))
                )) + 1
            worksheet.set_column(idx, idx, max_len)

    connection.close()

    message = {}
    message['subj'] = '[sql-reports] ' + report_title
    message['body'] = lead_time_report_message.format(date=date.strftime(date_format))
    message['path'] = report_file
    for recipient in CONFIG['email_to'].split(';'):
        send_message(message, recipient)

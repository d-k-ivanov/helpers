#!/usr/bin/env bash
python -m virtualenv -p python3 ./venv
source ./venv/bin/activate.sh
python s3_downloader.py -f example_data/test1.csv -d /tmp/ -t 100
deactivate


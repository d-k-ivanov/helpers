#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import csv
import time
import hashlib
import secrets
import threading
from boto.s3.connection import S3Connection

def md5Checksum(filePath):
    with open(filePath, 'rb') as fh:
        m = hashlib.md5()
        while True:
            data = fh.read(8192)
            if not data:
                break
            m.update(data)
        return m.hexdigest()


def download(path, bucket, key, dest):
    connToS3 = S3Connection(secrets.aws_access_key_id, secrets.aws_secret_access_key)
    dir = os.path.abspath(dest + path + "/")
    try:
        os.stat(dir)
    except:
        os.makedirs(os.path.abspath(dest + path))
    o_bucket = connToS3.get_bucket(bucket)
    o_keys = o_bucket.get_all_keys(prefix=os.path.splitext(key)[0].strip("/")[:-1])
    if o_keys:
        for i_key in o_keys:
            if os.path.isfile(os.path.join(dir, os.path.basename(i_key.name))):
                md5_hash = md5Checksum(os.path.join(dir, os.path.basename(i_key.name)))
                if md5_hash == str(i_key.etag[1 :-1]):
                    print('Exist: ' + os.path.join(dir, os.path.basename(i_key.name)))
                else:
                    print('Broken, redo: ' + os.path.join(dir, os.path.basename(i_key.name)))
                    os.remove(os.path.join(dir, os.path.basename(i_key.name)))
                    i_key.get_contents_to_filename(os.path.join(dir, os.path.basename(i_key.name)))
                    print('Downloaded: ' + os.path.join(dir, os.path.basename(i_key.name)))
            else:
                i_key.get_contents_to_filename(os.path.join(dir, os.path.basename(i_key.name)))
                print('Downloaded: ' + os.path.join(dir, os.path.basename(i_key.name)))
    return 0


def run(file, dest, threads):
    with open(file, newline='') as o_file:
        csvfile = csv.reader(o_file, delimiter=',', skipinitialspace=True)
        for row in csvfile:
            # Waiting for empty thread
            while threading.active_count() > threads:
                time.sleep(0.1)
            t = threading.Thread(target=download, args=(row[0].strip(), row[1].strip(), row[2].strip(), dest,)).start()
    return 0


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description='Script for downloading files from S3 bucket.')
    parser.add_argument('-f', dest='csv_file', help='CSV file with files to download', metavar='CSV_FILE')
    parser.add_argument('-d', dest='destination', default='.', help='Folder to download', metavar='DESTINATION')
    parser.add_argument('-t', dest='threads', default='1', help='Number of download threads', metavar='THREADS', type=int)
    args = parser.parse_args()

    if not args.csv_file:
        print("Script for downloading files from S3 bucket")
        print("I takes rows from CSV file in format: DEST|BUCKET|FILENAME "
              "and downloads FILENAME to \"path_to_download/DEST\" (./DEST - by default)")
        print(" Usage:")
        print("\t" + str(__file__) + " -f csv_file -d path_to_download -t num_of_threads")
        sys.exit(1)

    result = run(args.csv_file, args.destination, args.threads)

    sys.exit(result)

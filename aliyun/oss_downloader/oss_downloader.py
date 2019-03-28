#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import csv
import sys
import oss2
import time
import hashlib
import secrets
import threading


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
    endpoint = secrets.oss_endpoints[bucket]
    auth = oss2.Auth(secrets.ali_access_key_id, secrets.ali_secret_access_key)

    dir = os.path.abspath(dest + path + "/")
    try:
        os.stat(dir)
    except:
        os.makedirs(os.path.abspath(dest + path))

    o_bucket = oss2.Bucket(auth, endpoint, bucket)
    # index = 0
    for object_info in oss2.ObjectIterator(o_bucket, prefix=os.path.splitext(key)[0].strip("/")[:-1]):
        i_key = object_info.key
        if os.path.isfile(os.path.join(dir, os.path.basename(i_key))):
            # index = index + 1
            md5_hash = md5Checksum(os.path.join(dir, os.path.basename(i_key)))
            # print(
            #     str(index) + " Path: " + os.path.join(dir, os.path.basename(i_key)) + "\n",
            #     str(index) + ' MD5 F: ' + md5_hash.upper() + "\n",
            #     str(index) + ' MD5 K: ' + str(o_bucket.get_object_meta(i_key).etag).upper() + "\n",
            # )
            if md5_hash.upper() == o_bucket.get_object_meta(i_key).etag.upper():
                print('Exist: ' + os.path.join(dir, os.path.basename(i_key)))
            else:
                print('Broken, redo: ' + os.path.join(dir, os.path.basename(i_key)))
                os.remove(os.path.join(dir, os.path.basename(i_key)))
                o_bucket.get_object_to_file(i_key, os.path.join(dir, os.path.basename(i_key)))
                print('Downloaded: ' + os.path.join(dir, os.path.basename(i_key)))
        else:
            o_bucket.get_object_to_file(i_key, os.path.join(dir, os.path.basename(i_key)))
            print('Downloaded: ' + os.path.join(dir, os.path.basename(i_key)))
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
    parser = argparse.ArgumentParser(description='Script for downloading files from Aliyun OSS bucket.')
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

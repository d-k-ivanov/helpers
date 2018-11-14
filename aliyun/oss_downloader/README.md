## Multithreaded script for downloading bunch of files from Aliyun OSS Bucket by mask

1) Prepare your data (see example data folder)
2) Create virtual env or install oss2 package via pip
3) run

```
python oss_downloader.py -f <path_to_your/data/file.csv> -d </path_to_/destination/folder/> -t <Number of Threads>
```

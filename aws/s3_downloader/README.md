## Multithreaded script for downloading bunch of files from AWS S3 by mask

1) Prepare your data (see example data folder) 
2) Create virtual env or install boto package via pip
3) run

```
python s3_downloader.py -f <path_to_your/data/file.csv> -d </path_to_/destination/folder/> -t <Number of Threads>
```

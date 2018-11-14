#!/usr/bin/env powershell
# TBD...

python -m pip install virtualenv
python -m virtualenv -p c:\Python\3.6.3-x64\python.exe .\venv
.\venv\Scripts\Activate.ps1
python -m pip install -r .\requirements.txt

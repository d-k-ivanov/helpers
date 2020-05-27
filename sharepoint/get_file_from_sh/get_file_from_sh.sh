#!/usr/bin/env bash
set -e

python3 -m pip install virtualenv --user
python3 -m virtualenv -p python3 venv
source ./venv/bin/activate
pip install SharePlum==0.5.1
pip install requests==2.23.0
pip install python-dotenv==0.13.0
pip list

get_file_from_sh=$(cat <<EOF
import os
import dotenv
from shareplum import Site
from shareplum import Office365
from shareplum.site import Version

CONFIG = dict(
    sp_user='',
    sp_user_password='',
    sp_root_url='',
    sp_src_path='',
    sp_dst_path='',
    sp_filename='',
    sp_site_name=''
)


def load_base_config():
    ''' Define initial config '''
    for key in CONFIG.keys():
        if key.upper() in os.environ:
            CONFIG[key.lower()] = os.getenv(key.upper())
        else:
            print("ERROR: You need to set {} as environment variable or .env entry".format(key.upper()))
            exit(1)


if __name__ == '__main__':
    dotenv.load_dotenv(dotenv.find_dotenv())
    load_base_config()

    authcookie = Office365(
                    CONFIG['sp_root_url'],
                    username=CONFIG['sp_user'],
                    password=CONFIG['sp_user_password']).get_cookies()

    site = Site(
            CONFIG['sp_root_url'] + '/sites/' + CONFIG['sp_site_name'] + '/',
            version=Version.v2016,
            authcookie=authcookie)

    folder = site.Folder(CONFIG['sp_src_path'])

    with open(CONFIG['sp_dst_path'] + '/' + CONFIG['sp_filename'], 'wb') as f:
        f.write(folder.get_file(CONFIG['sp_filename']))

    site._session.close()

EOF
)

export SP_USER=username@company.com
export SP_USER_PASSWORD=paSSw0rd
export SP_ROOT_URL='https://yourcompany.sharepoint.com'
export SP_SRC_PATH='Shared Documents/General/Test'
export SP_DST_PATH='.'
export SP_SITE_NAME='MyTeam'

export SP_FILENAME="MyFile1.txt"
python -c "${get_file_from_sh}"

export SP_FILENAME="MyFile2.txt"
python -c "${get_file_from_sh}"

deactivate
rm -rf ./venv
ls -la

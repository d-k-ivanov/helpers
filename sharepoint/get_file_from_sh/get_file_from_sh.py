#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import dotenv
from shareplum import Site
from shareplum import Office365
from shareplum.site import Version


# export SP_USER=
# export SP_USER_PASSWORD=
# export SP_ROOT_URL=https://yourcompany.sharepoint.com
# export SP_SRC_PATH=
# export SP_DST_PATH=.
# export SP_FILENAME=
# export SP_SITE_NAME=


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

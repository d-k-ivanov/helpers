/*
* ---------------------------------------------------------------------------
*       Project :  aws-login
*       File    :  utils.cpp
*       Created :  11/11/2018 1:38:50 PM +0300
*       Author  :  Dmitry Ivanov
* ---------------------------------------------------------------------------
*  Copyright (c) 2018 Dmitry Ivanov
*
*  Licensed under the Apache License, Version 2.0 (the "License");
*  you may not use this file except in compliance with the License.
*  You may obtain a copy of the License at
*
*  http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing, software
*  distributed under the License is distributed on an "AS IS" BASIS,
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*  See the License for the specific language governing permissions and
*  limitations under the License.
* ===========================================================================
*/
#include "utils.hpp"
#include <iostream>

std::string get_home_dir() {
    std::string env_list[] = {"USERPROFILE", "HOMEDRIVE", "HOME"};
    char *home_dir;
    for (const std::string &env : env_list) {
        if((home_dir = std::getenv(env.c_str())) != NULL) {
            if(env == "HOMEDRIVE"){
                home_dir = strcat(home_dir,std::getenv("HOMEPATH"));
            }
            return std::string(home_dir);
        }
    }
    return "";
}

/*
* ---------------------------------------------------------------------------
*       Project :  aws-login
*       File    :  ini.cpp
*       Created :  11/11/2018 4:38:01 AM +0300
*       Author  :  Dmitriy Ivanov
*       Company :  Ormco
* ---------------------------------------------------------------------------
*  Copyright (c) 2018 Dmitriy Ivanov
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

#include <cstdlib>
#include <fstream>
#include <filesystem>
#include <iostream>
#include <string>
#include <set>
#include "ini.hpp"

ini::ini(std::string *input_ini_path,
         std::set<std::string> *input_set_of_sections ) {

    ini_file_path = input_ini_path;
    sections = input_set_of_sections;
}

ini::~ini() {}

void ini::parse() {
    static const char ini_section_start = '[';
    static const char ini_section_stop  = ']';
    static const char ini_equal         = '=';
    static const char ini_comment1      = ';';
    static const char ini_comment2      = '#';

    std::string line;
    std::ifstream myfile;
    myfile.open(*ini_file_path);
    if (myfile.is_open()) {
        // int count = 0;
        while(std::getline(myfile,line)) {
            // if(line == "[default]")
                // count++;
            std::cout << line << '\n';
            // if(count == 3)
                // break;
            // if(count > 0)
                // count++;
        }
        myfile.close();
    }


}

void ini::list_sections() {

}

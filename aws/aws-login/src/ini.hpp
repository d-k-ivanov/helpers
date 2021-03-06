/*
* ---------------------------------------------------------------------------
*       Project :  aws-login
*       File    :  ini.hpp
*       Created :  11/11/2018 2:10:56 AM +0300
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
#ifndef INI_HPP
#define INI_HPP

#include <map>
#include <set>
#include <string>

class ini {
    private:
        std::string                         *ini_file_path;
        std::set<std::string>               *sections;

        void parse();
    public:
        ini(std::string *input_init_path,
            std::set<std::string> *input_set_of_sections);
        ~ini();
        void list_sections();
};

#endif //INI_HPP

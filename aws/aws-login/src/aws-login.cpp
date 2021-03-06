/*
* ---------------------------------------------------------------------------
 *      Project :  aws-login
*       File    :  aws-login.cpp
*       Created :  11/4/2018 2:47:30 AM +0300
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

#include <string>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <set>

#include "ini.hpp"
#include "utils.hpp"

int main(int argc, char **argv, char **envp) {
    if(argc != 2) {
        std::cout << "Usage: " << argv[0] << " list\n";
        return 1;
    }
    // Cli::Parse(argc, argv)



    // for (int i(1); i != argc; ++i) {
    //     std::cout << i << "=" << argv[i] << "\n";
    // }

    std::string home_dir = get_home_dir();
    if(home_dir.empty()) {
        std::cerr << "HOME path couldn't be found" << "\n";
        return 1;
    }

    std::cout << home_dir << "\n";
    std::string aws_creds = home_dir + "/.aws/credentials";
    ini aws_config(&aws_creds);
    aws_config.list_sections();

    return 0;

}

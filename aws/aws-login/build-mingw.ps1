#!/usr/bin/env pwsh
${binPath} = (Join-Path $PSScriptRoot "bin")

# Debug :
# g++ --std=c++17 -O3 -o ${binPath}/aws-login.exe src/*.cpp

# Release:
g++ --std=c++17 -s -O3 -DNDEBUG -o ${binPath}/aws-login.exe src/*.cpp

#!/usr/bin/env pwsh
${binPath} = (Join-Path $PSScriptRoot "bin")

# Debug:
# clang --std=c++17 -O3 -g -Xclang -flto-visibility-public-std -o ${binPath}/aws-login.exe src/*.cpp

# Release:
# clang++ --std=c++17 -O3 -DNDEBUG -Xclang -flto-visibility-public-std -o ${binPath}/aws-login.exe src/*.cpp
# clang-cl /nologo /W3 /WX- /diagnostics:classic /O2 /Ob2 /D WIN32 /D _WINDOWS /D NDEBUG /D _MBCS /Gm- /EHsc /MD /GS /fp:precise /Zc:wchar_t /Zc:forScope /Zc:inline /GR /std:c++17  /Gd /TP /FC /errorReport:queue -o ${binPath}/aws-login.exe src/*.cpp
clang-cl /std:c++17 /MD /O2 /DNDEBUG -o ${binPath}/aws-login.exe src/*.cpp

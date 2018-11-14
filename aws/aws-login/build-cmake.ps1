#!/usr/bin/env pwsh
$old_dir = Get-Location
CreateAndSet-Directory build

# cmake ..
# cmake -G "MinGW Makefiles" .. -DCMAKE_C_COMPILER=gcc
# cmake -G "Visual Studio 15 2017" ..
cmake -G "Visual Studio 15 2017 Win64" ..
# cmake -G "Visual Studio 15 2017 Win64" -T "LLVM-vs2014" ..

# cmake --build .
cmake --build . --config "Release"

Set-Location $old_dir
# Remove-Item -Recurse -Force ./build

# Get 7510-WIN10-A12-N2VWJ.cab and unzip. Dell 7510 Driver Pack
cd 7510-WIN10-A12-N2VWJ\7510\win10\x64\
for /f %i in (‘dir /b /s *.inf’) do pnputil.exe -i -a %i
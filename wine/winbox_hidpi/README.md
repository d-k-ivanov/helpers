# winbox wrapper for hidpi screens

## Applications which should be installed

* Xephyr
* x11vnc
* wine
* vncviewer

## Install
sudo ln -s /path/to/winbox-highdpi/winbox /usr/local/bin

## Start 
winbox

## Runtime

Default resolution: 1600x900
To change resolution go inside ./winbox script
It's the best of all to run ./wincfg to set up decorations and wine desktop resolution (which sould be the same as resolution of Xephyr window)







#!/bin/bash
#
#  Script to collect bash history from remote servers
#
echo "Usage: ./collect.sh <ip_base_file>"

read -n 1 -p "Do you want to collect bash_history? (y/[a]): " AMSURE
[ "$AMSURE" = "y" ] || exit
echo "" 1>&2

now=$(date +"%m_%d_%Y")
mkdir ./$now
## Provide BASE64 encoded password here
## echo "MEGA-SECURE-PASSWORD" | base64 -i
PASS=`echo "TUVHQS1TRUNVUkUtUEFTU1dPUkQK" | base64 -di`
awk '{print $1}' < ./"$1" | while read ip; do

expect -c "
	set timeout 1
	spawn scp  root@$ip:~/.bash_history ./"$now"/"$ip"_history.txt
	expect yes/no { send yes\r ; exp_continue }
	expect password: { send $PASS\r }
	expect 100%
	sleep 1
	exit
"
done


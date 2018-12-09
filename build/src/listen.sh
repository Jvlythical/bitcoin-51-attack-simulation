#!/bin/bash

#listening on port 2049, if
#it receive a 'done' msg, then
#it will modify msg file to 
# be done.

port=2049
while true
do
	nc -kl -p $port | while read -n 4
	do
	    if [ $REPLY = 'done' ] 
			then
				echo 'done' > msg
				echo 'msg changed'
	    fi
	done 
done

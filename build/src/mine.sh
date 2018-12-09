#!/bin/bash

#Muwei
#This is the mining script, it
#takes one parameter, '-l' means
#it runs in leader mode; '-p' 
#means it runs in partner mode 
#and needs ip address for leader.

if [ $1 = '-l' ]
then
	echo 'working' > msg
	./listen.sh &
	./leader.sh
fi

if [ $1 = '-p' ]
then 
	./partner.sh $2
fi

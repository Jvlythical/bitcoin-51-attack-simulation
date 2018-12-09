#!/bin/bash

#Muwei
#This script mimics a mining process.
#This is a version for partner in a 
#mining pool.

#Get info from a working block
a='1'
host=$1

#Continuously mine the next block
while true
do
	#check if anyone solve block,
	#if they do, save working block.
	kick=0
	

	#Mining 
	#use working block and a nonce as
	#reference, then calculate sha1 hash.
	#Do it 10,000 times
	msg='abc'
	nounce=1
	#while [ $kick -le 10000  ]
	#	do
			#check if succeed
	#		if [ $(openssl -sh1 $(msg+nounce)) = ''  ]
	#		then
				#send notification to leader
				echo 'done'	> /dev/tcp/$host/2049
				echo 'done'
				#save working block

				#break the loop

			#modify nounce
	# 		fi

	#		kick=$(( kick + 1 )
	#	done
	
	#sleep for 1s 
	#sleep 1
	
	sleep 5

done

#!/bin/bash

#Muwei
#This script mimics a mining process.
#This is a version for leader in a 
#mining pool.

#Get info from a working block
a='1'

kick=0
#Continuously mine the next block
while true
do
	#check if competitors solve block,
	#if they do, save working block.
	

	#check if a partner already solve
	#the puzzle.
	if [ $(cat msg) = 'done' ]
	then
		#generate a new block

		#change msg back to 'working'
		echo 'working' > msg
		echo 'working' >> testmsg
		
		#extract info of the new block
		#and save it as working block
	    kick=0
		echo $a
		a="$a 1"
	fi	

	#Mining 
	#use working block and a nonce as
	#reference, then calculate sha1 hash.
	#Do it 10,000 times
	msg='abc'
	nounce='b'
	while  [ $kick -le 10 ]
		do
			#check if succeed
			hash=$(echo "$msg$nounce$kick" | sha1sum)
			echo $hash
			check=$(echo $hash | cut -b 1-5)
			if [ $check = '415f4'  ]
			then
				#generate a new block
				echo 'get it'
				
				#save working block

				#break the loop
			fi
			#modify nounce

			kick=$(( kick + 1 ))
		done
	
	#sleep for 1s 
	sleep 15

done

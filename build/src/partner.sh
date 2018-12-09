#!/bin/bash

#Muwei
#This script mimics a mining process.
#This is a version for partner in a 
#mining pool.

#define a function to get current block info
getcurrent(){
	block=$(bitcoin-cli -regtest getmininginfo)
	block=$(echo $block | cut -b 3-15)
}

#define a function to initialize a new mining
reset(){
	current=$block
	kick=0
	nounce=$RANDOM
}


#Get ip for leader
host=$1

#Get info from a working block
block="0"
getcurrent
current=$block

#Initialize the counts and nounce
kick=0
nounce=$RANDOM


#Continuously mine the next block
while true
do
	#check if anyone solve block,
	#if they do, save working block.
	getcurrent
	if [ "$current" != "$block" ]
	then
		reset
	fi

	#Mining 
	#use working block and a nonce as
	#reference, then calculate sha1 hash.
	#Do it 10,000 times
	kick=0
	while [ $kick -le 1000  ]
		do
			#check if succeed
			hash=$(echo "$current$nounce$kick" | sha1sum)
			check=$(echo $hash | cut -b 1-3)
			if [ "$check" = "000"  ]
			then
				#send notification to leader
				echo 'done'	> /dev/tcp/${host}/2049
				echo 'partner solved'

				# wait for 3 second for leader to process
				sleep 3
	 		fi

			kick=$(( kick + 1 ))
		done

	#sleep for 1s 
	sleep 1
done

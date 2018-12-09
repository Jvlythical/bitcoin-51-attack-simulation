#!/bin/bash

#Muwei
#This script mimics a mining process.
#This is a version for leader in a 
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
	echo 'working' > msg
}


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
	#check if competitors solve block,
	#if they do, reset the mining
	getcurrent
	if [ "$current" != "$block" ]
	then
		reset
	fi

	#check if a partner already solve
	#the puzzle.
	if [ $(cat msg) = 'done' ]
	then
		#generate a new block
		bitcoin-cli -regtest generate 1
		echo 'partner solved'

		#reset mining
		reset
	fi

	#Mining 
	#use working block and a nonce as
	#reference, then calculate sha1 hash.
	#Do it 10,000 times
	kick=0
	echo "starting to try..."
	while  [ $kick -le 1000 ]
		do
			#check if succeed
			hash=$(echo "$current$nounce$kick" | sha1sum)
			check=$(echo $hash | cut -b 1-3)
			if [ "$check" = "000"  ]
			then
				#generate a new block
				bitcoin-cli -regtest generate 1
				echo "leader solved"

				#reset mining
				reset

				#break the loop
				break
			fi

			#modify nounce
			kick=$(( kick + 1 ))
		done
	
	#sleep for 1s 
	sleep 1

done

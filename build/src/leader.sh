#!/bin/bash

#Muwei
#This script mimics a mining process.
#This is a version for leader in a 
#mining pool.

#define a function to get current block info
getcurrent(){
	block=$(bitcoin-cli getblockcount)
}

#define a function to initialize a new mining
reset(){
	current=$block
	kick=0
	nounce=$RANDOM
	echo 'working' > ~/msg
}


#Get info from a working block
block="0"
getcurrent
current=$block

#Initialize the counts and nounce and difficulty
kick=0
nounce=$RANDOM
level=4
fre=200


#Read user parameter
while getopts ":l:f:" opt; do
    case ${opt} in
        l )
            level=$OPTARG
	    ;;
	f )
	    fre=$OPTARG
	    ;;
	\? )
	    echo "Invalid Option"
	    exit 1
	    ;;
	: )
	    echo "Invalid argument"
	    exit 1
	    ;;
    esac
done
shift $((OPTIND -1))

echo "Mining difficulty level is set to $level."
echo "Mining power is set to sleep 0.5 second every $fre calculation."


#Normalize mining difficulty level
goal=''
i=1
while [ "$i" -le "$level" ]; do
	goal="0$goal"
	i=$((i + 1))
done


#Continuously mine the next block
echo "Start mining as a leader..."
echo ""

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
	if [ $(cat ~/msg) = 'done' ]
	then
		#generate a new block
		bitcoin-cli -regtest generate 1
		echo 'partner solved'
		date

		#reset mining
		reset
		echo ''
	fi

	#Mining 
	#use working block and a nonce as
	#reference, then calculate sha1 hash.
	#Do it 10,000 times
	kick=0
	while  [ $kick -le "$fre" ]
		do
			#check if succeed
			hash=$(echo "$current$nounce$kick" | sha1sum)
			check=$(echo $hash | cut -b 1-"$level")

			
			if [ "$check" == "$goal"  ]
			then
				#check if already been solved
				getcurrent
				if [ "$current" != "$block" ];then
					reset
					break
				fi

				#generate a new block
				bitcoin-cli -regtest generate 1
				echo "leader solved"
				date

				#reset mining
				reset
				echo ''

				#break the loop
				break
			fi

			#modify nounce
			kick=$(( kick + 1 ))
		done
	nounce="1$nounce"
	
	#sleep for 0.5s 
	sleep 0.5

done

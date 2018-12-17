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


#Initialize the counts and nounce
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


#Get ip for leader
host=$1


#Get info from a working block
block="0"
getcurrent
current=$block


#Continuously mine the next block
echo "Start mining as a partner of host $host"
echo ""
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
	while [ "$kick" -le "$fre"  ]
		do
			#check if succeed
			hash=$(echo "$current$nounce$kick" | sha1sum)
			check=$(echo $hash | cut -b 1-"$level")
			if [ "$check" == "$goal"  ]
			then
				#check if it is already been solved
				getcurrent
				if [ "$current" != "$block" ];then
					reset
					break
				fi

				#send notification to leader
				echo 'done'	> /dev/tcp/${host}/2049
				echo 'partner solved'
				date

				# wait for 3 second for leader to process
				sleep 3
				break
	 		fi

			kick=$(( kick + 1 ))
		done
	nounce="1$nounce"

	#sleep for 0.5s 
	sleep 0.5
done

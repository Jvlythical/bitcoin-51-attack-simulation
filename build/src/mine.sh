#!/bin/bash

#Muwei
#This is the mining script, it
#takes one parameter, '-l' means
#it runs in leader mode; '-p' 
#means it runs in partner mode 
#and needs ip address for leader.

#Initialize parameter
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


case "$1" in
	"leader" ) #node work in leader mode
		echo 'working' > ~/msg
		/sbin/bitcoin/listen.sh &
		/sbin/bitcoin/leader.sh -l "$level" -f "$fre"
	;;
	"partner" ) #node work in partner mode
		/sbin/bitcoin/partner.sh -l "$level" -f "$fre" $2 
	;;
	"selfish" ) #node work in selfish mining mode
		echo 'working' > ~/msg
		/sbin/bitcoin/listen.sh &
		/sbin/bitcoin/selfish.sh -l "$level" -f "$fre"
esac

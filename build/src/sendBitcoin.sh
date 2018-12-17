#!/bin/bash

#Muwei
#This script will randomly generate transactions
#among nodes.


#Check the current blockchain length, if it is under
#100, then exit
blocks=$(bitcoin-cli getblockcount)

if [ "$blocks" -le 100 ]
then
	echo "The current blockchain length is $blocks."
	echo "Script can't execute until there are at least 101 blocks."
	echo "Please run initBlocks.sh to initialize the first 101 blocks."
	exit 1
fi

iden=$2

#Initiate parameters
fre=120 #The average frequency of transaction (1 per fre seconds)
maxsend=10 #The ratio of max amount that send in each transaction
mapfile -t traders < $1  #Take an input file to get list of traders
num=${#traders[@]} #Get the number of traders


#Go into a while loop to always try to make transactions
while true
do

#Get my current balance
balance=$(bitcoin-cli getbalance)
balance=$(printf "%.*f\n" 0 $balance) # Round balance to integer


#Randomly choose a receiver
address=${traders[$(($RANDOM % num))]}


#Make transaction
amount=$(($RANDOM % maxsend ))

if [ $balance -le $amount ]; then
    amount=$(($RANDOM % balance))
fi

if [ "$amount" == 0 ]; then
    amount=$((amount + 1))
fi

bitcoin-cli sendtoaddress "$address" "$amount" 

echo "$iden Send $amount to $address"
echo ""


#Sleep a while
sleep $(($RANDOM % (fre * 2)))

done

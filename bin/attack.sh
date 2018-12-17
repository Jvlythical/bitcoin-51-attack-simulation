#!/bin/bash

#Muwei
#This code will mimic a 51% attack

#Halt all mining process
#echo "Stoping mining process for pool 1"
#docker exec btc-leader-1 /sbin/bitcoin/haltmining.sh
#docker exec btc-node-1-1 /sbin/bitcoin/haltmining.sh
#docker exec btc-node-1-2 /sbin/bitcoin/haltmining.sh
#echo "Stoping mining process for pool 2"
#docker exec btc-leader-2 /sbin/bitcoin/haltmining.sh
#echo "Stoping mining process for pool 3"
#docker exec btc-leader-3 /sbin/bitcoin/haltmining.sh
#docker exec btc-node-3-1 /sbin/bitcoin/haltmining.sh

echo "Wait for network to be initialized, it might take up to 1 min..."

while true; do
        l_1_connections=$(docker exec btc-leader-1 bitcoin-cli getconnectioncount)
        if [ "$l_1_connections" != "6" ]; then
                sleep 1
                continue
        fi
        l_2_connections=$(docker exec btc-leader-2 bitcoin-cli getconnectioncount)
        if [ "$l_2_connections" != "4" ]; then
                sleep 1
                continue
        fi
        l_3_connections=$(docker exec btc-leader-3 bitcoin-cli getconnectioncount)
        if [ "$l_3_connections" != "5" ]; then
                sleep 1
                continue
        fi
        break
done

echo ""

echo "51% Attack!

=============================================="
date
echo ""

#leader 3 generate 1st 101 blocks to get 50 spendable btc
docker exec btc-leader-3 bitcoin-cli generate 101 > /dev/null

#leader 3 send 40 btc to leader 1
addr1=$(docker exec btc-leader-1 bitcoin-cli getrawchangeaddress)
docker exec btc-leader-3 bitcoin-cli sendtoaddress $addr1 40 > /dev/null
docker exec btc-leader-3 bitcoin-cli generate 1 > /dev/null

#Make a transaction from leader 1 to leader 2
addr=$(docker exec btc-leader-2 bitcoin-cli getrawchangeaddress)
tx=$(docker exec btc-leader-1 bitcoin-cli sendtoaddress $addr 10)
echo "Pool 1 send 10 of bitcoin to Pool 2 with transaction hash:
$tx"


echo "
Generate 1 block to confirm this transaction.
The hash of the block is:"
docker exec btc-leader-1 bitcoin-cli generate 1

echo ""

#Record current status of leader 1 and leader 3

currentcount=$(docker exec btc-leader-1 bitcoin-cli getblockcount)
currenthash=$(docker exec btc-leader-1 bitcoin-cli getblockhash $currentcount)
currentblock=$(docker exec btc-leader-1 bitcoin-cli getblock $currenthash)
echo "Status before attack"
echo "Block Information of Block $currentcount:
$currentblock
" 


#wait for 3s to allow all nodes hear this block
sleep 10

#Leader 1 mining pool start working on its own branch
parent=$((currentcount - 1 ))
parenthash=$(docker exec btc-leader-1 bitcoin-cli getblockhash $parent)
docker exec btc-leader-1 bitcoin-cli invalidateblock $parenthash


#Restart mining
./startmining.sh

echo ""


#In a while loop, check if leader 1's branch is longer
#the best block chain
echo "It might take some time for Pool 1 to win the rest of the network.
To get more information about current status, run \"docker exec btc-leader-2 bitcoin-cli getchaintips.\"
"

attackhash=""
while true
do
	attackhash=$(docker exec btc-leader-2 bitcoin-cli getblockhash $currentcount)
	if [ "$attackhash" != "$currenthash" ];then
		break
	fi
	sleep 5
done

attackblock=$(docker exec btc-leader-2 bitcoin-cli getblock $attackhash)
echo " 
==============================================
Status After Attack:
$(date)

Block Information of Block $currentcount:
$attackblock
" 

echo "We can observe in the tx field that the transaction hash pool1 made to pool2 is disappeared.
"

date

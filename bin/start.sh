#!/bin/bash

#Muwei
#Generate the 1st 102 blocks.
#This ensure that all pool will have
#some spendable bitcoins.

echo "Initializing the network connection, it might take up to 1 min..."
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

echo "Start generate first 106 blocks..."

for i in {1..35};do
    for t in {1..3};do
		docker exec btc-leader-"$t" bitcoin-cli generate 1 > /dev/null
		block_count=$(docker exec btc-leader-"$t" bitcoin-cli getblockcount)
    done
done
docker exec btc-leader-3 bitcoin-cli generate 1 > /dev/null

count=$(docker exec btc-leader-1 bitcoin-cli getblockcount)
echo ""
echo "The current block chain count is $count"
echo "The current balance for leader 1 is $(docker exec btc-leader-1 bitcoin-cli getbalance)"
echo "The current balance for leader 2 is $(docker exec btc-leader-2 bitcoin-cli getbalance)"
echo "The current balance for leader 3 is $(docker exec btc-leader-3 bitcoin-cli getbalance)"


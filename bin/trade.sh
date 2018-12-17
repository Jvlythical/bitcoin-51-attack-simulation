#!/bin/bash

#Muwei
#This script will randomly generate transactions
#among nodes.

#get address from three leaders
addr1=$(docker exec btc-leader-1 bitcoin-cli getrawchangeaddress)
addr2=$(docker exec btc-leader-2 bitcoin-cli getrawchangeaddress)
addr3=$(docker exec btc-leader-3 bitcoin-cli getrawchangeaddress)

#send transactions
echo "$addr2
$addr3" > customer_1.txt
docker exec btc-leader-1 /sbin/bitcoin/sendBitcoin.sh /sbin/bitcoin/customer_1.txt leader1 &

echo "$addr1
$addr3" > customer_2.txt
docker exec btc-leader-2 /sbin/bitcoin/sendBitcoin.sh /sbin/bitcoin/customer_2.txt leader2 &

echo "$addr2
$addr1" > customer_3.txt
docker exec btc-leader-3 /sbin/bitcoin/sendBitcoin.sh /sbin/bitcoin/customer_3.txt leader3 &


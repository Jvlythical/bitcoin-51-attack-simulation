#!/bin/bash

#Muwei
#This code will let the 3 groups start mining blocks.

mkdir -p result
dir="./result/"

#get IP for leader 1 and leader 3
leader_1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' btc-leader-1)
leader_3=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' btc-leader-3)

#touch ./pool1_result.txt
#touch "$dir"pool2_result.txt
#touch "$dirpool3_result.txt"

#start mining
#pool 1
echo "Pool 1 Result

" > "$dir"pool1_result.txt

if [ "$1" == "selfish" ];then
docker exec btc-leader-1 /sbin/bitcoin/mine.sh -l 4 -f 250 selfish >> "$dir"pool1_result.txt &
echo "Pool 1 starts mining in selfish mode"
else
docker exec btc-leader-1 /sbin/bitcoin/mine.sh -l 4 -f 250 leader >> "$dir"pool1_result.txt &
echo "Pool 1 leader starts mining"
fi
docker exec btc-node-1-1 /sbin/bitcoin/mine.sh -l 4 -f 250 partner "$leader_1" >> "$dir"pool1_result.txt &
echo "Pool 1 node 1 starts mining"
docker exec btc-node-1-2 /sbin/bitcoin/mine.sh -l 4 -f 250 partner "$leader_1" >> "$dir"pool1_result.txt &
echo "Pool 1 node 2 starts mining"

#pool 2
echo "Pool 2 Result

" > "$dir"pool2_result.txt
docker exec btc-leader-2 /sbin/bitcoin/mine.sh leader >> "$dir"pool2_result.txt &
echo "Pool 2 leader starts mining"

#pool 3
echo "Pool 3 Result

" > "$dir"pool3_result.txt
docker exec btc-leader-3 /sbin/bitcoin/mine.sh leader >> "$dir"pool3_result.txt & 
echo "Pool 3 leader starts mining"
docker exec btc-node-3-1 /sbin/bitcoin/mine.sh partner "$leader_3" >> "$dir"pool3_result.txt &
echo "Pool 3 node 1 starts mining"

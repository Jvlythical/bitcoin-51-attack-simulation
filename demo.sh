#!/bin/bash

#Muwei
#This is a demo of bitcoin network simulator created by Michael Yen, Minqiang Hu, Muwei Zheng
#There will be three mining pools in this bitcoin network, and they are fully connected 
#with each other. The first pool will have 3 nodes, the second pool will have 1 node,
#and the third pool will have 2 nodes.
#The demo can be run in three different mode:
#
#normal - the network simulate a normal bitcoin network. There will be random transactions 
#         going among pools
#attack - the network will simulate a 51% attack. 
#selfish - pool 1 will do a selfish mining

#Add library to current path
export PATH="./bin:$PATH"


case "$1" in 
	"normal" )
		sh setup.sh
		start.sh
		trade.sh &
		startmining.sh
		;;
	"attack" )
		sh setup.sh
		echo "result will be stored in ./result folder"
		attack.sh
		;;
	"selfish" )
		sh setup.sh
		startmining.sh selfish
		;;
esac
	


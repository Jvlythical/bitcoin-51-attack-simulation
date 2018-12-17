#!/bin/bash

#Muwei
#This code will halt all mining process

ps -aux | grep 'leader.sh' | awk '{print $2}' | xargs kill -9 || true
ps -aux | grep 'partner.sh' | awk '{print $2}' | xargs kill -9 || true

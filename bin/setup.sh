cwd=$(pwd)
for pool in sim/*; do 
	cd "$pool"
	docker-compose down
	echo "Cleaning up data..."
	sudo rm -rf volumes 2> /dev/null
	sh setup.sh
	cd "$cwd"
done

sleep 5

action=add
port=18444
leader_1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' btc-leader-1)
leader_2=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' btc-leader-2)
leader_3=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' btc-leader-3)

# Pool 1
echo "Leader 1 adding Leader 2"
docker exec btc-leader-1 bitcoin-cli addnode "$leader_2:$port" "$action"
echo "Leader 1 adding Leader 3"
docker exec btc-leader-1 bitcoin-cli addnode "$leader_3:$port" "$action"

# Pool 2
echo "Leader 2 adding Leader 1"
docker exec btc-leader-2 bitcoin-cli addnode "$leader_1:$port" "$action"
echo "Leader 2 adding Leader 3"
docker exec btc-leader-2 bitcoin-cli addnode "$leader_3:$port" "$action"

# Pool 3
echo "Leader 3 adding Leader 1"
docker exec btc-leader-3 bitcoin-cli addnode "$leader_1:$port" "$action"
echo "Leader 3 adding Leader 2"
docker exec btc-leader-3 bitcoin-cli addnode "$leader_2:$port" "$action"

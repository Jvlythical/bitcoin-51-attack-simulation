docker-compose up -d

sleep 2.5

pool_1_1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' btc-node-1-1)
pool_1_2=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' btc-node-1-2)

action=add
port=18444

echo "Leader 1 adding Node 1-1"
docker exec btc-leader-1 bitcoin-cli addnode "$pool_1_1:$port" "$action"
echo "Leader 1 adding Node 1-2"
docker exec btc-leader-1 bitcoin-cli addnode "$pool_1_2:$port" "$action"

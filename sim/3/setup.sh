docker-compose up -d

sleep 2.5

pool_3_1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' btc-node-3-1)

action=add
port=18444

echo "Leader 3 adding Node 3-1"
docker exec btc-leader-3 bitcoin-cli addnode "$pool_3_1:$port" "$action"

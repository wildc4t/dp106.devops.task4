#!/usr/bin/env bash

echo "---Create manager-1"
docker-machine create -d virtualbox manager-1
manager_ip=$(docker-machine ip manager-1)

echo "---Swarm Init"
docker-machine ssh manager-1 docker swarm init --listen-addr ${manager_ip} --advertise-addr ${manager_ip}

printf "\n---Get Tokens\n"
manager_token=$(docker-machine ssh manager-1 docker swarm join-token -q manager)
worker_token=$(docker-machine ssh manager-1 docker swarm join-token -q worker)
echo ${manager_token}
echo ${worker_token}


for n in {2..3} ; do
	printf "\n---Create manager-${n}\n"
	docker-machine create -d virtualbox manager-${n}
	ip=$(docker-machine ip manager-${n})
	echo "--- Swarm Manager Join"
	docker-machine ssh manager-${n} docker swarm join --listen-addr ${ip} --advertise-addr ${ip} --token ${manager_token} ${manager_ip}:2377
done

for n in {1..3} ; do
	printf "\n---Create worker-${n}\n"
	docker-machine create -d virtualbox worker-${n}
	ip=$(docker-machine ip worker-${n})
	echo "--- Swarm Worker Join"
	docker-machine ssh worker-${n} docker swarm join --listen-addr ${ip} --advertise-addr ${ip} --token ${worker_token} ${manager_ip}:2377
done
printf "\n---Launching Visualizer\n"
docker-machine ssh manager-1 docker run -it -d -p 8080:8080 -e HOST=${manager_ip} -e PORT=8080 -v /var/run/docker.sock:/var/run/docker.sock manomarks/visualizer

printf "\n---Launching overlay networking\n"

docker-machine ssh manager-1 docker network create -d overlay swarmnet

printf "\n\n------------------------------------\n"
echo "To connect to your cluster..."
echo 'eval $(docker-machine env manager-1)'
echo "To visualize your cluster..."
echo "Open a browser to http://${manager_ip}:8080/"

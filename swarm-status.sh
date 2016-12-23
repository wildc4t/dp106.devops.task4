eval $(docker-machine env manager-1)

echo docker-machine ls	
docker-machine ls

echo docker-machine ssh manager-1 docker node ls
docker-machine ssh manager-1 docker node ls
echo docker-machine ssh manager-1 docker service ls
docker-machine ssh manager-1 docker service ls

echo docker-machine ssh manager-1 docker service ps
docker-machine ssh manager-1 docker service ps tomcat-swarm

read -n 1 -s -p "Press any key to continue"

#!/bin/sh
# Script for compose dp106.devops.task4 environment docker swarm

eval $(docker-machine env manager-1)

ROOT_FOLDER=/home/hash/devopsss
# Starting service
################docker-machine ssh manager-1 docker service create --name mysqldb --replicas 1 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=mysql --mount type=volume,src=volume-mysql,dst=/var/lib/mysql --network swarmnet mysql/mysql-server
docker-machine ssh manager-1 docker service create --name tomcat-swarm --replicas 3 -p 2222:8080 --env MYSQLDB=192.168.99.1 --network swarmnet wildc4t/dp106.devops.task4.tomcat-swarm

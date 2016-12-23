#!/bin/sh
# Script for compose dp106.devops.task4 environment docker swarm

eval $(docker-machine env manager-1)

ROOT_FOLDER=/home/hash/devopsss
docker-machine ssh manager-1 docker service scale tomcat-swarm=10

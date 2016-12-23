#!/bin/sh
# Script for remove dp106.devops.task4 environment swarm

# Removing containers
docker-machine ssh manager-1 docker service rm tomcat-swarm
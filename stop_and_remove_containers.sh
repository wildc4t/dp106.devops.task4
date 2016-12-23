#!/bin/bash

echo Stoping all the containers
docker stop git
docker stop svn
docker stop jenkins
docker stop apache
docker stop mysql
docker stop tomcat

echo Removing all the containers

docker rm git
docker rm svn
docker rm jenkins
docker rm apache
docker rm mysql
docker rm tomcat
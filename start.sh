#!/bin/sh
# Script for compose dp106.devops.task4 environment

su -c "setenforce 0"  # for proper docker volume mounting
# Alternatively we can do smth similar to # chcon -Rt svirt_sandbox_file_t /docker_data/

ROOT_FOLDER=/home/hash/devopsss
GIT_SERVER_SSH_PORT=2201
SVN_SERVER_HTTP_PORT=2202
JENKINS_SERVER_HTTP_PORT=2203
APACHE_HTTP_PORT=2204
TOMCAT_HTTP_PORT=2205
MYSQL_PORT=2206
GIT_DATA=${ROOT_FOLDER}/docker_data/git
SVN_DATA=${ROOT_FOLDER}/docker_data/svn
JENKINS_DATA=${ROOT_FOLDER}/docker_data/jenkins
MYSQL_DATA=${ROOT_FOLDER}/docker_data/mysql
APACHE_WEB_DIR=${ROOT_FOLDER}/docker_data/apache
TOMCAT_WEB_DIR=${ROOT_FOLDER}/docker_data/tomcat

#1 GIT Server
mkdir -p ${GIT_DATA}
cd ${GIT_DATA}
mkdir -p .ssh
chown -R 987:987 .ssh
chmod -R 700 .ssh
touch .ssh/authorized_keys
chmod 644 .ssh/authorized_keys
cat ${ROOT_FOLDER}/ssh_keys/* > .ssh/authorized_keys
touch ${GIT_DATA}/.hushlogin # to prevent login banners that can confuse git.
# 1.1 Setup repos
mkdir -p ${GIT_DATA}/app4.git
if [ ! -d "${GIT_DATA}/app4.git" ]; then
cd ${GIT_DATA}/app4.git
git --bare init
chown -R 987:987 .
fi
mkdir -p ${GIT_DATA}/oms.git
if [ ! -d "${GIT_DATA}/oms.git" ]; then
cd ${GIT_DATA}/oms.git
git --bare init
chown -R 987:987 .
fi
#2 SVN Server
mkdir -p ${SVN_DATA}
#3 Jenkins 
mkdir -p ${JENKINS_DATA}
#4 Apache
#mkdir -p ${APACHE_WEB_DIR}
#5 Tomcat
#mkdir -p ${TOMCAT_WEB_DIR}
#6 MYSQL
mkdir -p ${MYSQL_DATA}

#Starting data volumes
docker volume create --name volume-tomcat
docker volume create --name volume-apache

# Starting containers
docker run -d --name git -p ${GIT_SERVER_SSH_PORT}:22 -v ${GIT_DATA}:/git wildc4t/dp106.devops.task4.git:lastest
docker run -d --name svn -p ${SVN_SERVER_HTTP_PORT}:80 -v ${SVN_DATA}:/var/www/svn wildc4t/dp106.devops.task4.svn:lastest
###mkdir -p ${ROOT_FOLDER}/mycop/svn-structure-template/{trunk,branches,tags}
###svn import --username=svn --password=svn --no-auth-cache -m 'Initial import' ${ROOT_FOLDER}/mycop/svn-structure-template/ http://127.0.0.1:${SVN_SERVER_HTTP_PORT}/svn/repo
docker run -d --name mysql -p ${MYSQL_PORT}:3306 -e MYSQL_ROOT_PASSWORD=mysql -v ${MYSQL_DATA}:/var/lib/mysql mysql/mysql-server
docker run  --name jenkins --link git:git --link svn:svn -v volume-tomcat:/jenkins/deploy_to_tomcat -v volume-apache:/jenkins/deploy_to_lamp -d -p ${JENKINS_SERVER_HTTP_PORT}:8080 -v /etc/localtime:/etc/localtime:ro -v ${JENKINS_DATA}:/jenkins wildc4t/dp106.devops.task4.jenkins:lastest

docker run -dit --name apache --link mysql:mysqldb -p ${APACHE_HTTP_PORT}:80 -v volume-apache:/var/www/html wildc4t/dp106.devops.task4.apache:lastest
docker run -d --name tomcat --link mysql:mysqldb -p ${TOMCAT_HTTP_PORT}:8080 -v volume-tomcat:/usr/local/tomcat/webapps tomcat:8.0

docker run -v volume-mysql:/var/lib/mysql --name helper busybox true
docker cp /home/hash/devopsss/docker_data/mysql helper:/var/lib/mysql
docker rm helper
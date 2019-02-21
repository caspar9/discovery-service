#!/usr/bin/env bash
serviceName="discovery-service"
BUILD_NUMBER=$1
eurekaHostIp=$2
env=$3

echo "stop and delete exist docker images and container..."
running=`docker ps | grep ${serviceName} | awk '{print $1}'`
if [ ! -z "$running" ]; then
    docker stop $running
fi

container=`docker ps -a | grep ${serviceName} | awk '{print $1}'`
if [ ! -z "$container" ]; then
    docker rm $container -f
fi

imagesid=`docker images|grep -i ${serviceName}|awk '{print $3}'`
if [ ! -z "$imagesid" ]; then
    docker rmi $imagesid -f
fi

echo "load docker images ${serviceName}_${BUILD_NUMBER}.tar .."
docker load -i ${serviceName}_${BUILD_NUMBER}.tar

echo "run docker container..."
docker run --env env=${env} --env serverIp=${serverIp} -it -d -p 1111:1111 --name ${serviceName} ${serviceName}:${BUILD_NUMBER}
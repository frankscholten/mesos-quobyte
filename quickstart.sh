#!/bin/bash

#
# This script deploys Mesos Quobyte on a minimesos cluster
#

command -v minimesos >/dev/null 2>&1 || { echo "minimesos is not found. You can install it by running 'curl -sSL https://minimesos.org/install | sh'. For more info see https://www.minimesos.org" >&2; exit 1; }

if [ "$1" == "" ]; then
  echo "Usage: quickstart.sh <ipaddress>"
  exit 1
fi;

IP=$1

echo "Launching minimesos cluster..."
minimesos up

echo "Exporting minimesos environment variables..."
$(minimesos)

MASTER_HOST_PORT=$(echo $MINIMESOS_MASTER | cut -d/ -f3)

echo "Installing Mesos Quobyte..."
ZK_HOST_PORT=$(echo $MINIMESOS_ZOOKEEPER | cut -d/ -f3)
docker run -d quobyte/quobyte-mesos:latest /opt/quobyte-mesos-cmd.sh --zk=$ZK_HOST_PORT --master=zk://$ZK_HOST_PORT/mesos

echo "Wait until Mesos Quobyte API is available..."
#while ! nc -z $IP 7000; do
#  sleep 0.1 # wait for 1/10 of the second before check again
#done
#echo "Mesos Kafka API is available..."
#
#echo "Adding broker 0..."
#cd /tmp
#./kafka-mesos.sh broker add 0
#cd - 2>&1 > /dev/null
#
#echo "Starting broker 0..."
#cd /tmp
#./kafka-mesos.sh broker start 0
#cd - 2>&1 > /dev/null
#
#minimesos state > state.json
#BROKER_IP=$(cat state.json | jq -r ".frameworks[0].tasks[] | select(.name=\"broker-0\").statuses[0].container_status.network_infos[0].ip_address")
#echo "broker-0 IP is $BROKER_IP"

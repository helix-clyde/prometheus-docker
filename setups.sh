#!/usr/bin/env bash

# set -x

NODELIST=~/nodes.txt
rm -v $NODELIST

for host in $(qconf -sh | sort -R ); do
  (ssh \
      -o StrictHostKeyChecking=false \
      -o ConnectTimeout=1 \
      $host \
       "sudo ~clyde.jones/prometheus-docker/nodeexporter.sh \
       ; ~clyde.jones/bin/getip.sh \
       ; ~clyde.jones/prometheus-docker/etc/prometheus/targets/config_create.sh"\
  ) \
   | grep 172\. \
   |tee -a ${NODELIST} \

done
       # sudo docker kill node-exporter; \
       # sudo docker rm node-exporter; \

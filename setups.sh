#!/usr/bin/env bash

# set -x

NODELIST=~/nodes.txt
rm -v $NODELIST

if [[ $(type -p parallel) ]]; then
  qconf -sh \
  | sort -R \
  | parallel -j 10 ssh \
      -o StrictHostKeyChecking=false \
      -o ConnectTimeout=1 \
      $host \
       "sudo ~clyde.jones/prometheus-docker/nodeexporter.sh \
       ; ~clyde.jones/prometheus-docker/etc/prometheus/targets/config_create.sh"
else
  for host in $(qconf -sh | sort -R ); do
    (ssh \
        -o StrictHostKeyChecking=false \
        -o ConnectTimeout=1 \
        $host \
         "sudo ~clyde.jones/prometheus-docker/nodeexporter.sh \
         ; ~clyde.jones/prometheus-docker/etc/prometheus/targets/config_create.sh \
         ; ~clyde.jones/bin/getip.sh" \
    ) \
     | grep 172\. \
     |tee -a ${NODELIST} \

  done
fi

# sudo docker kill node-exporter; \
# sudo docker rm node-exporter; \

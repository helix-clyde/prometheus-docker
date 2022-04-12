#!/usr/bin/env bash

# set -x

NODELIST=~/nodes.txt
rm -v $NODELIST

  for host in $(qconf -sh | sort -R ); do
    (ssh \
        -o StrictHostKeyChecking=false \
        -o UserKnownHostsFile=/dev/null \
        -o ConnectTimeout=1 \
        $host \
         "\
         sudo docker kill node-exporter; \
         sudo docker rm node-exporter; \
         sudo ~clyde.jones/prometheus-docker/nodeexporter.sh \
         ; ~clyde.jones/prometheus-docker/etc/prometheus/targets/config_create.sh \
         ; ~clyde.jones/bin/getip.sh" \
    ) \
     | grep 172\. \
     |tee -a ${NODELIST} \

  done

# sudo docker kill node-exporter; \
# sudo docker rm node-exporter; \

# End of file, if this is missing the file is truncated
##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##

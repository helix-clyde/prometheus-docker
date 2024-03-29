#!/usr/bin/env bash

[[ $DEBUG ]] && set -x

LOGDIR=~/logs/prometheus-docker/

mkdir -vp $LOGDIR

for (( i = 0; i < 47; i++ )); do
  echo $(date +%F-%H%M)
  for host in $(qconf -sh | sort -R ); do
    ssh \
        -o StrictHostKeyChecking=false \
        -o UserKnownHostsFile=/dev/null \
        -o ConnectTimeout=1 \
        $host \
         " ~clyde.jones/prometheus-docker/nodeexporter.sh \
         ; sudo ~clyde.jones/prometheus-docker/etc/prometheus/targets/config_create.sh "
  done
  sleep 20m
done

# End of file, if this is missing the file is truncated
##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##

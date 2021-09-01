#!/usr/bin/env bash

export VERSION="v1.2.2"

if [[ $(docker ps  | grep node-exporter | wc -l| tr -d ' ') -ne "1" ]] ; then
  docker run \
    --name node-exporter \
    --restart unless-stopped \
    --health-cmd='wget -q --spider http://localhost:9100/metrics' \
    --health-interval=30s \
    --health-retries=3 \
    -p 9100:9100 \
    -d \
    -v /:/host:ro \
    quay.io/prometheus/node-exporter:${VERSION} \
      --path.rootfs=/host \
      --collector.ntp \
      --collector.supervisord
fi

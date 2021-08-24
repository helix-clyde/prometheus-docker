#!/usr/bin/env bash

set -x

export VERSION="v1.2.0"

docker run \
  --name node-exporter \
  --restart unless-stopped \
  -p 9100:9100 \
  -d \
  --health-cmd='curl -s --fail http://localhost:9100 -o /dev/null' \
  --health-interval=30s \
  --health-retries=3 \
  -v /:/host:ro \
  quay.io/prometheus/node-exporter:${VERSION} \
    --path.rootfs=/host \
    --collector.ntp \
    --collector.supervisord

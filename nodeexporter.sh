#!/usr/bin/env bash

set -x

export VERSION="v1.2.0"

docker run \
  --name node-exporter \
  --restart unless-stopped \
  --health-cmd='wget -q --spider https://localhost:9100/metrics' \
  --health-interval=30s \
  --health-retries=3 \
  -p 9100:9100 \
  -d \
  -v /:/host:ro \
  quay.io/prometheus/node-exporter:${VERSION} \
    --path.rootfs=/host \
    --collector.ntp \
    --collector.supervisord

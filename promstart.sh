#!/usr/bin/env bash

[[ $DEBUG ]] && set -x

PROM_BASE="/opt/prometheus"
EFS_BASE="/efs/monitoring/prometheus"
export VERSION="v2.30.3"

mkdir -vp ${EFS_BASE}/etc/ \
          ${PROM_BASE}/data/ \
          ${PROM_BASE}/log/

docker run \
        --name=prometheus \
        -d \
        --restart unless-stopped \
        -p 9090:9090 \
        -v ${PROM_BASE}/data/:/var/lib/prometheus/data/ \
        -v ${EFS_BASE}/etc/:/etc/prometheus/ \
        -v ${PROM_BASE}/log/:/var/log/prometheus/ \
        quay.io/prometheus/prometheus:${VERSION} \
            --config.file=/etc/prometheus/prometheus.yml \
            --storage.tsdb.path="/var/lib/prometheus/data/" \
            --storage.tsdb.retention.time=14d \
            --storage.tsdb.wal-compression \
            --storage.tsdb.retention.size=2G

#!/usr/bin/env bash

[[ $DEBUG ]] && set -x

PROM_BASE="/opt/prometheus"
EFS_BASE="/efs/monitoring/prometheus"

export VERSION="v2.34.0"

mkdir -vp ${EFS_BASE}/etc/ \
          ${PROM_BASE}/data/ \
          ${PROM_BASE}/log/
sudo chown -c 65534.65534 \
           ${PROM_BASE}/data/ \
           ${PROM_BASE}/log/

docker run \
        --name=prometheus \
        -d \
        --restart unless-stopped \
        -p 9090:9090 \
        --health-cmd='/bin/wget -q --spider http://localhost:9090/' \
        --health-interval=30s \
        --health-retries=3 \
        -v ${PROM_BASE}/data/:/var/lib/prometheus/data/ \
        -v ${EFS_BASE}/etc/:/etc/prometheus/ \
        -v ${PROM_BASE}/log/:/var/log/prometheus/ \
        quay.io/prometheus/prometheus:${VERSION} \
            --config.file=/etc/prometheus/prometheus.yml \
            --storage.tsdb.path="/var/lib/prometheus/data/" \
            --storage.tsdb.retention.size=1GB \
            --storage.tsdb.retention.time=7d \
            --storage.tsdb.wal-compression \
            --web.enable-lifecycle

# End of file, if this is missing the file is truncated
##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##

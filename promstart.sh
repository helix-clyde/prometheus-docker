#!/usr/bin/env bash

[[ $DEBUG ]] && set -x

NODEIP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
PROM_BASE="/var/lib/prometheus"
EFS_BASE="/efs/monitoring/prometheus"

export VERSION="v2.39.1"

mkdir -vp ${EFS_BASE}/etc/ \
          ${PROM_BASE}/data/ \
          ${PROM_BASE}/log/

sudo chown -cR 65534.65534 \
               ${PROM_BASE}

# change the configs to use the current node ip

cat ${EFS_BASE}/etc/prometheus.yml.tmpl \
| sed -e "s/X.X.X.X/${NODEIP}/" \
| sudo tee ${EFS_BASE}/etc/prometheus.yml

docker run \
        --name=prometheus \
        -d \
        --log-driver local \
        --log-opt max-size=1m \
        --restart unless-stopped \
        -p 9090:9090 \
        --health-cmd='/bin/wget -q --spider http://localhost:9090/-/healthy' \
        --health-interval=30s \
        --health-retries=3 \
        -v ${PROM_BASE}/data/:/var/lib/prometheus/data/ \
        -v ${EFS_BASE}/etc/:/etc/prometheus/ \
        -v ${PROM_BASE}/log/:/var/log/prometheus/ \
        prom/prometheus:${VERSION} \
            --config.file=/etc/prometheus/prometheus.yml \
            --storage.tsdb.path="/var/lib/prometheus/data/" \
            --storage.tsdb.retention.size=2GB \
            --storage.tsdb.retention.time=28d \
            --storage.tsdb.wal-compression \
            --web.enable-admin-api \
            --web.enable-lifecycle

# End of file, if this is missing the file is truncated
##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##

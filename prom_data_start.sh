#!/usr/bin/env bash

[[ $DEBUG ]] && set -x

NODEIP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
PROM_BASE="/var/lib/prometheus"
EFS_BASE="/efs/monitoring/prometheus"
PROM_VOL="prometheus_data"

export VERSION="v2.34.0"

mkdir -vp ${EFS_BASE}/etc/ \
          ${PROM_BASE}/data/ \
          ${PROM_BASE}/log/

sudo chown -c 65534.65534 \
           ${PROM_BASE}/data/ \
           ${PROM_BASE}/log/

docker volume create prometheus_data

# fix permssions on data directory
docker run \
       --rm \
       -it \
       --name=promsetup \
       -v prometheus_data:/var/lib/prometheus/ \
   debian:buster-slim \
   sh -c "mkdir -vp /var/lib/prometheus/data/ \
        ; mkdir -vp /var/lib/prometheus/log \
        ; chown -cR 65534:65534 /var/lib/prometheus/"

# change the configs to use the current node ip

cat etc/prometheus/prometheus.yml \
| sed -e "s/X.X.X.X/${NODEIP}/" \
| sudo tee ${EFS_BASE}/etc/prometheus.yml

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
        prom/prometheus:${VERSION} \
            --config.file=/etc/prometheus/prometheus.yml \
            --storage.tsdb.path="/var/lib/prometheus/data/" \
            --storage.tsdb.retention.size=2GB \
            --storage.tsdb.retention.time=28d \
            --storage.tsdb.wal-compression \
            --log.level=error \
            --web.enable-lifecycle

# End of file, if this is missing the file is truncated
##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##

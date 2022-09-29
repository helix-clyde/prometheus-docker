#!/usr/bin/env bash

[[ $DEBUG ]] && set -x

VERSION="v1.3.1"
CONTAINER_NAME="node-exporter"
REPO="prom"

RUNNING_VERSION=$(docker ps --format '{{.Image}}' -f name=${CONTAINER_NAME} \
                  | grep ${CONTAINER_NAME} \
                  | cut -d : -f 2)

launch_container()
{
  docker run \
    --name ${CONTAINER_NAME} \
    -e TZ=PST8PDT \
    --restart unless-stopped \
    --health-cmd='wget -q --spider http://localhost:9100/metrics' \
    --health-interval=300s \
    --health-retries=3 \
    --log-driver local \
    --log-opt max-size=1m \
    -p 9100:9100 \
    -d \
    -v /:/host:ro \
    -v /efs/:/host/efs/:ro \
    ${REPO}/${CONTAINER_NAME}:${VERSION} \
      --path.rootfs=/host \
      --log.level=error
}

if [[ $(docker ps --format '{{ .Names }}' | egrep -c "PrometheusAgent|${CONTAINER_NAME}") -gt 0 ]] ; then
    echo "${CONTAINER_NAME} is running"
else 
   launch_container
fi

# End of file, if this is missing the file is truncated
##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##

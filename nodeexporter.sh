#!/usr/bin/env bash

[[ $DEBUG ]] && set -x

VERSION="v1.3.1"
CONTAINER_NAME="node-exporter"
REPO="quay.io/prometheus"

RUNNING_VERSION=$(docker ps --format 'table {{.Image}}' -f name=${CONTAINER_NAME} \
                  | grep ${CONTAINER_NAME} \
                  | cut -d : -f 2)

launch_container()
{
  docker run \
    --name ${CONTAINER_NAME} \
    --restart unless-stopped \
    --health-cmd='wget -q --spider http://localhost:9100/metrics' \
    --health-interval=300s \
    --health-retries=3 \
    -p 9100:9100 \
    -d \
    -v /:/host:ro \
    -v /efs/:/host/efs/:ro \
    ${REPO}/${CONTAINER_NAME}:${VERSION} \
      --path.rootfs=/host \
      --collector.supervisord \
      --log.level=error
}

  docker stop ${CONTAINER_NAME}
  docker rm ${CONTAINER_NAME}
  launch_container

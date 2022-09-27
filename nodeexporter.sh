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

# if [[ $(docker ps --format '{{ .Names }}' --filter name="${CONTAINER_NAME}") == "${CONTAINER_NAME}" ]] ; then
#   docker stop ${CONTAINER_NAME}
#   docker rm ${CONTAINER_NAME}
# fi
launch_container

# End of file, if this is missing the file is truncated
##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##

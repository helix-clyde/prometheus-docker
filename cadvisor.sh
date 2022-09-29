#!/usr/bin/env bash

[[ $DEBUG ]] && set -x

VERSION="v0.45.0"
CONTAINER_NAME="cadvisor"
REPO="gcr.io/cadvisor"

RUNNING_VERSION=$(docker ps --format '{{.Image}}' -f name=${CONTAINER_NAME} \
                  | grep ${CONTAINER_NAME} \
                  | cut -d : -f 2)

launch_container()
{
  docker run \
    --name ${CONTAINER_NAME} \
    --privileged \
    -e TZ=PST8PDT \
    --publish=9343:8080 \
    --restart unless-stopped \
    --health-cmd='/bin/wget -q --spider http://localhost:8080/metrics' \
    --health-interval=300s \
    --health-retries=3 \
    --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:ro \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --volume=/dev/disk/:/dev/disk:ro \
    --detach=true \
    --device=/dev/kmsg \
    ${REPO}/${CONTAINER_NAME}:${VERSION}
}

if [[ $(docker ps --format '{{ .Names }}' --filter name="${CONTAINER_NAME}") == "${CONTAINER_NAME}" ]] ; then
#   docker stop ${CONTAINER_NAME}
#   docker rm ${CONTAINER_NAME}
    echo "${CONTAINER_NAME} is running"
else 
   launch_container
fi

# End of file, if this is missing the file is truncated
##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##

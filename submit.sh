#!/usr/bin/env bash
set -x

NOW=$(date +%Y%m)

# submit the main job
#   use -terse for simpler output
#       -V to export *ALL* env variables
# for day in $(seq -w 30); do
  for hour in $(seq -w 0 4 24) ; do
    SUBTIME=${NOW}${day}${hour}
      qsub \
        -terse \
        -V \
        -a ${SUBTIME} \
        -N node_exporter \
        -o ~/prometheus-docker/setup-${SUBTIME}.out \
        -e ~/prometheus-docker/setup-${SUBTIME}.err \
      < ~/prometheus-docker/setup.sh
  done
# done

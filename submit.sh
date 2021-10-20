#!/usr/bin/env bash
# set -x

MIN=35

mkdir -vp ~/logs/prometheus-docker/

for future in $(seq 0 60); do
  # echo -en "\n$future\t"
  NOW=$(date +%Y%m%d -d "+$future day")
  # echo $NOW
  for hour in $(seq -w 0 6 23) ; do
    SUBTIME=${NOW}${hour}${MIN}
    echo $SUBTIME
      qsub \
        -a ${SUBTIME} \
        -N node_exporter-$SUBTIME \
        -o ~/logs/prometheus-docker/setup-${SUBTIME}.out \
        -e ~/logs/prometheus-docker/setup-${SUBTIME}.err \
      < ~/prometheus-docker/setups.sh
  done
done

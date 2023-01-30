#!/usr/bin/env bash

set -x

# qsub \
#   -q ondemand.q \
#   -hold_jid 32052 \
#   -N ne-setup \
#   -o /efs/home/clyde.jones/logs/prometheus-docker/submits-$(date +%F).out \
#   -e /efs/home/clyde.jones/logs/prometheus-docker/submits-$(date +%F).err < ~/prometheus-docker/submit.sh

LOGDIR=/efs/home/clyde.jones/logs/prometheus-docker
QUEUE=spot.q

mkdir -vp $LOGDIR/

JOB_ID=$(qstat -t \
         | grep node_ex \
         | tr -s ' ' \
         | cut -d ' ' -f 2 \
         | sort -n \
         | tail -n 1)

for (( i = 0; i < 10; i++ )); do
  if [[ ${JOB_ID} == "" ]]; then
    JOB_ID=$(qsub \
        -q $QUEUE \
        -terse \
        -N node_ex \
        -j y \
        -o $LOGDIR/prom-setup-$(date +%F-%H%M).out \
        < ~/prometheus-docker/submit.sh )
  else
    JOB_ID=$(qsub \
        -q $QUEUE \
        -terse \
        -N node_ex_${JOB_ID} \
        -hold_jid $JOB_ID\
        -j y \
        -o $LOGDIR/prom-setup-${JOB_ID}-$(date +%F-%H%M).out \
        < ~/prometheus-docker/submit.sh )
    qsub \
        -q $QUEUE \
        -terse \
        -N clean_${JOB_ID} \
        -hold_jid $JOB_ID\
        -j y \
        -o $LOGDIR/clean-${JOB_ID}-$(date +%F-%H%M).out \
        < ~/prometheus-docker/cleanup.sh
  fi
  echo $JOB_ID
done

# End of file, if this is missing the file is truncated
##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##

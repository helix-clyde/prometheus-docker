#!/usr/bin/env bash

set -x

# qsub \
#   -q ondemand.q \
#   -hold_jid 32052 \
#   -N ne-setup \
#   -o /efs/home/clyde.jones/logs/prometheus-docker/submits-$(date +%F).out \
#   -e /efs/home/clyde.jones/logs/prometheus-docker/submits-$(date +%F).err < ~/prometheus-docker/submit.sh

LOGDIR=/efs/home/clyde.jones/logs/prometheus-docker

mkdir -vp $LOGDIR/

JOB_ID = ""
for (( i = 0; i < 10; i++ )); do
  if [[ ${JOB_ID} == "" ]]; then
    JOB_ID=$(qsub \
        -q ondemand.q \
        -terse \
        -N node_ex \
        -o $LOGDIR/prom-setup-$(date +%F-%H%M).out \
        -e $LOGDIR/prom-setup-$(date +%F-%H%M).err \
        < ~/prometheus-docker/setups.sh )
  else
    JOB_ID=$(qsub \
        -q ondemand.q \
        -terse \
        -N node_ex_${JOB_ID} \
        -hold_jid $JOB_ID\
        -o $LOGDIR/prom-setup-$(date +%F-%H%M).out \
        -e $LOGDIR/prom-setup-$(date +%F-%H%M).err \
        < ~/prometheus-docker/setups.sh )
  fi
  echo $JOB_ID
done

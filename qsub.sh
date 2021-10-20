#!/usr/bin/env bash

set -x

LOGDIR=/efs/home/clyde.jones/logs/prometheus-docker
mkdir -vp $LOGDIR/

qsub \
    -q ondemand.q \
    -N node_exporter \
    -o $LOGDIR/prom-setup-$(date +%F-%H%M).out \
    -e $LOGDIR/prom-setup-$(date +%F-%H%M).err \
    < ~/prometheus-docker/setups.sh 

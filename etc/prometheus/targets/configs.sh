#!/usr/bin/env bash

# Checks existing configs and removes them if the node is not responding.
set -x

TARGET_DIR=/efs/monitoring/prometheus/etc/targets
MASTERNODE=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

cd $TARGET_DIR
mkdir -vp ${TARGET_DIR}/old/

for node in $(cat $TARGET_DIR/*.yml \
           | grep 9100 \
           | cut -d \' -f 2 \
           | cut -d ":" -f 1 ); do
    curl --connect-timeout 2 \
         -s \
         --fail http://${node}:9100/metrics \
         -o /dev/null \
    || mv -v $TARGET_DIR/${node}.yml $TARGET_DIR/old/${node}.yml.old
 done

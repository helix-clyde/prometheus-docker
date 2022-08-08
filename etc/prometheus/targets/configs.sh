#!/usr/bin/env bash

set -x

TARGET_DIR=/efs/monitoring/prometheus/etc/targets
MASTERNODE=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
NWMASK=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 | cut -d . -f1,2)

cd $TARGET_DIR
mkdir -vp ${TARGET_DIR}/old/

for x in $(ls $TARGET_DIR/*.yml ); do
    ADDY=$(basename $x .yml)
    curl --connect-timeout 2 \
         -s \
         --fail http://$ADDY:9100/metrics \
         -o /dev/null \
    || mv -v $TARGET_DIR/$ADDY.yml $TARGET_DIR/old/$ADDY.yml.old
 done


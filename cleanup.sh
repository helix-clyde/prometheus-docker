#!/usr/bin/env bash

ssh \
  -o StrictHostKeyChecking=false \
  -o UserKnownHostsFile=/dev/null \
  -o ConnectTimeout=1 \
  localhost \
      "cd /efs/monitoring/prometheus/etc/targets/ \
    && sudo /efs/monitoring/prometheus/etc/targets/configs.sh"

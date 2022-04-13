#!/usr/bin/env bash

# for a node to create it's own configuration
set -x

TARGET_DIR=/efs/monitoring/prometheus/etc/targets
NODEIP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

if [[ ! -e $TARGET_DIR/${NODEIP}.yml ]]; then
  sudo /bin/cp -v $TARGET_DIR/node.yml.tmpl $TARGET_DIR/${NODEIP}.yml \
  && sudo sed -i -e "s/X.X.X.X/${NODEIP}/" $TARGET_DIR/${NODEIP}.yml
fi

# End of file, if this is missing the file is truncated
##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##

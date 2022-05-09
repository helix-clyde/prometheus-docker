#!/usr/bin/env bash

# for a node to create it's own configuration
set -x

CONF_DIR=/efs/monitoring/prometheus/etc
DATA_DIR=/var/lib/prometheus
NODEIP="$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"

# set up prometheus config with correct ip address
if [[ -e "$CONF_DIR/prometheus.yml.tmpl" ]]; then
         sudo /bin/cp -v "$CONF_DIR/prometheus.yml.tmpl" "$CONF_DIR/prometheus.yml" \
      && sudo sed -i -e "s/X.X.X.X/$NODEIP/" "$CONF_DIR/prometheus.yml"
else
  exit 404
fi

# setup data directory ensure the variable is set!!
if [[ -n "$DATA_DIR" ]]; then
    sudo mkdir -vp "${DATA_DIR}/data/" \
  && sudo chown -cR 65534.65534 "${DATA_DIR}/"
else
  echo "DATA_DIR not set"
fi

# End of file, if this is missing the file is truncated
##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##=-=##

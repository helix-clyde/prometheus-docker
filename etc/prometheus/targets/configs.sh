#!/usr/bin/env bash

set -x

TARGET_DIR=/efs/monitoring/prometheus/etc/targets/
MASTERNODE=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

for node in $(cat ~clyde.jones/nodes.txt | grep -v $MASTERNODE); do
  echo $node
  if [[ $(curl --connect-timeout 1 --fail http://$x:9100/metrics -o /dev/null) ]]; then
      /bin/cp -v $TARGET_DIR/node.yml.tmpl $TARGET_DIR/$node.yml \
      && sed -i -e "s/X.X.X.X/$node/" $TARGET_DIR/$node.yml
  fi
done

cd $TARGET_DIR

for x in $(cat $TARGET_DIR/*.yml | grep 9100 | cut -d \' -f 2 | cut -d ":" -f 1 ); do
    curl --connect-timeout 2 \
              --fail http://$x:9100/metrics \
              -o /dev/null \
    || mv -v $TARGET_DIR/$x.yml $TARGET_DIR/$x.yml.old
 done

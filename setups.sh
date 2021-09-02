#!/usr/bin/env bash

# set -x

rm -v ~/nodes.txt

for host in $(qconf -sh | sort -R ); do
  (ssh \
      -o StrictHostKeyChecking=false \
      -o ConnectTimeout=1 \
      $host \
       "sudo ~clyde.jones/prometheus-docker/nodeexporter.sh \
       ; ~clyde.jones/bin/getip.sh") \
   | grep 172\. \
   |tee -a ~/nodes.txt
done
       # sudo docker kill node-exporter; \
       # sudo docker rm node-exporter; \

# for node in $(cat ~clyde.jones/nodes.txt| grep -v 172.30.66.60); do
#   echo $node ; /bin/cp -v node.yml.tmpl $node.yml ; sed -i -e "s/X.X.X.X/$node/" $node.yml\
#   ; sleep 1
# done
#
# for x in $(cat *.yml | grep 9100 | cut -d \' -f 2 | cut -d ":" -f 1 ); do
#    echo $x \
#    ; curl --connect-timeout 2 \
#           --fail http://$x:9100/metrics 2>&1 > /dev/null \
#    || mv -v $x.yml $x.yml.old ; done

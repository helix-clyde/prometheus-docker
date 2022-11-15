#! /usr/bin/env bash

[[ $DEBUG ]] && set -x
# for container in  $(docker ps --format 'table {{ .Names }}' | grep Prometheus ) ; do docker update --cpu-shares "256" $container ; done

# docker update --cpu-shares "1024" ecs-hcluster-production-master-16-MasterTask-f6dd9ca5c0b0cfb51600
# docker update --cpu-shares "1024" ecs-hcluster-production-notebook-18-NotebookTask-c6bd95d385dfef99c801
# docker update --cpu-shares "512" ecs-hcluster-production-scale-out-ondemand-16-ScaleOutOndemandTask-f691d1bfbed6e49a6500
# docker update --cpu-shares "512" ecs-hcluster-production-scale-out-p2xl-8-ScaleOutP2xlTask-8ee290deabbe95c7d201
# docker update --cpu-shares "512" ecs-hcluster-production-scale-out-r2xl-15-ScaleOutR2xlTask-b88ee28980f1d9ec8c01
# docker update --cpu-shares "512" ecs-hcluster-production-scale-out-r2xlod-6-ScaleOutR2xlodTask-b6f6da89a8bd81c8a301
# docker update --cpu-shares "512" ecs-hcluster-production-scale-out-r4xl-15-ScaleOutR4xlTask-90968bb5b9b2eef31c00
# docker update --cpu-shares "512" ecs-hcluster-production-scale-out-r4xlod-6-ScaleOutR4xlodTask-96d3f5c6ddd28dbef501
# docker update --cpu-shares "512" ecs-hcluster-production-scale-out-rxl-15-ScaleOutRxlTask-d692add1dff0a88fe301
# docker update --cpu-shares "512" ecs-hcluster-production-scale-out-rxlod-6-ScaleOutRxlodTask-b28182c7d1cefc8b9b01
# docker update --cpu-shares "512" ecs-hcluster-production-scale-out-spot-16-ScaleOutSpotTask-acc7d4f583d5a1984e00
# docker update --cpu-shares "256" ecs-hcluster-production-db-2-InfluxDBTask-f0d6b989f4b6cae3c201
# docker update --cpu-shares "256" ecs-hcluster-production-grafana-2-Grafana-98f2d5f1f4badea82600
# docker update --cpu-shares "256" ecs-hcluster-production-prometheus-1-Prometheus-96baeb84d6e4b1e70300
# docker update --cpu-shares "256" ecs-hcluster-production-prometheus-agent-1-PrometheusAgent-a48fead2b3a1f486a001
# docker update --cpu-shares "128" ecs-hcluster-production-cron-16-CronTask-cc92d09bf9eb87ee1300

for container in $(docker ps --format 'table {{ .Names }}' | egrep "Prometheus|grafana|Influx" ) ;
do
 docker update --cpu-shares "384" $container
done

for container in $(docker ps --format 'table {{ .Names }}' | egrep "MasterTask|NotebookTask" ) ;
do
 docker update --cpu-shares "1024" $container
done

for container in $(docker ps --format 'table {{ .Names }}' | egrep "ScaleOut" ) ;
do
 docker update --cpu-shares "384" $container
done

for container in $(docker ps --format 'table {{ .Names }}' | egrep "CronTask" ) ;
do
 docker update --cpu-shares "128" $container
done

for container in $(docker ps --format '{{ .Names }}');
do
   echo -en $container 
   docker inspect $container | grep -i cpushares | tr -s ' \",:' '\t'
done \
| pr -t -e30 -


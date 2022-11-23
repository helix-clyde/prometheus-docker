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

CPU_SHARE=$(( $(grep -c processor /proc/cpuinfo) * 1024 ))

MAIN_SHARE=$(( CPU_SHARE / 8 ))
CLIENT_SHARE=$(( CPU_SHARE / 16 ))
MON_SHARE=$(( CPU_SHARE / 20 ))
SCALE_OUT_SHARE=$(( CPU_SHARE / 21 ))
CRON_SHARE=$(( CPU_SHARE / 32 ))

ALLOCATED_SHARE=0

for container in $(docker ps --format '{{ .Names }}' | grep -E "Prometheus|grafana|Influx" ) ;
do
 [[ $DEBUG ]] || docker update --cpu-shares $MON_SHARE "$container"
 [[ $DEBUG ]] && echo $CPU_SHARE $MON_SHARE "$container"
 ALLOCATED_SHARE=$(( ALLOCATED_SHARE + MON_SHARE ))
 echo $ALLOCATED_SHARE spent of $CPU_SHARE
done

for container in $(docker ps --format '{{ .Names }}' | grep -E "MasterTask|NotebookTask" ) ;
do
 [[ $DEBUG ]] || docker update --cpu-shares "$MAIN_SHARE" "$container"
 [[ $DEBUG ]] && echo $CPU_SHARE $MAIN_SHARE "$container"
 ALLOCATED_SHARE=$(( ALLOCATED_SHARE + MAIN_SHARE ))
 echo $ALLOCATED_SHARE spent of $CPU_SHARE
done

for container in $(docker ps --format '{{ .Names }}' | grep -E "ScaleOut|ScaleIn|ge-exec" ) ;
do
 [[ $DEBUG ]] || docker update --cpu-shares "$SCALE_OUT_SHARE" "$container"
 [[ $DEBUG ]] && echo $CPU_SHARE "$SCALE_OUT_SHARE" "$container"
 ALLOCATED_SHARE=$(( ALLOCATED_SHARE + SCALE_OUT_SHARE ))
 echo $ALLOCATED_SHARE spent of $CPU_SHARE
done

for container in $(docker ps --format '{{ .Names }}' | grep -E "CronTask" ) ;
do
 [[ $DEBUG ]] || docker update --cpu-shares "128" "$container"
 [[ $DEBUG ]] && echo $CPU_SHARE "$CRON_SHARE" "$container"
 ALLOCATED_SHARE=$(( ALLOCATED_SHARE + CRON_SHARE ))
 echo $ALLOCATED_SHARE spent of $CPU_SHARE
done

for container in $(docker ps --format '{{ .ID }}\t{{ .Image }}' | grep -E "hcluster2-notebook:client" | cut -f 1 ) ;
do
 [[ $DEBUG ]] || docker update --cpu-shares "$CLIENT_SHARE" "$container"
 [[ $DEBUG ]] && echo $CPU_SHARE "$CLIENT_SHARE" "$container"
 ALLOCATED_SHARE=$(( ALLOCATED_SHARE + CLIENT_SHARE ))
 echo $ALLOCATED_SHARE spent of $CPU_SHARE
done

echo "-------------------------"
for container in $(docker ps --format '{{ .Names }}');
do
   echo -en "$container" 
   docker inspect "$container" | grep CpuShares | tr -s ' \",:' '\t'
done \
| /efs/home/clyde.jones/.local/bin/datamash -g 1 sum 3 \
| pr -t -e30 -
# for container in $(docker ps --format '{{ .Names }}'); do    echo -en "$container" ;    docker inspect "$container" | grep CpuShares | tr -s ' \",:' '\t'; done | datamash -g 1 sum 3 | pr -t -e29 -



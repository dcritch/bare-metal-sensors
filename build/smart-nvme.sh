#!/usr/bin/env bash

INTERVAL="${COLLECTD_INTERVAL:-60}"
DEV=nvme0n1

if [[ ! -e /dev/$DEV ]]; then
    echo /dev/$DEV not exist
    exit 1
fi

while sleep $INTERVAL; do
  for metric in $(sudo /usr/sbin/nvme smart-log /dev/$DEV 2>&1| grep -v 'Smart Log' | grep ':' | tr '[A-Z]' '[a-z]'  | sed -e 's/: /:/g' | tr ' ' '_'  | sed -e 's/^\(\w*\)\W*:\(.*\)/\1:\2/g' | sed -e 's/_c$\|%//g'); do
    #echo $metric
    measurement=$(echo $metric | awk -F: '{print $1}')
    value=$(echo $metric | awk -F: '{print $2}')
    #echo PUTVAL $HOSTNAME/exec-$DEV/gauge-$measurement interval=$INTERVAL N:$value
    echo "PUTVAL \"$HOSTNAME/exec-$DEV/gauge-$measurement\" interval=$INTERVAL N:$value"
  done
done

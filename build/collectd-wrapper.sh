#!/usr/bin/env bash

mkdir -p /tmp/collectd-hostname
echo Hostname \""$HOSTNAME"\" > /tmp/collectd-hostname/hostname.conf
/usr/sbin/collectd -f

# bare-metal-sensors
Gather Bare-metal Sensor Data From An OpenShift Cluster

## Problem
You are running an OpenShift cluster on bare-metal. The metrics and dashboards you get for monitoring your hosts are awesome, but doesn't include any temperature/lm_sensor type data.

## Solution
Run a DaemonSet on your cluster to gather those metrics and ship off to your own monitoring system (e.g. InfluxDB).

## Details

This repo contains tools to build a container image with collectd with the sensors plug-in, along with a custom script to pull S.M.A.R.T. date from an NVMe drive. It also has some YAML to setup the DaemonSet to run on all the nodes of your cluster. Works fine on OpenShift. Possibly also fine on vanilla kubernetes.

## Usage

Modify `yaml/config-map-include.yml` to point to your existing InfluxDB server, then run the following:

~~~
oc new-project bare-metal-sensors
oc apply -f yaml/service-account.yml
oc apply -f yaml/cluster-role-binding.yml
oc apply -f yaml/config-map-include.yml
oc apply -f yaml/daemon-set.yml
~~~

If you're not running InfluxDB, play around with the configmap to suit your purposes and have at it.

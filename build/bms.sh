#!/bin/bash

set -ex

FULL="${1:-false}"

if [[ $FULL == 'true' ]]; then
  container=$(buildah from registry.redhat.io/ubi8/ubi)
  echo "building container with id $container"
  buildah config --label maintainer="David Critch <dcritch@gmail.com>" $container
  buildah run $container dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
  #buildah run $container dnf -y install lm_sensors nvme-cli collectd collectd-disk collectd-sensors collectd-write_prometheus collectd-smart smartmontools sudo
  buildah run $container dnf -y install lm_sensors nvme-cli collectd collectd-sensors collectd-write_prometheus sudo
  buildah commit --format docker $container bms-base:latest
fi

container=$(buildah from bms-base:latest)
echo "building container with id $container"
buildah commit --format docker $container bms-base:latest
buildah run $container useradd nvme-sensors
buildah copy $container nvme-sensors.sudo /etc/sudoers.d/nvme-sensors
buildah copy $container ./collectd.conf /etc/collectd.conf
buildah copy $container collectd-wrapper.sh /opt/collectd-wrapper.sh
buildah copy $container smart-nvme.sh /opt/smart-nvme.sh
#buildah config --entrypoint /opt/collectd-wrapper.sh $container
buildah commit --format docker $container bms:latest
buildah tag localhost/bms:latest $REGISTRY/bare-metal-sensors/bms:latest
buildah login -u $(oc whoami) -p $(oc whoami -t) $REGISTRY
buildah push $REGISTRY/bare-metal-sensors/bms:latest

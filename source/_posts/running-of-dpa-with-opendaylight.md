layout: running
title: Running OF-DPA with OpenDayLight
date: 2017-10-03 09:24:30
tags:
---

## Environment
- Ubuntu 14.04.5
- OpenDayLight
  - [Carbon SR1][2]
- OF-DPA


## Prepare Java 8 Environment
```
apt-add-repository ppa:webupd8team/java
apt update -y
apt install -y oracle-java8-installer
```

## Download OpenDayLight - Carbon version
```
wget https://nexus.opendaylight.org/content/repositories/public/org/opendaylight/integration/distribution-karaf/0.6.1-Carbon/distribution-karaf-0.6.1-Carbon.tar.gz
tar xvf distribution-karaf-0.6.1-Carbon.tar.gz
```

## Running OpenDayLight
```
cd distribution-karaf-0.6.1-Carbon
./bin/karaf
```

## Enable OpenFlow Plugin
```
feature:install odl-openflowplugin-app-lldp-speaker-he
feature:install odl-openflowplugin-flow-services-rest-he
feature:install odl-openflowplugin-flow-services-ui-he
feature:install odl-dluxapps-applications

```

## References]
- [Installing OpenDaylight - OpenDayLight Documentation][1]
- [Download - OpenDayLight Documentation][2]
- [OpenFlow Plugin Project User Guide - OpenDayLight Documentation]][3]

[1]: http://docs.opendaylight.org/en/stable-carbon/getting-started-guide/installing_opendaylight.html
[2]: https://www.opendaylight.org/technical-community/getting-started-for-developers/downloads-and-documentation
[3]: http://docs.opendaylight.org/en/stable-boron/user-guide/openflow-plugin-project-user-guide.html
---
layout: post
title:  "OF-DPA with ONL Cheat Sheet"
date:   2017-01-04 10:42:10 +0800
updated: 2017-01-04 00:00:00 +0800
category: sdn 
tags:
- cicada
- onl
- ofdpa
---

## Environment
- Hardware
  - Model
    - [Edgecore AS5712-54X](http://www.edge-core.com/productsInfo.php?cls=1&cls2=8&cls3=44&id=15)
- Software
  - ONL version
    - [ONL-2.0.0-ONL-OS-DEB8-2016-12-22.1828-604af0c-AMD64-INSTALLED-INSTALLER](http://opennetlinux.org/binaries/2016.12.22.18.28.604af0c9b3dc9504870c30273ab22f2fb62746c3/ONL-2.0.0-ONL-OS-DEB8-2016-12-22.1828-604af0c-AMD64-INSTALLED-INSTALLER)
  - OF-DPA version 
    - [ofdpa_3.0 EA3](https://github.com/onfsdn/atrium-docs/blob/master/16A/ONOS/builds/ofdpa_3.0.3.1%2Baccton1.4~1-1_amd64.deb)

### Set Base configuration
- vi /mnt/onl/data/rc.boot 
- ```bash
#!/bin/bash
ip addr add 192.168.11.2/24 dev ma1
ip route add default via 192.168.11.254
hostname edgecore-5712
echo "nameserver 168.95.1.1" > /etc/resolvconf/resolv.conf.d/base
resolvconf -u
``` 
- chmod +x /mnt/onl/data/rc.boot
  - rc script: `/etc/boot.d/52.rc.boot`

### Rate Limit
- Setting Rate Limit per queue 
  - `client_queue_config <queueId> <intIfNum> <minRate> <maxRate>` 
    - queyeID := [ 0 - 7 ] 
  - ex: `client_queue_config 0 2 1 1000` 
    - Queue 0, Port 2, 最小速率 1 Mbps, 最大 1000 Mbps 
- Show Rate Limit per queue 
  - `client_queue_config <queueId> <intIfNum>` 
  - ex: `client_queue_config 1 1` 
    - 顯示 Queue 1, Port 1 最小/最大速率 

### OF Agent App
- Enable ofagentapp service
  - `launcher ofagentapp --controller=<CONTROLLER_IP>:6653 --listen=<SWITCH_MA1_IP>:6633`
  - Example: [start_ofagentapp.sh](https://gist.github.com/pichuang/7f35e6313f0339ac7fff96af3832d8d2)
- Stop ofagentapp
  - `pkill ofagentapp`

### Port Speed
- Change Port Speed per Port

```bash
vi /etc/ofdpa/accton.conf
...
# port_speed_<port>= Speed
# Speed := { 1000 | 10000 | 40000 }
...
# Default value in AS5712-54X is port_speed=10000
port_speed_3=1000   # front port 3
port_speed_4=10000   # front port 4
...
```
- Change Port Mode per Port
```bash
vi /etc/ofdpa/accton.conf
...
# port_mode_<port> = Speed_Type [Interface Type]
# Speed_Type:= { 1x40g | 4x10g }
# Interface Type := { CR | CR4 | SR | SR4 | LR | LR4 | KR | KR4 | SFI | XFI | ... }
...
port_mode_1=1x40g
port_mode_2=1x40g if=SR4
port_mode_3=4x10g #Breakout cable
...
```

### Dump BRCM Informations
- Dump Port Table
  - `client_port_table_dump`
- Dump Meter Table
  - `client_meter_dump`
- Dump Flow Table
  - `client_flowtable_dump`
- Dump Group Table
  - `client_grouptable_dump`
- Dump Tunnel
  - `client_tunnel_dump`
- Dump OAM
  - `client_oam_dump`
- Dump Class Color Table
  - `client_classcolortable_dump` 

### BRCM Diag Shell with ONL
- NOTE: Please launch `ofagentapp` first in backaground
- Show processes status
  - `client_drivshell ps`
- Show port config
  - `client_drivshell port <port_number>`
- Show usage command
  - `client_drivshell help` 
- Redirect log to other devices (ex: /dev/console)
  - `client_drivshell log f=/dev/console`

### NOS Information
- Show Platform Information with ONL
  - `onl-platform-show`
- Show sysconfig with ONL
  - `onl-sysconfig`

### Mount Disk
- Change w/r permission on disk
  1. `vi /etc/mtab.yml`
  2. `onl-mount mount all`
- Check mount status
  - `mount`
- Check partition status
  - `df -h`

### ONL Platform Information
- Show ONL information for human read 
  - `onlpdump -r`
- Show Hardware information
  - `onlpdump -s`
- Show SFP information
  - `onlpdump -S`

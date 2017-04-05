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
- sdn
---

## Environment
- Hardware
  - Model
    - [Edgecore AS5712-54X](http://www.edge-core.com/productsInfo.php?cls=1&cls2=8&cls3=44&id=15)
- Software
  - ONL version
    - [ONL-2.0.0-ONL-OS-DEB8-2016-12-22.1828-604af0c-AMD64-INSTALLED-INSTALLER](http://opennetlinux.org/binaries/2016.12.22.18.28.604af0c9b3dc9504870c30273ab22f2fb62746c3/ONL-2.0.0-ONL-OS-DEB8-2016-12-22.1828-604af0c-AMD64-INSTALLED-INSTALLER)
  - OF-DPA version 
    - [ofdpa_3.0 EA4](https://github.com/onfsdn/atrium-docs/raw/1f6cd3fe6d5f79fb2eab54ce6c916c22a3d6a551/16A/ONOS/builds/ofdpa_3.0.4.0%2Baccton1.0~1-1_amd64.deb)

### Set Base configuration
1. vi /etc/network/interfaces
```bash
auto ma1
iface ma1 inet static
address 192.168.11.2
netmask 255.255.255.0
gateway 192.168.11.254
```
 
2. vi /etc/resolvconf/resolv.conf.d/base
```
nameserver 168.95.1.1
```
- `resolvconf -u`


### Rate Limit
- Setting Rate Limit per queue 
  - `client_queue_config <queueId> <intIfNum> <minRate> <maxRate>` 
    - queyeID := [ 0 - 7 ] 
  - ex: `client_queue_config 0 2 1 1000` 
    - Queue 0, Port 2, 1 means minimal 0.1%, 1000 means Maximum 100%
    - Min and Max queue rates must range between 1-1000 
- Show Rate Limit per queue 
  - `client_queue_config <queueId> <intIfNum>` 
  - ex: `client_queue_config 1 1` 
    - 顯示 Queue 1, Port 1 最小/最大速率 

### OF Agent App
- Enable ofagentapp service
  - `launcher ofagentapp --controller=<CONTROLLER_IP>:6653 --listen=<SWITCH_MA1_IP>:6633`
  - More detailes [How to enable debugging mode on OF-DPA][2]
- Stop ofagentapp
  - `pkill ofagentapp`

### Port Speed
- Change Port Speed per Port
  - vi /etc/accton/ofdpa.conf
```bash
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
  - vi /etc/accton/ofdpa.conf
```bash
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
    - You can use command `tty` to find your teletype device name currently.

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

## Flow tables ID (OF-DPA 3.0.3)

|Table Name | Table ID|
|-----------|---------|
|Ingress Port | 0 |
|Port DSCP Trust | 5|
|Port PCP Trust | 6|
|Tunnel DSCP Trust | 7|
|Tunnel PCP Trust | 8|
|Injected OAM| 9|
|VLAN | 10|
|VLAN 1 | 11|
|Ingress Maintenance Point | 12|
|MPLS L2 Port | 13|
|MPLS DSCP Trust | 15|
|MPLS PCP Trust | 16|
|L2 Policer | 18|
|L2 Policer Actions | 19|
|Termination MAC | 20|
|L3 Type| 21|
|MPLS 0 | 23|
|MPLS 1 | 24|
|MPLS 2 | 25|
|MPLS-TP Maintenance Point | 26|
|MPLS L3 Type| 27|
|MPLS Label Trust | 28|
|MPLS Type | 29|
|Unicast Routing | 30|
|Multicast Routing | 40|
|Bridging | 50|
|Policy ACL | 60|
|Color Based Actions | 65|
|Egress VLAN | 210|
|Egress VLAN 1 | 211|
|Egress Maintenance Point| 226|
|Egress DSCP PCP Remark | 230|
|Egress TPID | 235|

## Reference
- [OF-DPA文档读后感][1]
- [How to enable debugging mode on OF-DPA][2]

[1]: http://www.lai18.com/content/9682257.html
[2]: https://edge-core.github.io/How-to-enable-debugging-mode-on-OF-DPA/
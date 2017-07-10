---
layout: post
title: Running RoCE over L2 Network Enabled with PFC via Mellanox
date: 2017-06-26 15:03:25
updated: 2017-06-26 15:03:25
category:
tags:
- roce
- mlx
- pfc
---

<!--more-->
## Goals
- Follow [HowTo Run RoCE and TCP over L2 Enabled with PFC (2016)][7]
- 2 Hosts use 1 network (VLAN 100) for all traffic
- Each host runs two traffic flows as below:
  - RoCE Flow (bypass the kernel)
    - Priority 4 is enabled and used for the RoCE application only.
  - TCP Flow (pass via the kernel)
    - TCP will be sent over priority 0


## Environment
- mlx-1.on.ec
  - Ubuntu 14.04.3 
  - Mellanox ConnectX-3 Adapter 10GbE
    - Make sure you have the latest version of [`MLNX-OFED`][4] installed, instead of `MLNX_EN`
  - VLAN 100 IP: 172.16.100.1/24
- mlx-2.on.ec
  - Ubuntu 14.04.3 
  - Mellanox ConnectX-4 Adapter 10GbE
    - Make sure you have the latest version of [`MLNX-OFED`][4] installed, instead of `MLNX_EN`
  - VLAN 100 IP: 172.16.100.2/24
- Switch
  - BigSwitch BCF / Cumulus Linux / PicOS

## Install OFED Driver
```bash
apt install -y gfortran make flex swig tk8.4 python-libxml2 libnl1 tcl8.4 autoconf dkms bison dpatch chrpath gcc libgfortran3 graphviz tk automake pkg-config autotools-dev quilt m4 tcl debhelper libltdl-dev
tar zxvf MLNX_OFED_LINUX-4.0-2.0.0.1-ubuntu14.04-x86_64.tgz
cd ./MLNX_OFED_LINUX-4.0-2.0.0.1-ubuntu14.04-x86_64/
./mlnxofedinstall
/etc/init.d/openibd restart
update-rc.d openibd defaults
```


## Enable PFC on Priority 4
```bash
echo "options mlx4_en pfctx=0x10 pfcrx=0x10" >> /etc/modprobe.d/mlx4_en.conf
/etc/init.d/openibd restart
RX=`cat /sys/module/mlx4_en/parameters/pfcrx`;printf "0x%x\n" $RX
```
- 0x10 = 00010000, which means that only priority 4 is enabled on that host

## Create VLAN 100 Interface and IP
```bash
echo "8021q" >> /etc/modules
modprobe 8021q
apt install -y vlan
vconfig add p3p1 100
ifconfig p3p1 up
ifconfig p3p1.100 172.16.100.1/24 up
```

## Set Egress Priority

### Set Egress Priority 0 for TCP Traffic
```bash
for i in {0..7}; do vconfig set_egress_map p3p1.100 $i 0 ; done
```

### Set Egress Priority 4 for RoCE Traffic
```bash
tc_wrap.py -i p3p1 -u 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
```
- RoCE traffic bypasses the kernel, so `vconfig` commands or other kernel related commands will not work.
- There are up to 16 skpio (kernel priorities) to be mapped to the L2 priorities (UP). In these cases we map all the priorities to L2 priority 4.

### Output
```bash
$ for i in {0..7}; do vconfig set_egress_map p3p1.100 $i 0 ; done
Set egress mapping on device -:p3p1.100:- Should be visible in /proc/net/vlan/p3p1.100
Set egress mapping on device -:p3p1.100:- Should be visible in /proc/net/vlan/p3p1.100
Set egress mapping on device -:p3p1.100:- Should be visible in /proc/net/vlan/p3p1.100
Set egress mapping on device -:p3p1.100:- Should be visible in /proc/net/vlan/p3p1.100
Set egress mapping on device -:p3p1.100:- Should be visible in /proc/net/vlan/p3p1.100
Set egress mapping on device -:p3p1.100:- Should be visible in /proc/net/vlan/p3p1.100
Set egress mapping on device -:p3p1.100:- Should be visible in /proc/net/vlan/p3p1.100
Set egress mapping on device -:p3p1.100:- Should be visible in /proc/net/vlan/p3p1.100

$ tc_wrap.py -i p3p1
# This section is due to the vconfig set_egress_map (kernel flow).
UP  0
        skprio: 0 (vlan 100)
        skprio: 1 (vlan 100)
        skprio: 2 (vlan 100 tos: 8)
        skprio: 3 (vlan 100)
        skprio: 4 (vlan 100 tos: 24)
        skprio: 5 (vlan 100)
        skprio: 6 (vlan 100 tos: 16)
        skprio: 7 (vlan 100)
UP  1
UP  2
UP  3
UP  4
UP  5
UP  6
UP  7

$ tc_wrap.py -i p3p1 -u 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
# This section is due to the tc_wrap script (kernel bypass flow) with RoCE
skprio2up is available only for RoCE in kernels that don't support set_egress_map
Traffic classes are set to 8
UP  0
        skprio: 0 (vlan 100)
        skprio: 1 (vlan 100)
        skprio: 2 (vlan 100 tos: 8)
        skprio: 3 (vlan 100)
        skprio: 4 (vlan 100 tos: 24)
        skprio: 5 (vlan 100)
        skprio: 6 (vlan 100 tos: 16)
UP  1
UP  2
UP  3
UP  4
        skprio: 0
        skprio: 1
        skprio: 2 (tos: 8)
        skprio: 3
        skprio: 4 (tos: 24)
        skprio: 5
        skprio: 6 (tos: 16)
        skprio: 7
        skprio: 8
        skprio: 9
        skprio: 10
        skprio: 11
        skprio: 12
        skprio: 13
        skprio: 14
        skprio: 15
UP  5
UP  6
UP  7
```


## References
- [Running RoCE over L2 Network Enabled with PFC][1]
- [RDMA/RoCE Solutions][2]
- [Mellanox OFED for Linux User Manual][3]
- [Mellanox OpenFabrics Enterprise Distribution for Linux (MLNX_OFED)][4]
- [RDMA and RoCE for Network Efficiency and Performance][5]
- [How To Configure Lossless RoCE (PFC + ECN) End-to-End Using ConnectX-4 and Spectrum (Trust L2)][6]
- [HowTo Run RoCE and TCP over L2 Enabled with PFC (2016)][7]

[1]: http://www.mellanox.com/related-docs/prod_software/RoCE_with_Priority_Flow_Control_Application_Guide.pdf
[2]: https://community.mellanox.com/docs/DOC-2283
[3]: http://www.mellanox.com/related-docs/prod_software/Mellanox_OFED_Linux_User_Manual_v4.0.pdf
[4]: http://www.mellanox.com/page/products_dyn?product_family=26&mtag=linux_sw_drivers
[5]: http://www.mellanox.com/page/products_dyn?product_family=79&mtag=roce
[6]: https://community.mellanox.com/docs/DOC-2733
[7]: https://community.mellanox.com/docs/DOC-2482
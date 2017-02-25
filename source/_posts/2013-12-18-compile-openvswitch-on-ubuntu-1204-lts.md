---
layout: post
title: '編譯 OpenvSwitch v2.1.3 on Ubuntu 12.04 LTS'
date: 2013-12-18 06:00
comments: true
categories: 
---

# 更新記錄
* Upgrade: 2014/08/15 [編譯 OpenvSwitch v2.3.0 on Ubutnu 14.04.1 LTS](http://roan.logdown.com/posts/220671-compile-openvswitch-v230-on-ubutnu-14041-lts)
* Update: 2014/08/15 Upgrade to OpenvSwitch 2.1.3
* Update: 2014/05/03 [Upgrade to OpenvSwitch 2.1.2](http://openvswitch.org/releases/NEWS-2.1.2)
* Update: 2014/04/30 [Upgrade to OpenvSwitch 2.1.1](http://openvswitch.org/releases/NEWS-2.1.1)
* Update: 2014/04/26 Add boot network interface setting
* Update: 2014/03/31 [Upgrade to OpenvSwitch 2.1.0](http://openvswitch.org/releases/NEWS-2.1.0)

# 安裝過程
## 環境
  - OS: Ubuntu 12.04.4 Server LTS X86_64 
  - Kernel version:  3.11.0-20-generic

## 預先安裝
> aptitude install dh-autoreconf libssl-dev openssl

## 編譯 OpenvSwitch
> wget http://openvswitch.org/releases/openvswitch-2.1.3.tar.gz  
tar zxvf openvswitch-2.1.3.tar.gz && cd openvswitch-2.1.3  
./boot.sh  
./configure --with-linux=/lib/modules/`uname -r`/build  
make -j && sudo make install  
sudo make modules_install  
sudo modprobe gre  
sudo modprobe openvswitch  
sudo modprobe libcrc32c  

  * 使用 ```lsmod |grep openvswitch``` 確認ovs正確地掛載起來
  * ./configure 部份其實還可以下一個 ```--prefix=``` 參數, 可以讓openvswitch 完全裝在該目錄底下而不會亂掉

## 設定 ovsdb
> ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema

  * 建立一次即可, 如果設定有問題的話可以把conf.db砍掉重建

## (二選一) 開啟 ovsdb-server (no ssl)
> ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \  
--remote=db:Open_vSwitch,Open_vSwitch,manager_options \  
--pidfile --detach --log-file  

  * ```cat /usr/local/var/log/openvswitch/ovsdb-server.log``` 可查到 ovsdb log 

## (二選一) 開啟 ovsdb-server (ssl)
> ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \  
--remote=db:Open_vSwitch,Open_vSwitch,manager_options \  
--private-key=db:Open_vSwitch,SSL,private_key \  
--certificate=db:Open_vSwitch,SSL,certificate \  
--bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \ 
--pidfile --detach --log-file  

  * 若要使用 ssl 連線, 務必在編譯前要先準備好 ```libssl-dev``` 及 ```openssl```, 否則會噴出 ```Private key specified but Open vSwitch was built without SSL support``` 的錯誤
  * [OpenvSwitch Lab 6$ TLS SSL](http://roan.logdown.com/posts/208707-openvswitch-lab-6-ssl)

## 開啟 ovs-vsctl 
> ovs-vsctl --no-wait init

## 開啟 ovs-switchd 功能
> ovs-vswitchd --pidfile --detach --log-file

  * ```/usr/local/var/log/openvswitch/ovs−vswitchd.log``` 可查到 ovs-vswitchd log

### 觀察
* ```ps aux |grep ovs```

<img class="center" src="http://user-image.logdown.io/user/5820/blog/5842/post/165399/C7SX9zsQQNOyIRBntqXb_ovs.png" alt="ovs_install_complete.png">


## 開機自動化
### 設定開機自動 load module 
> echo "openvswitch " >> /etc/modules  
echo "gre" >> /etc/modules  
echo "libcrc32c" >> /etc/modules  

### 設定開機自動啟動
1. vim /etc/init.d/openvswitch

> \#!/bin/sh  
start-stop-daemon -q -S -x /usr/local/sbin/ovsdb-server -- --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,Open_vSwitch,manager_options --pidfile --detach --log-file  
sleep 3 # waiting ovsdb-server  
start-stop-daemon -q -S -x /usr/local/bin/ovs-vsctl -- --no-wait init  
start-stop-daemon -q -S -x /usr/local/sbin/ovs-vswitchd -- --pidfile --detach --log-file  

2.

> chmod +x /etc/init.d/openvswitch

3.

> update-rc.d -f openvswitch defaults

### 設定 interface
1. ovs-vsctl add-br ovs-br

2. vim /etc/network/interfaces
> \# The loopback network interface  
auto lo  
iface lo inet loopback  
\# The primary network interface  
auto eth0  
iface eth0 inet manual  
up ifconfig $IFACE 0.0.0.0 up  
down ifconfig $IFACE down  
\# OpenvSwitch Interface  
auto ovs-br  
iface ovs-br inet static  
address x.x.x.x  
netmask 255.255.255.0  
gateway o.o.o.o  
dns-nameservers 168.95.1.1  

### 修改 Failsafe
vim /etc/init/failsafe.conf
> $PLYMOUTH message --text="Waiting for network configuration..." || :  
sleep 1  
$PLYMOUTH message --text="Waiting up to 60 more seconds for network configuration..." || :  
sleep 1  
$PLYMOUTH message --text="Booting system without full network configuration..." || :  

# OpenvSwitch kernel 支援列表

   Open vSwitch  | Linux kernel
   ------------  | -------------
       1.4.x     | 2.6.18 to 3.2
       1.5.x     | 2.6.18 to 3.2
       1.6.x     | 2.6.18 to 3.2
       1.7.x     | 2.6.18 to 3.3
       1.8.x     | 2.6.18 to 3.4
       1.9.x     | 2.6.18 to 3.8
       1.10.x    | 2.6.18 to 3.8
       1.11.x    | 2.6.18 to 3.8
       2.0.x     | 2.6.32 to 3.10
       2.1.x     | 2.6.32 to 3.11
       2.2.x     | 2.6.32 to 3.13

# 小計
1. ovs 2.1.0 已支援 Linux kernel 3.10 以上 
2. 如果沒有 /lib/modules/x.x.x/build 資料夾, 找一下關鍵字 "linux-header"
3. ~~12.04.4 kernel 太新了, 要降級. 參考: [Ubuntu 12.04 LTS Kernel 降級](http://roan.logdown.com/posts/183081-ubuntu-1204-lts-kernel-downgrade)~~
4. [設定OpenvSwitch](http://roan.logdown.com/posts/191801-set-openvswitch)
5. [OpenvSwitch OverView - hwchiu](http://hwchiu.logdown.com/posts/167510-openvswitch-overview)
6. [OpenVSwitch - NSRC](https://nsrc.org/workshops/2014/nznog-sdn/raw-attachment/wiki/Agenda/OpenVSwitch.pdf)


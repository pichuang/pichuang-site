---
layout: post
comments: true
title: "Build ONOS Cluster"
description: "Detail of Building ONOS Cluster"
category: sdn
tags: [sdn, onos]
---

#### History
2017/01/09: Update to 1.8.0 version

## 前言
雖然之前有寫過 [ONOS on CentOS7](https://blog.pichuang.com.tw/onos-on-centos7)，但因為開發上還是在 MAC OSX 上較為易用，故另開一篇紀錄個人的使用過程

## 目標
從 MAC OSX 上針對 ONOS 1.5.0 Falcon 版本做編譯後，部署至 ONOS1, ONOS2 Machine 上組成一個 ONOS Cluster

## Enviroment
- Build Machine
  - MAC OSX 10.12.1
  - Java 1.8.0
  - Apache Karaf 3.0.5
  - Apache Maven 3.3.9
  - Misc
    - IP: 10.211.55.2
    - Cell name: pichuang
- ONOS1 Machine
  - Ubuntu 14.04
  - Java 1.8.0
  - User/Group: sdn/sdn
  - IP: 10.211.55.10
- ONOS2 Machine
  - Ubuntu 14.04
  - Java 1.8.0
  - User/Group: sdn/sdn
  - IP: 10.211.55.11

### Install Oracle Java 8 on Build Machine, ONOS1 and ONOS2
{% highlight shell %}
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
sudo apt-get install oracle-java8-installer oracle-java8-set-default -y
{% endhighlight %}
* For ONOS1 and ONOS2


### Prepare Installation Enviroment of ONOS
{% highlight shell %}
cd ~/ && mkdir Downloads Applications
cd Downloads
wget http://archive.apache.org/dist/karaf/3.0.5/apache-karaf-3.0.5.tar.gz
wget https://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar -zxvf apache-karaf-3.0.5.tar.gz -C ../Applications/
tar -zxvf apache-maven-3.3.9-bin.tar.gz -C ../Applications/
{% endhighlight %}

### Setting .bashrc
{% highlight shell %}
cat >> ~/.bashrc << EOF
export ONOS_ROOT=~/onos
source $ONOS_ROOT/tools/dev/bash_profile
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export ONOS_CELL=pichuang # Change your cell name
cell $ONOS_CELL
EOF
{% endhighlight %}
- In build machine

### Compile ONOS Source Code
{% highlight shell %}
cd ~/ && git clone https://github.com/opennetworkinglab/onos
cd ~/onos && git checkout onos-1.8
source ~/.bashrc
tools/build/onos-buck build onos --show-output
{% endhighlight %}
- You will get the ONOS package in `buck-out/gen/tools/package/onos-package/onos.tar.gz`
- Run the ONOS service with debug mode. `tools/build/onos-buck run onos-local -- clean debug`
- Attach to ONOS CLI `tools/test/bin/onos localhost`

### Create a cell definition
{% highlight shell %}
cat >> ~/onos/tools/test/cells/pichuang << EOF
# Cell name
export ONOS_CELL=pichuang

# IP addresses of the VMs hosting ONOS instances. More OC instances may be set, if necessary.
export OC1="10.211.55.10"
export OC2="10.211.55.11"

# The default target node IP. This is an alias for OC1.
export OCI="10.211.55.10"

# The ONOS apps to load at startup
export ONOS_APPS="drivers,openflow,fwd,proxyarp"

# Pattern to specify which address to use for inter-ONOS node communication (not used with single-instance core)
export ONOS_NIC="10.211.55.*"

# User
export ONOS_USER=sdn # Change your username
export ONOS_GROUP=sdn # Change your group name

# WEB User
export ONOS_WEB_USER=onos
export ONOS_WEB_PASS=rocks
EOF

cell pichuang
{% endhighlight %}
* 請依據自己的需求, 更改裡面的 value,
* ```ONOS_USER/ONOS_GROUP``` 是指 ONOS1, ONOS2 運行 ONOS 的 Linux User/Group, 並非是 Build Machine 內的
* ```ONOS_WEB_USER/ONOS_WEB_PASS``` 是指 ONOS1, ONOS2 運行 ONOS 內於 ```~/Applications/apache-karaf-3.0.5/etc/users.properties``` 所設定好的帳號密碼, 只要有關 RESTful API 的存取, 皆是使用這組帳密
* 每次要 Deploy 的時候, 建議都在跑一次 ```cell $ONOS_CELL``` 確定變數有載入到環境

### SSH Login Without Password
{% highlight shell %}
# Login via SSH from build machine to ONOS1 machine
ssh-copy-id -i ~/.ssh/id_rsa.pub sdn@10.211.55.10

# Login via SSH from build machine to ONOS2 machine
ssh-copy-id -i ~/.ssh/id_rsa.pub sdn@10.211.55.11
{% endhighlight %}

### Deploy ONOS Package
{% highlight shell %}
stc setup
{% endhighlight %}
* 如果對 ```stc setup``` 感到興趣的話, 可以參考 ```$ONOS_ROOT/tools/test/scenarios/setup.xml``` 的內容
  * 若對 setup.xml 運行的指令有興趣, 可以參考 ```$ONOS_ROOT/tools/test/bin/``` 的 Shell Script
* ```stc setup``` ```stc startup``` ```stc shutdown``` 這三個指令建議可以都用看看

<center><img src="https://lh3.googleusercontent.com/UwYDAR59NOASmqhGEEeAKzhlWpl8VkSIHie3WuqUTvNUzbU4EDt9M2bVYh5qePOZfZDxdmVFL9729mNuekyv1kKmFL1h9YESEOCzdn1B9EjnKOLRcgmH404Ce-9MKI3rJNowEmtji6v5dRdrbRVY9Kl5-rDWmuw8Fis6PFhyFwMcfkCjrK6sLWQX3FC2Hc1B1TstqVh2An411GrjmdbVY37YAv5wuAiOYlN5wSeSDPnrnehognv8ta-ohh5pTtVNS7ls5DLyfwo9i4RSMXY3ozFTMHVwEdf475RrAkWf4s0fAYXLfzbP6u1P7frzsToY6ngn8sowxfJdsh6OdXzREve2eDXaqfdetkPBTKZEmal60ADozGCozrSQNsPMXE6mM2Z7mvzPUGlKQGNkdX_53shFOdIKIf4U_5XLS4lnV7FCEQllFrZaShEVbQ9ie6VEk7QZIFi15HGsnArnJUhk-eUKGky_cxT8wtF78lUCUd49OizygRFg7xFHaYT_f7J4mRE02IqdS4ifTm_akf7rSChGDidIaKJtvu17VQp3CaKXlMeFL_CYXfyRNYIib8PjgIMqRzCk_pP8vz-p0JHzOxD1GOFCAsg=w1342-h1025-no" width="50%" height="50%"></center><br>

### Login ONOS Cluster CLI
{% highlight shell %}
onos 10.211.55.10 # or use command `onos $OCI`
{% endhighlight %}

### Open WEB GUI
{% highlight shell %}
http://10.211.55.10:8181/onos/ui/index.html
{% endhighlight %}
* ONOS WEB User: onos
* ONOS WEB Password: rocks

### ONOS API
{% highlight shell %}
http://10.211.55.10:8181/onos/v1/docs/
{% endhighlight %}

## Reference
- [Test Environment Setup](https://wiki.onosproject.org/display/ONOS/Environment+setup+with+cells)
- [3 Steps to Perform SSH Login Without Password Using ssh-keygen & ssh-copy-id](http://www.thegeekstuff.com/2008/11/3-steps-to-perform-ssh-login-without-password-using-ssh-keygen-ssh-copy-id/)
- [Appendix A : List of ONOS Utility Scripts (onos-* scripts)](https://wiki.onosproject.org/pages/viewpage.action?pageId=1048691)
- [Building ONOS](https://wiki.onosproject.org/display/ONOS/Building+ONOS)

---
layout: post
title: Install CentOS 7 without VGA
date: 2017-07-17 10:09:00
updated: 2017-07-17 10:09:00
category:
- Infra
- Linux
tags:
- headless
- serial
- headless
- centos
---

### Remove `quiet`, append `text console=tty0 console=ttyS0,115200n8` in kernel parameter

- vim isolinux/isolinux.cfg
```bash
...

label linux$
  menu label ^Install CentOS Linux 7$
  menu default$
  kernel vmlinuz$
  append initrd=initrd.img inst.stage2=hd:LABEL=CENTOS\x207\x20X8 text console=tty0 console=ttyS0,115200n8

...
```

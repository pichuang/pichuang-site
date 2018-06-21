---
layout: post
title: NFV Tehnology - SR-IOV
date: 2018-06-12 11:41:41
category: automation
tags:
- ansible
---
# NFV 技術系列文 - SR-IOV

以 KVM 為主的虛擬化技術，現今常見的網卡虛擬化及加速技術不外乎有以下選項
- virtio
- PCI Paththrough
- DPDK
- SR-IOV
- OpenvSwitch

本篇文章將會著重在 SR-IOV 的介紹上面

## What is SR-IOV?

根據 Intel 所出的 [PCI-SIG SR-IOV Primer][1] 入門書，為了讓硬體設備資源能夠在**同一硬體**上被多個 VM 共享使用，PCI-SIG (PCI Special Interest Group) 規範出標準 Signal Root I/O Virtualzation (SR-IOV) 出來供各設備商可以遵循，普遍廣泛應用是在網卡上。

## Architecture

## 原理

功能
- PF (Physical Functions)  
指支援 SR-IOV 功能的 PCIe 設備

- VF (Virtual Functions)  
從 PF 分離出來的 PCIe 設備，只處理 I/O 功能；每一個 PF 所支援的 VF 皆有數量的限制 

## 優缺點

### 優點
- 接近原生性能
- 實現設備共享

### 缺點
- 對設備有依賴性
- 無法做 Live migration

# References
- [PCI-SIG SR-IOV Primer][1]
- [SR-IOV - SDN 指南][2]

[1]: https://www.intel.com/content/dam/doc/application-note/pci-sig-sr-iov-primer-sr-iov-technology-paper.pdf
[2]: https://feisky.gitbooks.io/sdn/linux/sr-iov.html
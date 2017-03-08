---
layout: post
title: TSCC 個人心得
date: 2014-04-16 20:21:00
updated: 2014-04-16 20:21:00
category: Event
tags:
- event
- tscc
---

## TSCC 介紹
很久以前參加過 TSCC(Taiwan Student Cluster Competiion) 比賽, 年代久遠, 趁有心情的時候來補一下兩年前的心得文. 

這比賽比兩個部分, HPL tunning 及 Application 跑分, 簡單來說就是比linux tunning, 和誰時間分配比較好, 比賽時間有限, 測資不少.
  
- HPL (High-Performance Linpack) 是一個利用 Distribution System 的特性, 使用 MPI 運算一些數據, 最後會產生出一個數值出來, 依照數值互相比較.
- Application 每年都不太一樣, 但大部分都跟科學運算脫不了關係, 這只能去參加 NCHC 的教育訓練才知道在幹嘛

## 比賽環境 (以TSCC 2014為主)
- 處理器：Intel Xeon X5570 2.93GHz *2
- 記憶體：24GB DDR3 1066
- 乙太網路介面:GbE *4
- Infiniband Card:Mellanox ConnectX QDR 40Gb/s *1
- 硬碟:SAS2 300GB *1
- GPU:NVIDIA TESLA C1060 *2

處理器 Intel Xeon X5570 廠牌的選擇可以影響到 Compiler 的選擇, 另外不要開 VT-d.

記憶體有 24GB 可以分配, 調教重點當然是越省越好, 讓 Memory Free space 越多越好, 多的部份都拿去運算.

網路會採用 ```Infiniband Card:Mellanox ConnectX QDR 40Gb/s```, 這種莫名奇妙的網路卡XD, 每秒好幾個影片子上下, 基本上整體系統的 bottleneck 不會在 network 傳輸部分, 比賽的時候他們也不會希望是卡在這個. 至於 GbE 在這種比賽只是拿來當一開始安裝軟體傳輸用, 等 Infiniband 設定完能動了, 就可以 down 下去了.

硬碟 SSD 在這種 Heavy I/O 比賽來說, 算是慢的, 只是當儲存資料及 OS 用.

GPU 是專門對 Application 做使用, HPL 其實也有 CUDA 版的, 但要跟官方簽 NDA 才行. 關於電力上控制是不用特別注意的, 但聽說全球大賽 SCC(Student Cluster Challenge) 是連電力都要考量進去, 不知道是真是假, 很想去但已經沒機會(碩一)了.

## TSCC 要點
1. 測資通通都要跑過一次
2. 碰到 swap 必輸
3. 先求穩 再求好

## 心得
這種比賽分為 Linux tunning + Compiler + MPI + Math Library + HPL config 這五個部分來看.

1. Linux tunning 
  - 一般安裝軟體、調教參數及分析 Bottleneck 皆屬此類, 需求是要有個 System Administrator 等級的來碰會比較清楚.
  - 挑選 OS 只有一個大重點 ```有沒有支援 infiniband ``` 不支援 infiniband 的話, 只用 GbE 跑的話, 會發現整個瓶頸都會在網路傳輸部分.
  - [Linux Performance](http://roan.logdown.com/posts/193253-linux-performance) 所列分析工具可參考一下, ```dstat``` 萬用
  - Kernel tunning 其實可以嘗試看看, 應該會有不錯的報酬, 但要考量的風險是自編 Kernel 會不會在比賽現場發生 Kernel panic, 只要發生了就會浪費非常多時間在這上面.
  - [工商服務 - Scientific Linux 6.4 最小化安裝](http://roan.logdown.com/posts/165596-scientific-linux-64-to-minimize-the-installation)
  
2. Compiler
  - {gcc, icc(商業), ...}
  - icc is better than gcc

3. MPI
  - {OpenMPI, MPICH}
  - 常用 OpenMPI

4. Math Library
  - {Gotoblas2, OpenBlas, MKL}
  - 這裡的選擇是關鍵, 好的跟較差的可以差上好幾%

5. HPL Config
  - 這裡我沒有涉略, 不太清楚怎麼調

## 結論
這比賽很注重時間分配及能否有效快速的準備好系統, 當設定完之後, 透過一些小測資微調數據, 之後比賽大部分就會在漫長的等待中渡過了, 還有清大這方面的技術真的很強, 有興趣的人可以找一下他們研究這方面的技術.

## Reference
- [2014全國學生叢集電腦競賽](http://event.nchc.org.tw/2014/tscc/)
- [HPL - A Portable Implementation of the High-Performance Linpack Benchmark for Distributed-Memory Computers](http://www.netlib.org/benchmark/hpl/)
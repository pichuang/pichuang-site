---
layout: post
title: What does automation do with Ansible
date: 2018-06-12 11:41:41
category: automation
tags:
- ansible
---

# Ansible 自動化了些什麼?

Ansible 打從 2012 年於 GitHub 上誕生後，以短短三年的時間，力戰其他差不多概念的配置管理系統 (Configuration Management, CM)，整個專案被 Red Hat 併購走，開啟了對於企業資訊平台維運管理自動化的偉大航道。

<!-- more -->

## 自動化是?
自動化 (Automation) 本身是發展頗久的綜合性技術，需要結合多項具體實作和實作間的流程規劃 (Pipeline Design) 才能辦到。而基於此設計出的流程 (Pipeline) 進行一系列的不需人為介入連續性操作的方法 (Methodology)。

看不懂以上的敘述沒關係，先看以下兩分鐘的影片 [無人自動化餐廳問世，炒菜做飯全由機器完成，3分鐘做好壹份](https://www.youtube.com/embed/HH42KCQoSnk)

<iframe width="560" height="315" src="https://www.youtube.com/embed/HH42KCQoSnk" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## 為何要 Ansible?

第一，Agentless！！！不少人對於日常系統維護上，在系統裏需要多新增 Agent 感到十分不舒服，更何況多數的網路設備根本不可能放 Agent 進去進行管理。而 Ansible 是透過系統上已存在的帳號來獲得相同的系統權限，連線方式主要是透過 SSH 及 WinRM，整個行為就跟你人坐在電腦前，手動登入系統執行一系列指令是沒有差異的。

第二，語言簡潔好讀，請直接參閱下面可執行之檔案

```yaml
---
- hosts: nxos_switch
  tasks:
     - name: Add interfaces to VLAN
       nxos_vlan:
         vlan_id: 100
         interfaces:
           - Ethernet2/1
           - Ethernet2/5
     - name: Check interfaces assigned to VLAN
       nxos_vlan:
         vlan_id: 100
         associated_interfaces:
           - Ethernet2/1
           - Ethernet2/5
```

相信就算沒特別解釋也能理解這檔案主要`做兩件事`：於 NXOS 上，對當中兩個介面上 Vlan 100 及檢查有沒有正確上 Vlan 100

Ansible 本身模組盡力做到凡人如我也可以讀的程度，並沒有想要建立高聳的語言門檻，讓使用者難以交接跟閱讀。

第三，綜合以上兩個條件，簡單即是力量，基於清晰描述，輔以大量文件及範例參考，降低使用者入手門檻，能有效穩定快速地提升產出。

## Ansible 如何做到自動化?

基於基礎架構即代碼 (Infrastrcture as Code, IaC) 的概念延伸出來到管理系統的層面。核心理念是:

> 盡可能地將環境設定配置檔或執行過程，透過某一種方式或語言撰寫下來，且要確保被不同使用者反覆地被利用。

Ansible 透過事先設計好的特定領域語言 (Domain Specific Langauge, DSL) 所撰寫出的大量模組 (Modules)，來描述整個程式的執行脈絡或環境變數。

類似的專案還有 Vagrant 的 Vagrantfile 及 Docker 的 Dockerfile，但主要這兩個都是在描述基礎環境，前者是專注在 VM 層級，後者則是 Container 層。而進入運行狀態 (Runtime) 後的狀態更動，這兩個專案本身都沒有辦法在 Runtime 中做控制或設定維護，得依靠可在 Runtime 中進行配置變動 (Provisioning) 的程式來做維護，這裡就是配置管理系統 (CM) 可以切入的點。

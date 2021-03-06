---
layout: post
title: "Suggestions to Improve Your Ansible Playbook"
description: ""
date: 2018-06-22 00:00:00 +0800
updated: 2016-06-22 00:00:00 +0800
category: Automation 
tags:
- automation
- ansible
- iac
---

# 改善 Ansible Playbook 的幾個小建議
## 前言

先說本文謹代表個人撰寫 Ansible Playbook 及 Ansible Tower 之經驗累積，不定期會更新內容，僅供參考 XD

Ansible 本身具備著幾個很顯著的特性: `好寫`, `易讀`, `Agentless`，但說到好寫，也因為寫的花樣特別多，所以特別撰寫此文留下平時我寫 Ansible Playbook 時會注意的一些地方。當然有些內容會從 Ansible 官方所列的 [Best Pratices][1] 截錄過來，但多數還是由我個人撰寫經驗的角度為出發點。


## Suggestions

<!--more-->

### Suggestion 1: 建議遵從最佳實踐的 Ansible Direcory Layout 最佳建議

若有常在撰寫 Anisble 的人都知道，若改 `ansible.cfg` 可以讓很多 playbook 呼叫變數及路徑變得非常的彈性。可以改，但十分不建議這樣做。主要是你同事或跟你交接的工程師不一定會知道你的個人習慣是什麼，建議走最佳實踐及建議之資料夾命名

```bash
production                # production servers 主機目錄
staging                   # staging environment 主機目錄

group_vars/
   group1                 # 以 Group 為單位，賦予對應之變數
   group2                 
host_vars/
   hostname1              # 以 host 為單位，賦予對應之變數
   hostname2              

library/                  # 任何自己寫或自己維護 (也就是非 Built-in) 的 module 都建議放這邊
module_utils/             # 個人很少在用
                          # 可參考 `/usr/lib/python2.7/site-packages/ansible/module_utils` 的內容
filter_plugins/           # 任何自己寫或自己維護 (也就是非 Built-in) 的 filter 都建議放這邊

Do_something_for_someone_1.yml       # 為了某個服務做某事，後面會有詳細建議
Do_something_for_someone_2.yml
Do_something_for_someone_3.yml

roles/
    common/               # 其中一個 role 的名字 `common`
        tasks/            # common 的 tasks 資料夾
            main.yml      # common 相關的 tasks action 請先寫在這
        handlers/         # common 裡的事件處理
            main.yml      # common 相關的 event handler 請先寫在這
        templates/        # common 相關的 jinja2 模板
            ntp.conf.j2   # common 相關的 file template 請先寫在這
        files/            # common 相關的檔案庫
            bar.txt       # common 相關的檔案
            foo.sh        # common 相關的 script 放這邊
        vars/             #
            main.yml      # 跟這個 common 有相關的區域變數宣告請放這邊
        defaults/         # common 相關的預設變數
            main.yml      # 可以寫變數預設值在這邊，但我個人比較推薦寫到 tasks 裡面的 playbook 裡，後面會有詳細建議和寫法
        meta/             # common 相關的其他角色依賴
            main.yml      # 宣告角色依賴
        library/          # 針對 common role 的函式庫
        module_utils/     # 個人很少在用
        lookup_plugins/   # 個人很少在用

    webtier/              # 呈上的結構
        ...
        ...
        ...
```

# Suggestion 2: 建議 Playbook 命名法

`Do something for someone` 為命名遵照，我知道很多人都是直接用 someone 當作 Playbook 的命名，但因為後面會帶入的其中一個建議 Ansible Tower 所帶來 Workflow 的觀念 - `多個 Playbook 序列化執行` 及期望維護者能一眼看出這份 Playbook 主要是在針對`什麼目標做什麼事情`，所以建議此規範。

- 不建議  

```bash
webserver.yml
database.yml
```

- 建議  

```bash
deploy-webserver.yml
deploy-database.yml
```

## Suggestion 3: 一個專案一個業務目標

Ansible 最頂端的資料夾叫做 `專案 (Project)`，其次才是 Playbook 及 roles 等等的文件結構。

假設今天要部署一個 http server，需要有 lb、www、db，我會將 Playbook 分為以下幾個：

- Deploy_http_server
    - install_lb.yml
    - install_www.yml
    - install_db.yml
    - check_www_service.yml

以此案例，專案名字叫做 Deploy_http_server，裡面包含上述所列的 playbook，以`一個專案一個業務目標`為核心，進行 playbook 的撰寫。

## Suggestion 4: 變數無給值，預設帶入 default 值

常寫 Shell Script 的人應該常寫以下寫法：

```bash
FOO=${VARIABLE:-default} # 如果 VARIABLE 無給值，及使用 default 值
```

其實 ansible 也有支援這寫法

```bash
---
- hosts: "{{ variable_host | default('all') }}"
  tasks:
    - name: ...
    ...
```

這個使用情境我個人是應用在部署新 VM 或更新系統時，針對`特定主機`時會用到，過去要針對新部署的機器上一些修正時，都要去改 hosts 裡面的值，現在用這個寫法可以直接...

```bash
ansible-playbook -i inventory deploy_new_vm_env --extra-vars='variable_host=192.168.100.1'
```

針對 192.168.100.1 這台機器作部署或上 patch，倘若我都沒有下任何 extra-vars 的話就會直接針對 inventory 內所有機器 all 做處理。

這個寫法也可以結合 Ansible Tower 裡 Survey 功能進行 Self-service 應用。

## Suggestion 4: Ansible Workflow 實作提示

其實這概念是從 Ansible Tower 延伸出來的，將 `將多個 Playbook 序列化執行`，這個是在你的業務目標是由多個業務目標所建立起來才會需要的一個作法，你可以把它想成 Agile 專案術語 Epic / Story / Task 對應到 Ansible Workflow / Playbook / Roles。

Workflow 具體寫法是...
```bash
cat deploy_openshift_cluster.yml
---
- import_playbook: prerequisite_env.yml
- import_playbook: deploy_core_componets.yml
- import_playbook: check_componets.yml
```

倘若你想要的話，也可以 workflow in workflow 持續疊下去，除非你對抽象化程度非常有把握，不然頂多做一層 workflow 應可應付多數需求。

此外這功能主要是為了 Ansible Tower 設計的，除了具備可視化 Workflow 以外，還有多加錯誤處理，當 playbook 跑道有問題的時候，可以跳到錯誤處理進行應對，譬如發信通知等等。

## Suggestion 5: 上版本控制系統 Version Control System

這邊的版控可以是任何一家的方案 git, svn, mercurial ...etc，沒有最佳只有最適合自己的方案，我自己是一律推崇使用 `git`，無論你是用中央式或分散式的管理方式，都可以用 git 辦到，極度好用

遵照 Infrastrcture as Code 的思想，盡量對所有 source code 的變動都要有所記錄。上版控有幾個好處，可以...
- 允許使用者將檔案恢復到某個時間的狀態
- 進行不同時間點的修改
- 確認該時間點誰進行了變更導致問題產生
- 容易進行備份管理

Ansible Tower 的專案內容更新也是需要`基於版本控制`進行設定檔的變動，方便進行 playbook 的內容管理

### Suggestion 6: TBC...

## References
- [Ansible - Best Practies](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#best-practices)
- [Best Pratices - Directory Layout](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#directory-layout)
---
layout: post
title: Understand Ansible Variable
date: 2017-04-27 10:49:18
updated: 2017-04-27 10:49:18
category: Infra
tags:
- infra
- ansible
- netdevops
---

## Goal
Understand how to use Ansible variable

## Project
[pichuang - Ansible Variable Cheat Sheet][3]

<!--more-->

## Last listed variables winning prioritization

In 2.x, we have made the order of precedence more specific (Low -> High Priority)

1. role defaults
2. inventory INI or script group vars
3. inventory group_vars/all
4. playbook group_vars/all
5. inventory group_vars/*
6. playbook group_vars/*
7. inventory INI or script host vars
8. inventory host_vars/*
9. playbook host_vars/*
10. host facts
11. play vars
12. play vars_prompt
13. play vars_files
14. role vars (defined in role/vars/main.yml)
15. block vars (only for tasks in block)
16. task vars (only for the task)
17. role (and include_role) params
18. include params
19. include_vars
20. set_facts / registered vars
21. extra vars (always win precedence)


## Reference
- [Ansible マジック変数の一覧と内容][1]
- [Ansible - Variables][2]
- [Ansible - Variable Precedence: Where Should I Put A Variable?][4]

[1]: http://qiita.com/h2suzuki/items/15609e0de4a2402803e9
[2]: http://docs.ansible.com/ansible/playbooks_variables.html
[3]: https://github.com/pichuang/ansible_variable_cheat_sheet
[4]: http://docs.ansible.com/ansible/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable
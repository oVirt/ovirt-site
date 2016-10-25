---
title: Manage oVirt with Ansible Playbooks
author: bkp
date: 2016-09-26 12:25:00 UTC
tags: ovirt, ansbile, modules
comments: true
published: true
---
As powerful a tool that oVirt is in the datacenter, we know it's not the only tool that's available for IT administrators to manage their virtual machines. A VM datacenter solution may be the best and only answer for your organization's needs, but you may also need bare-metal and even hybrid or public cloud management.

For that reason, the oVirt project team has made concerted efforts to integrate with other management tools so you can scale your admin toolchain as needed. oVirt has already achieved such integration with [ManageIQ](http://manageiq.org/), the open source platform that enables control of all your virtual infrastructure. It only makes sense, then, to integrate with [Ansible](https://www.ansible.com/), another powerful IT automation tool. We are happy to announce the creation of new Ansbile modules that will enable the management of an oVirt environment via playbooks.

READMORE

If you're not familiar with Ansible, it's a tool that can configure systems, deploy software, as well as orchestrate more advanced IT tasks such as continuous deployments or zero-downtime rolling updates.

So what are playbooks? Well, playbooks are the core of Ansible’s configuration, deployment, and orchestration language. According to Ansible, playbooks describe a policy using YAML that you want your remote systems to enforce, or a set of steps in an automated IT process. Basically, playbooks are made up of tasks, each of which executes a specific Ansible module with whatever parameters the user provides.

Thanks to the efforts of oVirt's Ondra Macháček, Ansible modules to support oVirt 4.0 (and the downstream RHV 4.0 product) have been created and merged to Ansible 2.2, as well as the development tree for the upcoming 2.3. For instance, Ansible 2.2 users will be able to automatically accomplish tasks like authenticate to the oVirt Engine, manage the entire lifecycle of a virtual machine, and control virtual machine and floating disks in oVirt.

When Ansible 2.3 is released, a lot more modules will be released, enabling the management of datacenters, clusters, networks, storage domains, and hosts in oVirt. Host management will also include host network and power management. Macháček has also added modules to manage external providers, NICs, templates, VM pools, users, groups, and permissions.

Current Ansible users can find the new oVirt/RHV 4 modules [on Ansible's site](http://docs.ansible.com/ansible/list_of_cloud_modules.html#ovirt). If Ansible seems like a management system that appeals to you, [check out their site](https://www.ansible.com/) for more information.

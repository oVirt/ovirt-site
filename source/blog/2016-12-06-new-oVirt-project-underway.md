---
title: New oVirt Project Underway
author: bkp
tags: oVirt, moVirt, vagrant
date: 2016-12-06 20:05:00 UTC
comments: true
published: true
---

As oVirt continues to grow, the many projects within the broader oVirt community are thriving as well. Today, the oVirt community is pleased to announce the addition of a new incubator subproject, Vagrant Provider, as well as the graduation of another subproject, moVirt, from incubator to full project status!

According to maintainer Marc Young, Vagrant Provider is a provider plugin for the Vagrant suite that enables command-line ease of virtual machine provisioning and lifecycle management.

READMORE

## More on Vagrant Provider

The Vagrant provider plugin will interface with the oVirt REST API (version 4 and higher) using the oVirt provided ruby SDK 'ovirt-engine-sdk-ruby'. This allows users to abstract the user interface and experience into a set of command-line abilities to create, provision, destroy and manage the complete lifecycle of virtual machines. It also allows the use of external configuration management and configuration files themselves to be committed into code.

As Young explains in [his project proposal](/develop/projects/proposals/vagrant-provider/), the "trend in configuration management, operations, and devops has been to maintain as much of the development process as possible in terms of the virtual machines and hosts that they run on. With software like Terraform the tasks of creating the underlying infrastructure such as network rules, etc have had great success moving into 'Infrastructure as code'. The same company behind Terraform got their reputation from Vagrant which aims to utilize the same process for virtual machines themselves. The core software allows for standard commands such as 'up', 'provision', 'destroy' to be used across a provider framework. A provider for oVirt makes the process for managing VMs easier and able to be controlled through code and source control."

Vagrant Provider currently exists as an independent open source project hosted on [github](https://github.com/myoung34/vagrant-ovirt4).

## moVirt Makes Full Status

Meanwhile, moVirt has demonstrated its healthy status as a part of the oVirt community, and was voted to become a full oVirt project at the end of November.

The [moVirt app](https://github.com/matobet/movirt), which was released in August 2015, is a mobile client for oVirt that aims not to duplicate the features of the existing web dashboard but strives to be a useful companion app.

moVirt contains three main features: Monitoring of virtual machine health, such as memory/CPU utilization, status, and events; integration with SPICE and VNC; and bridging the physical world of servers with the virtual world of oVirt using the techniques of augmented reality that can scan data matrix codes located physically on servers.

Congratulations to both projects for their progress within the oVirt Project!

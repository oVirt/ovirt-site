---
title: Announcing the oVirt Engine DR Sub-project
author: bkp
tags: community, disaster recovery, sub-project
date: 2016-07-20 16:00:00 CET
comments: true
published: true
---
The oVirt Project is pleased to announce a new sub-project within the oVirt community: oVirt Engine DR, which uses the oVirt API and perform tasks that would normally require manual intervention, in case of the need for Disaster Recovery.

Specifically, the oVirt Engine DR is a web application that uses Java, the oVirt API, PostgreSQL, and MariaDB to perform the tasks needed in a Disaster Recovery scenario. 

READMORE

Features will include:

* Disables Power Management for Hosts
* Manual Fence all Hosts in non_responsive state
* Modifies Server Storage Connections (currently directly to Engine Database)
* Activates some Hosts to be able to recover from Disaster
* Stores the configuration on a MariaDB database
* Enables the administrator to create other users who can't change configuration but can start the procedure

 oVirt Engine DR currently exists as an independent open source project hosted on [github](https://github.com/xandradx/ovirt-engine-disaster-recovery). The project, which is currently in incubation status, includes as the owner and initial maintainers: José Eduardo Andrade Escobar, Jorge Luis Andrade Escobar, and Luis Armando Pérez Marín. 
 
 This [sub-project page](http://www.ovirt.org/develop/projects/proposals/ovirt-engine-disaster-recovery/) will gather input on whether oVirt Engine DR should become a full oVirt sub-project and, if so, how best to integrate it into the oVirt stack.

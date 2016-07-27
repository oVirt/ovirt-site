---
title: Manage Your Hosted Engine Hosts Deployment Via Engine
author: roy
tags: hosted-engine, deployment, infrastructure
date: 2016-07-27 19:14:00 CET
comments: true
published: true
---

Hosted engine has seen a lot of progress and evolution, and today it is is the *de facto* recommended way to to deploy your oVirt Engine. But since that special Hosted Engine High Availability (HA) cluster itself needs management, we worked on making that be managed by the hosted engine itself, too.

Recent oVirt versions made it lot more easier to deploy hosted-engine, first by introducing the appliance and cloud-init customization
phase, next with VM configuration being stored on the shared storage and making the VM itself manageable from the UI itself. A few more under-the-hood changes resulted in storing event the cluster configuration on the shared storage itself, opening the door to making the expanding of the HA-cluster even easier, as all answers and configuration were now already available.

READMORE

## What's New in 4.0

What this version is adding is the capability to add and remove more HA hosts using the engine itself, instead of going over machine by machine and running the cli utility, `hosted-engine --deploy`, to get you up and running. Since oVirt has a well-established host installation subsystem, otopi, which installs and configures with host by the engine, we just needed to plug in the part to install and configure the HA services (ovirt-ha-agent and broker).

The obvious advantages of expanding the cluster from the engine is that you gain all the advantages of using the UI or REST API. It's easy to use, scriptable if you want, and more importantly, it's a single place you need to be instead of doing round-trips to your machine (over ssh of course :)) for your provisioning operations. Technically, it also makes the process go through the engine, which enforces the engine into being the single source of configuration (instead of scattered configuration across hosts).

## How Does It Work?

First things first, in `bootstrap mode` we don't have an engine VM yet. The first host is being installed using `hosted-engine --deploy` and we end up with with the VM up and running, and with all configuration saved on the shared storage (by default named **hosted_storage**). Next:

1. After adding the master data domain and activating the DC, the VM is imported with the storage configuration into the engine. Our HA cluster is self aware!

2.  Add a host, choose the __Hosted-Engine__ side tab and click `Deploy`.

3. The engine will go download the configuration disk from __hosted_storage__. The disk has a special description by which we identify the disk. The hosted-engine.conf is extracted from that disk. It will be used as the configuration of the `ovirt-ha-agent` service to connected to the storage, participate in `sanlock` space and its unique `host_id`. It's important to note that the `host_id` is maintained by __ovirt-engine__, in the DB, so its guaranteed to be unique and will not collide with the rest of the host in the datacenter, including hosts which are regular, non-HE hosts.

4. The engine invokes the host-install process and passes a special section (called deploy unit) with the configuration. The HE package is being installed and `hosted-engine.conf` is written into `/etc/ovirt-hosted-engine-ha/hoted-engine.conf`, and the services are started.

5. Next, the services boots up and performs the regular steps to properly join the cluster&mdash;connect to the storage and monitor it, download the VM OVF and prepare a vm.conf out of it, monitor its resources and crunch a score out of it so the host will be accepted as a cluster member.

6. At the end, VDSM will report the `ha_score` of that host and it will be capable of running the HE VM.

![alt text](managing-hosted-engine-hosts-via-engine.png "Sequence diagram of HE hosts management")

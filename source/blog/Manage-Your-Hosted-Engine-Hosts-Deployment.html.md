---
title: Manage Your Hosted Engine Hosts Deployment Via Engine
author: Roy Golan rgolan@redhat.com
tags: hosted-engine, deployment, infrastructure
date: Wed Jun 15 11:05:24 IDT 2016
---

# Managing your Hosted Engine hosts deployment via engine
Hosted engine seen a lot of progress and evolution till today is the defacto recommended way to to deploy your engine. But since that special Hoseted Engine High Availability cluster itself needs management(we call it HA cluster), we worked on making that be managed as well by the (hosetd) engine itself.

Recent oVirt versions made it lot more easier to deploy hosted-engine, first by introducing the appliance and cloud-init customization
phase, next with vm configuration being stored on the shared storage and making the vm itself manageable from the UI itself. Few more under-the-hood
changes resulted storing event the cluster configuration on the shared storage itslef, openging the door to making the expanding of the HA-cluster
even easier, as all answers + configuration already available.

# What's new in 4.0
What this version is adding is the ability to add/remove more HA hosts using the engine itself, instead of going over machine by machine and running the
cli utility, __`hosted-engine --deploy`__, to get you up and running.
Since oVirt has a well established host installation subsystem, otopi, which install and configures a host by the engine, we just needed to plug-in the
part to install and configure the HA services (ovirt-ha-agent + broker).

The obvious advantages of expanding the cluster from the engine is that you gain all the advantages of using UI or REST API. Its easy to use, scriptable if you
want, and more importadly, its a single place you need to be in, instead of doing round-trips to your machine (over ssh ofcourse :)) for your provisioning operations.
Technically, it also made the process go through the engine, which enforces the engine into being the single source of configuration (instead of scatterd configurtaion across hosts)

# How does it work?
- First thing first, in `bootstrap mode` we don't have an engine VM yet. The 1st host is being installed using __`hosted-engine --deploy`__ and we end up with
with the VM up and running, and with all configuration saved on the shared storage (by default named __hosted_storage__)
- After adding the master data domain and activating the DC, the VM is imported with the storage configuration into the engine. Our HA cluster is self aware!
- Add a host, choose the __Hosted-Engine__ side tab and click __`Deploy`__
// screenshot of the add hosts
- Engine will go download the configuration disk from __hosted_storage__. The disk has a special description which we identify the disk by. The hosted-engine.conf
is extracted from that disk. It will be used as the configuration of the __`ovirt-ha-agent`__ service to connected to the storage, participate in __`sanlock`__ space
and its unique __`host_id`__. Its important to note that the __`host_id`__ is maintained by __ovirt-engine__, in the DB, so its guranteed to be unique and will not
collide with the rest of the host in the datacenter, including host which are regular, non HE hosts.
- Engine invokes the host-install process and passes a special section (called deploy unit) with the configuration. The HE package is being installed and __`hosted-engine.conf`__
is written into __`/etc/ovirt-hosted-engine-ha/hoted-engine.conf`__, and the services are started.
- Next, the services boots up and performs the regular steps to properly join the cluster - connect to the storage and monitor it, download the VM OVF and prepare a
vm.conf out of it, monitor its resources and crunch a score out of it so the host will be accepted as a cluster member.
- At the end, vdsm will report the __`ha_score`__ of that host and it will be capable of running the HE VM.

![alt text](managing-hosted-engine-hosts-via-engine.png "Sequence diagram of HE hosts management")


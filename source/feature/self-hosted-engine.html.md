---
title: Self Hosted Engine
category: feature
authors: didi, dneary, doron, dyasny, fabiand, gpadgett, jmoskovc, lveyde, mgoldboi,
  mlipchuk, msivak, sandrobonazzola, scohen
wiki_category: Feature|Self Hosted Engine
wiki_title: Features/Self Hosted Engine
wiki_revision_count: 48
wiki_last_updated: 2015-01-16
---

# Self Hosted Engine

### Summary

The ability to run the Engine as a VM in a Datacentre that is managed by this Engine.

### Owner

*   Dan Yasny: [ Dyasny](User:Dyasny)

<!-- -->

*   Email: <dyasny@redhat.com>

### Current status

*   Still being discussed
*   Last updated: ,

### Detailed Description

This feature will deal with two main issues:

*   The deployment of an Engine as a VM into a fresh setup.
*   HA for the Engine VM needs to be managed by the hosts and not the Engine.

### Benefit to oVirt

*   This will allow us to deploy less hardware (with the Engine not requiring a separate machine)
*   We will be capable of providing HA for the Engine out of the box, instead of using a separate cluster in order to make the Engine HA.
*   The Engine services will be managed as a regular VM in terms of load balancing, placing the Engine VM where resources are best suited to run it.
*   This operational mode will attract users already familiar with it from other virt platforms.

# **Requirements**

*   New installation should be simple and guided.
*   A user will start with a single hypervisor host (full host OS or ovirt-node), that can access shared storage, and after the setup, will be able to access the Engine webadmin UI in order to add mode hosts, clusters, SDs etc.
*   The engine should be able to start on any of the hosts it manages, provided the host can access the Engine's virtual disk's location.
*   The engine should be highly available, and be able to tolerate host, network and storage failures.
*   An ability to define priorities for hosting the engine is required.

# Comments and Discussion

*   Refer to [Talk:Self Hosted Engine](Talk:Self Hosted Engine)

<Category:Feature>

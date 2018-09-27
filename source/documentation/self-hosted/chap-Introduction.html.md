---
title: Introduction
---

# Chapter 1: Introduction

A self-hosted engine is a virtualized environment in which the oVirt Engine runs on a virtual machine on the hosts managed by that engine. The virtual machine is created as part of the host configuration, and the Engine is installed and configured in parallel to the host configuration process. The primary benefit of the self-hosted Engine is that it requires less hardware to deploy an instance of oVirt as the Engine runs as a virtual machine, not on physical hardware. Additionally, the Engine is configured to be highly available. If the host running the Engine virtual machine goes into maintenance mode, or fails unexpectedly, the virtual machine will be migrated automatically to another host in the environment. A minimum of two self-hosted Engine hosts are required to support the high availability feature.

For the Engine virtual machine installation, an oVirt Engine Virtual Appliance is provided. Manually installing the Engine virtual machine is not supported. To customize the Engine virtual machine, you can use a custom cloud-init script with the appliance. Creating custom cloud-init scripts is currently outside the scope of this documentation. A default cloud-init script can be generated during the deployment.

**Supported OS versions to Deploy Self-Hosted Engine**

| System Type | Supported Versions |
|-
| Enterprise Linux host | 7.5 |
| oVirt Node   | 7.5 |
| HostedEngine-VM (Engine)     | 7.5 |

For hardware requirements, see "Hypervisor Requirements" in the [Installation Guide](/documentation/install-guide/Installation_Guide/).

    **Important:** It is important to synchronize the system clocks of the hosts, Engine, and other servers in the environment to avoid potential timing or authentication issues. To do this, configure the Network Time Protocol (NTP) on each system to synchronize with the same NTP server.

**Next:** [Chapter 2: Deploying Self-Hosted Engine](../chap-Deploying_Self-Hosted_Engine)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/self-hosted_engine_guide/chap-introduction)

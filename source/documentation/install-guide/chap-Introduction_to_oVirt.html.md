---
title: Introduction to oVirt
---

# Chapter 1: Introduction to oVirt

oVirt is an open source server and desktop virtualization platform built on operating systems like CentOS and Red Hat Enterprise Linux. This guide covers:

* The installation and configuration of an oVirt Engine.
* The installation and configuration of hosts.
* Attach existing FCP storage to your oVirt environment. More storage options can be found in the [Administration Guide](/documentation/admin-guide/administration-guide/).

**oVirt Key Components**

| Component Name | Description |
|-
| oVirt Engine | A server that manages and provides access to the resources in the environment. |
| Hosts | Hosts are servers that provide the processing capabilities and memory resources used to run virtual machines. |
| Storage | Storage is used to store the data associated with virtual machines. |

**Important:** It is important to synchronize the system clocks of the hosts, Engine, and other servers in the environment to avoid potential timing or authentication issues. To do this, configure the Network Time Protocol (NTP) on each system to synchronize with the same NTP server.
See [Configuring NTP Using the chrony Suite](https://docs.fedoraproject.org/f27/system-administrators-guide/servers/Configuring_NTP_Using_the_chrony_Suite.html) and [Synchronizing the System Clock with a Remote Server](https://docs.fedoraproject.org/f27/system-administrators-guide/basic-system-configuration/Configuring_the_Date_and_Time.html#sect-Configuring_the_Date_and_Time-timedatectl-NTP) in the [Fedora System Administrator’s Guide](https://docs.fedoraproject.org/f27/system-administrators-guide/index.html).

**Next:** [Chapter 2: System Requirements](../chap-System_Requirements)

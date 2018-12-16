---
title: Introduction
---

# Chapter 1: Introduction

OpenShift Aggregated Logging is based on the OpenShift Logging stack running on OpenShift Container Platform (OCP).
Ansible is used to install OpenShift Aggregated Logging using OpenShift Ansible logging roles.

## System Requirements

* 4 cores, 16GB RAM, and 500GB disk for an environment with 50 hosts.
* The oVirt Project highly recommends using SSD disks.
* OpenShift Aggregated Logging requires EL 7.5.

## Prerequisites

**Metrics Store Machine Prerequisites**

1. Add the hostname of the OpenShift Aggregated Logging machine to your enterprise hostname resolution system, for example, DNS.

2. Add the following aliases:

   * es._FQDN_ for Elasticsearch
   * kibana._FQDN_ for Kibana

     where _FQDN_ is the hostname and domain of the OpenShift Aggregated Logging machine.

3. The machine must meet all [Minimum Hardware Requirements](https://docs.okd.io/latest/install/prerequisites.html#hardware) detailed in the **Masters** section.

4. Ensure that _libvirt_ is not installed on the machine:

        # rpm -qa | grep libvirt

   If _libvirt_ is installed, remove it from the machine:

      # yum remove libvirt*

5. Create a preallocated 500GB partition called `/var`, which will be used for persistent storage. Do not use `root (/)`.

    **Important:** XFS is the only supported file system for persistent storage.

**Manager Machine Prerequisites**

Ensure that the time stamp in the **/var/log/ovirt-engine/engine.log** file contains a UTC offset suffix, rather than a letter such as Z. For example: 2018-03-27 13:35:06,720+01

**Next:** [Chapter 2: Setting Up the oVirt Engine and Hosts](Setting_Up_the_oVirt_Engine_and_Hosts)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/metrics_store_installation_guide/introduction)

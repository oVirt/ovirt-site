---
title: Deploying oVirt and Gluster Hyperconverged
---

# Chapter 2: Deploying oVirt and Gluster Hyperconverged

## Pre-requisites

* You must have 3 Enterprise Linux 7 hosts or oVirt Node hosts. Refer [Enterprise Linux Hosts](../install-guide/chap-Enterprise_Linux_Hosts) or [oVirt Nodes](../install-guide/chap-oVirt_Nodes)

* You must have at least 2 interfaces on each of the hosts, so that the frontend and backend traffic can be separated out. Having only one network will cause the engine monitoring, client traffic, gluster I/O traffic to all run together and interfere each other. To segregate the backend network, the gluster cluster is formed using the backend network addresses, and the nodes are added to the engine using the frontend network address.

* You must have a fully qualified domain name prepared for your Engine and the host. Forward and reverse lookup records must both be set in the DNS. **The Engine should use the same subnet as the management network.**

* You must have configured passwordless ssh between the first host to itself and the other 2 hosts. This is needed for gdeploy to configure the 3 nodes. gdeploy uses Ansible playbooks and the ability to remotely execute commands is a pre-requisite.

## Deploying on Enterprise Linux Hosts

### Installing the Required Packages

**Installing the packages on the first host**

1. On all 3 hosts, subscribe to ovirt repos from https://resources.ovirt.org/pub/yum-repo/
   For instance, to subscribe to oVirt 4.1 repo.

        # yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm

2. On all 3 hosts, install the following packages:
      - cockpit-ovirt-dashboard (provides a UI for the installation)
      - vdsm-gluster (plugin to manage gluster services)

       # yum install cockpit-ovirt-dashboard vdsm-gluster 

3. On the first host, install the following packages:
      - ovirt-engine-appliance (for the Engine virtual machine installation)
      - gdeploy (a wrapper tool around Ansible that helps to setup gluster volumes)
 
       # yum install ovirt-engine-appliance gdeploy


        
## Deploying on oVirt Node based Hosts

**oVirt Node contains all the required packages to set up the hyperconverged environment.**
Refer [oVirt Nodes](../install-guide/chap-oVirt_Nodes) for instructions on installing oVirt Node on your hosts. You can proceed to setting up the hyperconverged environment if you have 3 oVirt Node based hosts.

### Setting up the hyperconverged environment

Steps for installing are detailed in this [blog post](/blog/2017/04/up-and-running-with-ovirt-4.1-and-gluster-storage/).

**Prev:** [Chapter: Introduction](../chap-Introduction) <br>
**Next:** [Chapter: Additional Steps](../chap-Additional_Steps)



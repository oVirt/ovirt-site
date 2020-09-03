---
title: Phoenix Lab Overview
category: infra
authors: dcaroest
---

# Phoenix Lab Overview

**NOTE**: for the latest version of this doc, see <http://ovirt-infra-docs.readthedocs.org/en/latest/>

The Poenix Lab infrastructure is composed by (as of today) 10 nodes separated in two roles. The [storage servers](/develop/infra/phoenix-lab-storage-hosts.html) (2 hosts) and the [oVirt host](/develop/infra/phoenix-lab-hosts.html) servers (8 hosts).

The access to the servers is restricted to the foreman and jenkins hosts. So you need to access them first and tunnel through to be able to access any of the machines.

When connecting to the VMs through spice you'll need some special setup so your connections are tunneled trough ssh, the details are [here](/develop/infra/phoenix-lab-ssh-spice-tunnel.html)


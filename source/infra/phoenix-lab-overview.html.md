---
title: Phoenix Lab Overview
category: infra
authors: dcaroest
wiki_category: Infrastructure
wiki_title: Infra/Phoenix Lab Overview
wiki_revision_count: 4
wiki_last_updated: 2015-02-25
---

# Phoenix Lab Overview

The Poenix Lab infrastructure is composed by (as of today) 10 nodes separated in two roles. The [storage servers](infra/Phoenix_Lab_Storage_Hosts) (2 hosts) and the [oVirt host](infra/Phoenix_Lab_oVirt_Hosts) servers (8 hosts).

The access to the servers is restricted to the foreman and jenkins hosts. So you need to access them first and tunnel through to be able to access any of the machines.

When connecting to the VMs through spice you'll need some special setup so your connections are tunneled trough ssh, the details are [here](Infra/Phoenix_Lab_Ssh_Spice_Tunnel)

<Category:Infrastructure>

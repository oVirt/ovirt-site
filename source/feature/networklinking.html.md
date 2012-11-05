---
title: NetworkLinking
category: feature
authors: alkaplan, danken, lpeer, moti, vered
wiki_category: Feature
wiki_title: Feature/NetworkLinking
wiki_revision_count: 69
wiki_last_updated: 2013-03-07
wiki_warnings: list-item?
---

# Network Wiring

### Summary

*   Enable changing the network of a running vm
*   Enable disconnecting a network on a vm without unplugging the vnic

### Owner

*   Name: [ Alona Kaplan](User:alkaplan)
*   Email: <alkaplan@redhat.com>

### Current status

*   On Design
*   Last update date: 04/11/2012

### Detailed Description

*   A vnic on a running VM can have 4 states (If the VM is down, its state represent its behavoiur when he"ll get up)

    Plugged, Connected- The Vnic is defined on the VM and connected to the Network.

    Plugged. Disconnected- The Vnic is defined on the VM and isn't connected to any network.

    Unpluged, Connected- The Vnic is not defined on the VM. When the Vnic will be plugged it will be automatically connected to the Network.

    Unplugged, Disconnected- The Vnic is not defined on the VM. When the Vnic will be plugged it won't be connected to any network.

#### GUI

#### Virtual Machines -> Network Interfaces sub tab

*   **Actions**

    * Edit

        * Enable also if the vm status is up

        * If the vm status is up, type combo should be disabled

::\*

#### API

### Documentation / External references

Bugzilla - <https://bugzilla.redhat.com/show_bug.cgi?id=873244>

<Category:Feature> <Category:Template>

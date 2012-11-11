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

The network wiring feature is an enhancment for the VM Network Interface management. It supports the following actions without unlugging the Vnic, maintaing the address of the Vnic:

    * Dynamicly changing the network of a running VM (without unplugging the Vnic)
    * Disconnecting a network of a VM without unplugging the vnic

### Owner

*   Name: [ Alona Kaplan](User:alkaplan)
*   Email: <alkaplan@redhat.com>

### Current status

*   On Design
*   Last update date: 04/11/2012

### Introduction

Currently oVirt engine supports configuring the VM network interface either on creation or updating it when the vnic is not in active state (or the VM is not running).
    * ovirt-engine already supports hot-plug and hot-unplug of vnics, however it lacks the capability of performing changes of the vnic once the vnic is plugged and to preserve the vnic PCI address.

#### High Level Feature Description

A vnic on a running VM can have 4 states (If the VM is down, its state represents how it should behave once started)

*   **Plugged**

    * **Connected** - The Vnic is defined on the VM and connected to the Network.

:\*\* Obsereved as the vnic is located on its slot and a network cable is connected to it.

:\*\* This is the only state on which the state of the VM Network Interface is 'Active'.

    * **Disconnected** - The Vnic is defined on the VM and isn't connected to any network.

:\*\* Obsereved as the vnic is located on its slot but no network cable is connected to it.

*   **Unplugged** - at this state the vnic is defined on ovirt-engine only

    * **Connected** - once the Vnic is plugged it will automatically be connected to the Network and become 'Active'.

    * **Disconnected** - once the Vnic is plugged it won't be connected to any network.

The ovirt-engine's user will be able to configure the Vnic state to any of the mentioned above by any of the following methods:

*   API
*   Admin portal
*   User portal

### Benefit to oVirt

The feature is an enhancement of the oVirt-engine Vnic management:

*   Dynamically updating the Vnic configuration by the admin or by the user.

### Dependencies / Related Features

The Network Permissions is dependent on the following features:

*   [Permission on Networks](http://wiki.ovirt.org/wiki/Feature/NetworkPermissions)

Affected oVirt projects:

*   oVirt-engine
    -   API
    -   Admin Portal
    -   User Portal
*   VDSM

### Documentation / External references

Bugzilla - <https://bugzilla.redhat.com/show_bug.cgi?id=873244>

### Comments and Discussion

<Category:Feature> <Category:Template>

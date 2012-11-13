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

The network wiring feature is an enhancement for the VM Network Interface management. It supports the following actions without unplugging the Vnic, and it maintains the device address of the Vnic:

    * Dynamically changing the network of a running VM.
    * Unwiring a network of a VM.

### Owner

*   Name: [ Alona Kaplan](User:alkaplan)
*   Email: <alkaplan@redhat.com>

### Current status

[Network Wiring Detailed Design](http://ovirt.org/wiki/Feature/DetailedNetworkWiring)

*   Last update date: 04/11/2012

### Introduction

Currently oVirt engine supports configuring the VM Network Interface either on creation or updating it when the VM is down.
    * oVirt-engine already supports hot-plug and hot-unplug of vnics, however it lacks the capability of performing changes of the Vnic once the Vnic is plugged and to preserve the Vnic's PCI address.

#### High Level Feature Description

A Vnic on a running VM can have 4 states (If the VM is down, its state represents how it should behave once started)

*   **Plugged**

    * **Wired** - The Vnic is defined on the VM and connected to the Network.

        * Observed as the vnic is located on its slot and a network cable is connected to it.

        * This is the only state on which the state of the VM Network Interface is 'Active'.

    * **Unwired** - The Vnic is defined on the VM and isn't connected to any network.

        * Observed as the vnic is located on its slot but no network cable is connected to it.

*   **Unplugged** - at this state the Vnic is defined on oVirt-engine only

    * **Wired** - once the Vnic is plugged it will automatically be connected to the Network and become 'Active'.

    * **Unwired** - once the Vnic is plugged it won't be connected to any network.

The oVirt-engine's user will be able to configure the Vnic state to any of the mentioned above by any of the following methods:

*   API
*   Admin portal
*   User portal

#### User Experience

#### Admin/User Portal

##### Virtual Machines Network Interfaces sub-tab View Changes

*   **New Columns**

    * "Plugged"- will be added after "Name" column.

    * "Wired"- will be added after "Network Name" column.

*   **Updated Columns**

    * "Status" icon - green icon if plugged and wired, otherwise red icon. The tooltip will display a text for both the "plugged" and "wired" statuses.

##### Virtual Machines Network Interfaces Action Changes

*   **Removed Actions**

    * Activate/Deactivate

        * These actions will be removed from the sub-tab's action menu and from the context menu (The user will be able to plug/unplug the Vnic's via the add/edit Vnic dialogs)

*   **Updated Actions**

    * Add

        * Dialog

            * Adding radio button with two options "Wired/"Unwired" under the "network" combo.

            * "Activate" checkbox will be changed to a radio button with two options "Plugged"/"Unplugged" and its name will be renamed to 'Card Status'.

            * Add 'Advanced Parameters' section which includes the 'Port Mirroring' and the 'Card Status' properties.

    * Edit

        * Menu

            * Edit action will be enabled for VMs in status 'UP' (previously it was allowed only for VMs in 'Down' status).

        * Dialog

            * If the VM status is 'UP'

::::\* If the Vnic is plugged there should be a message on top of the dialog "Please notice, changing <b>Type</b> or <b>MAC</b> will cause unplugging and plugging the Vnic".

::::\* Port Mirroring - If the Vnic is plugged and the Vnic is set for port mirroring - "network", "type", "mac" and "port mirroring" fields in the dialog will be disabled.

:::: Stretched Goal - To enable dynamic changes when port mirroring is set (without plugging and unplugging).

            * Adding radio button with two options "Wired/"Unwired" under the "network" combo.

            * Adding radio button named 'Card Status' with two options "Plugged"/"Unplugged" to the end of the dialog..

            * Add 'Advanced Parameters' section which includes the 'Port Mirroring' and the 'Card Status' properties.

![](vnicWiring.png "vnicWiring.png")

#### REST API

NIC properties:

Changes:

*   Adding new properties under VM NIC:

    * plugged

    * wired

*   Deprecating the active property under VM NIC
*   Deprecating activate/deactivate actions
*   Plug/unplug and wire/unwire on a vnic, will be done via PUT action on the VM NIC
    -   /api/vms/xxx/nics/yyy/

There is no reason to have dedicated actions for plug/unplug or wire/unwire. The original reason for having them was that edit VM nic while the VM was up used to be blocked and now we'll enable doing these actions.

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

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

#### Terminology

A vnic on a running VM can have 4 states (If the VM is down, its state represent its behavoiur when he"ll get up)

1.  Activte - Plugged & Connected- The Vnic is defined on the VM and connected to the Network.
2.  Plugged & Disconnected- The Vnic is defined on the VM and isn't connected to any network.
3.  Unpluged & Connected- The Vnic is not defined on the VM. When the Vnic will be plugged it will be automatically connected to the Network.
4.  Unplugged & Disconnected- The Vnic is not defined on the VM. When the Vnic will be plugged it won't be connected to any network.

#### GUI

#### Virtual Machines -> Network Interfaces sub tab

*   **Columns**

    * Plugged- should be added after Name.

    * Connected- should be added after Network Name.

    * Status (icon)- green if plugged and connected, red- otherwise. The tooltip should display the plugged and connected status.

*   **Actions**

    * Activate/Deactivate-

        * Remove these actions from the subtab (The user will be able to control the Vnic's state through the add/edit Vnic dialogs)

    * Add

        * There would be an "on/off" switch next to the network combo. The switch will present if the network is connected or not.

        * "Activate" checkbox will be changed to a switch with two options "Plug/Unplug".

    * Edit

        * If the vm status is up

            * The edit command should be enabled.

            * If the vnic is active (plugged & connected) there should be a message in top of the dialog "Please notice, changing <b>Type</b> or <b>MAC</b> will cause plugging and unplugging the Vnic".

            * Port Mirroring- If the vnic is plugged and there is port mirroring on the vnic- network, type, mac and port mirroring fileds in the dialog will be disabled.

::: Strech goal- enable hot changes in port mirroring (without plugging and unplugging)

        * There would be an "on/off" switch next to the network combo.

        * Add "Plug/Unplug" switch to the dialog (same as in Add dialog).

![](vnicWiring.png "vnicWiring.png")

#### REST API

NIC properties:

Changes:

*   Adding new properties under VM NIC:

    * plugged

    * connected

*   Deprecating the active property under VM NIC
*   Deprecating activate/deactivate actions
*   Plug/unplug and connect/disconnect on a vnic, will be done via post action on the VM NIC

There is no reason to have dedicated actions for plug/unplug or connect/disconnect. The original reason for having them was that edit VM nic while the VM was up used to be blocked and now we'll enable doing these actions.

### Documentation / External references

Bugzilla - <https://bugzilla.redhat.com/show_bug.cgi?id=873244>

<Category:Feature> <Category:Template>

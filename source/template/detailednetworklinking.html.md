---
title: DetailedNetworkLinking
category: template
authors: alkaplan, apuimedo, danken, lpeer, moti
wiki_category: Template
wiki_title: Feature/DetailedNetworkLinking
wiki_revision_count: 75
wiki_last_updated: 2012-12-18
wiki_warnings: list-item?
---

# Detailed Network Linking

## Network Wiring

### Summary

The network wiring feature is an enhancment for the VM Network Interface management. It supports the following actions without unlugging the Vnic, maintaing the address of the Vnic:

    * Dynamicly changing the network of a running VM (without unplugging the Vnic)
    * Disconnecting a network of a VM without unplugging the vnic
[Network Wiring Feature Page](http://ovirt.org/wiki/Features/NetworkWiring)

### Owner

*   Name: [ Alona Kaplan](User:alkaplan)
*   Email: <alkaplan@redhat.com>

### Current status

*   On Design
*   Last update date: 11/11/2012

### Detailed Description

#### User Experience

#### Admin/User Portal

##### Virtual Machines -> Network Interfaces sub tab

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
*   Plug/unplug and connect/disconnect on a vnic, will be done via PUT action on the VM NIC
    -   /api/vms/xxx/nics/yyy/

There is no reason to have dedicated actions for plug/unplug or connect/disconnect. The original reason for having them was that edit VM nic while the VM was up used to be blocked and now we'll enable doing these actions.

#### Engine Flows

#### Engine API

##### Error codes

translate VDSM error codes: TODO

#### VDSM API

A new API is added for this feature.

#### Events

### Documentation / External references

### Streched Goals

*   Enable hot changes in port mirroring (without plugging and unplugging)

### Comments and Discussion

### Open Issues

NA

<Category:Template> <Category:Feature>

---
title: memory-balloon
category: sla
authors: doron, ecohen, emesika
wiki_category: SLA
wiki_title: Features/Design/memory-balloon
wiki_revision_count: 6
wiki_last_updated: 2012-10-30
---

# memory-balloon

## Introduction

Memory balloon is a guest device, which may be used to re-distribute / reclaim the host memory based
on VM needs in a dynamic way. In this way it's possible to create memory over commitment states.

## Current status

Currently the balloon memory device is being created by default by libvirt for non RHEV environments,
and VDSM disables it by default for RHEV. This change will enable the balloon device, supporting
oVirt's MOM sub-project integration[1](/wiki/Features/MomIntegration).

## Engine core

*   **Backend-ui/rest parts**
    -   A new VM attribute - enableBalloon - will be added VM & VmStatic BE to support this feature.
        -   The attribute is not persistant in vm_static table and clients should call the IsBalloonEnabledQuery to get the value from vm_device.
        -   Default value should be True.
        -   This attribute should be handle in addVmCommand(s)
    -   Add a device (check if add with model 'none' is needed)
    -   Also in UpdateVmCommand to add or remove the device.
    -   Need to add as a parameter in RunOnce to override existing vm_static.
    -   Template editing: resource allocation is currently unsupported.

<!-- -->

*   **Backend-vdsm parts**
    -   AddVmCommand and all those inheriting it, should handle the balloon in copyVmDevices method.
    -   In order to handle export and import (templates, etc) we need to add a method in org.ovirt.engine.core.bll.utils.VmDeviceUtils.addImportedDevices to handle adding a balloon device.
    -   VmDeviceType should add the new device, and use 0 (other) for resource type.
        -   This means, updating org.ovirt.engine.core.common.utils.VmDeviceCommonUtils.isSpecialDevice to make sure the balloon becomes a managed device.
    -   VdsProperties should add model 'none' if needed
    -   VmInfoBuilder should add buildVmMemoryBalloon
    -   VmOldInfoBuilder should add an empty implementation of buildVmMemoryBalloon, similar to existing buildVmUsbDevices.
    -   org.ovirt.engine.core.vdsbroker.vdsbroker.CreateVDSCommand.buildVmData() should call the new buildVmMemoryBalloon method.
*   **OVF**
    -   Handle ovf reader and writer.
*   **DB Upgrade**
    -   Existing VM's should set enableBalloon value to **False**.
*   **Validations**
    -   This should be acceptable on 3.1 cluster only, as older vds versions will not support it.

## VDSM

*   VDSM already supports memory balloon as a device, and the following API should be used:

      {'type': 'balloon ',
      'device':'memballoon ',
      'model': 'virtio' },     <--- 'none' may/should (need to check!) be used to disable the device.

## Rest API

*   A simple flag hould be added in the relevant actions.

        <xs:element name="balloon" type="Balloon"/>

        <xs:complexType name="Balloon">
          <xs:sequence>
            <xs:element name="enabled" type="xs:boolean" minOccurs="0" maxOccurs="1"/>
          </xs:sequence>
        </xs:complexType>

## UI

*   In relevant dialog we need a check box, for the user to enable/disable the device.
    -   Mock-ups:

![](Neweditvmdialogmemoryballoon.png "Neweditvmdialogmemoryballoon.png")

*   **Validations**
    -   This should be acceptable on 3.1 cluster only, as older vds versions will not support it.

## Notes

1.  Due to API change, This will be supported in 3.1 clusters only.


---
title: Minimum guaranteed memory
category: sla
authors: didi, lhornyak
---

# Minimum guaranteed memory

#### Summary

#### Owner

*   Name: Martin Sivak (msivak)
*   Email: <msivak at redhat dot com>

#### Current status

*   Status: design
*   Last updated on -- by
*   patchset

#### Detailed Description

This feature ensures that VMs will always have certain amount of memory available in an environment managed by MoM and Baloon device.

#### Benefit to oVirt

This lays foundation of proper memory SLA and QoS management in oVirt.

## Design and Implementation

see : [/SLA-mom-ballooning-tp High-level](/SLA-mom-ballooning-tp High-level) for high-level design

#### GUI

No change needed, we already have a field for Minimal guaranteed memory in the VM settings. This value is currently used only for scheduling, but I intend to use it for the host level QoS as well.

#### Backend

Only the part that talks to VDSM needs to be updated. We need to transfer one more value to the host in all VM modifying commands. As it changes the VDSM - engine API we will have to modify VdsProperties, VmInfoBuilderBase to send VmStatic.minAllocatedMem to VDSM under the name "memGuaranteedSize". The value is in MiB.

#### DB Change

No change needed.

#### REST API

No change needed.

#### VDSM

VDSM has to support the new memGuaranteedSize provided by engine and return the additional balloon_min value from getVmBalloonInfo with that value. So first we have to store the value. VM.conf will contain memGuaranteedSize key that will be passed to VDSM from the engine (in MiB) using the standard xml-rpc methods. We also need to add support for the following snippet to the DOM xml:

` `<memtune>
`   `<min_guarantee>`value in KiB`</min_guarantee>
` `</memtune>

We deal with this part of the DOM XML in VM constructor (vdsm/vm.py) and tests/libvirtvmTests.py

#### MoM

MoM already supports minimal required memory while shrinking, but computes it as a percentage of used and free memory. This will need to be updated to take the balloon_min into account as well in the balloon.rules file.

#### Upgrade

There should be no issue with engine upgrades. The values are already in the DB. Even if VDSM is too old, it won't cause any issues, it will just ignore the value. MoM requires the balloon_min value after this change, so it needs a newer version of VDSM. So if we upgrade only the engine, the host is still ok. When we upgrade the host, we have to have both new vdsm and MoM.

#### Permissions

### Tests

*   We have to test that the guaranteed memory value gets transferred to VDSM
*   We have to test that the libvirt DOM XML contains the value
*   We have to test that MoM obeys it

#### Expected unit-tests

-

### Special considerations

*   How do we enable the balloon from the engine? A checkbox in Cluster/Optimizations?

### Dependencies / Related Features

Affected ovirt projects:

*   API
*   backend
*   Webadmin
*   User Portal

Others projects:

*   vdsm
*   mom

### Documentation / External references



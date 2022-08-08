---
title: HostPMMultipleAgents
category: feature
authors: emesika
---

# Host PM Multiple Agents

## Hosts Power Management Multiple Agents Support

### Summary

The Host Power Management feature allows the oVirt engine to remotely control the host power in order to execute the fencing command as part of the high availability features, or allow the user to manually commit remote operations as PowerOff, PowerOn, and Restart.

### Owner

*   Name: Simon Grinberg


### Current status

The current implementation of the Power Management is focused on supporting the most popular power management device, while there is no support for topologies where redundant power supply exists which requires supporting additional power management device.

*   Last updated date: Nov 4 2012

### Detailed Description

When planing the power management feature for the hosts there are few orthogonal aspects to consider

1. Supported Power Management Devices

2. Fencing logic, meaning how to determine a host requires fencing.

3. Power Management logic, meaning when and how to use the power management mechanism to automatically reduce power consumption in the data center

4. Power Management Proxy Selection

This page is focused at the moment on item #1 and when discussion will go into the other then it will be split into relevant topics.

### Power Management Proxy

oVirt curently supports only one Power Management Agent per Host. This requires to add the ability to specify, per host, multiple power management devices options in priority. Per option need to specify which device to use as primary device and which as secondary device.

The proposal (but not final design, this should be created in the detailed design page), is to support two power management devices per host. Can be done via two tabs in the host properties, instead of one today.

*   Redundant cards may have two topologies, As far as the Engine is concerned. This is since the only operation provided by the Engine are PowerOff, PowerOn, and Restart that is a sequence of off and then on.
    -   Sequential: Tab1 has higher priority then tab2 - In this case first device should be used, and if fencing operation fails then use the second device
    -   Concurrent: Like in the case of double power supply, in this case fencing should be done to both concurrently, meaning both should be powered off and then on or fencing will not take effect.

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

Example from HP for redundant power supply with separate management used to be available in Figure II at
`http://h20566.www2.hp.com/portal/site/hpsc/public/kb/docDisplay/?docId=emr_na-c02510164&ac.admitted=1350494275400.876444892.199480143`
But the link is not working anymore.

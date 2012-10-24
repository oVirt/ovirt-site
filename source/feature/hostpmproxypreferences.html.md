---
title: HostPMProxyPreferences
category: feature
authors: emesika, simong, yair zaslavsky
wiki_category: Feature
wiki_title: Features/HostPMProxyPreferences
wiki_revision_count: 18
wiki_last_updated: 2012-11-11
---

# Host PM Proxy Preferences

Note this is Work In Progress for now

## Hosts Power Management

### Summary

The Host Power Management feature allows the oVirt engine to remotely control the host power in order to execute the fencing command as part of the high availability features, or allow the user to manually commit remote operations as PowerOff, PowerOn, and Restart.

### Owner

*   Name: [ Simon Grinberg](User:MyUser)

<!-- -->

*   Email: sgrinber@redhat.com

### Current status

The current implementation of the Power Management is focused on supporting the most popular power management device, while the fencing proxi selection is naive, and there is no support for topologies where redundant power supply exists which requires supporting additional power management device.

*   Last updated date:

### Detailed Description

When planing the power management feature for the hosts there are few orthogonal aspects to consider

1. Supported Power Management Devices

2. Fencing logic, meaning how to determine a host requires fencing.

3. Power Management logic, meaning when and how to use the power management mechanism to automatically reduce power consumption in the data center

4. Power Management Proxy Selection

This page is focused at the moment on item #4 and when discussion will go into the other then it will be split into relevant topics.

### Power Management Proxy

oVirt uses the standard cluster fence_<device> script in order to perform power management related operations. These scripts are invoked by VDSM and controlled by the engine. The power management proxy may be any server the system that has VDSM installed with the proper certificates, even if it is not a host.

Proper proxy selection depends on the networking topology of the data center, user preferences and whether there is a redundant fencing device.

Current design assumes any host in the data center may be used for fencing which requires all the hosts to have rout to all the fencing devices in the system, in reality out of band management networks are usually confined within the same clusters and sometimes even to specific hosts.

This requires to add the ability to specify, per host, multiple power management devices options in priority. Per option need to specify which device to use and which proxy to use, where there may be multiple proxies with set priorities for using these proxies.

Proxy options may be:

1.  **Engine**: The the server hosting the engine. This requires to install VDSM on this host
2.  **DC**: A host in the same data center
3.  **Cluster**: A host in the same cluster
4.  **IP/FQDN**: A specific host

The proposal (but not final design, this should be created in the detailed design page), is to support two power management devices per host. Can be done via two tabs in the host properties, instead of one today.

Each tab contains:

Device configuration - as today

Proxy list (new field). Where proxy may be provided as coma separated list:

*   Examples:
    -   Cluster, Engine
    -   fqdn1/ip1,fqdn2/ip2
    -   Cluster
    -   Cluster, DC

Redundant cards may have two topologies, As far as the Engine is concerned. This is since the only operation provided by the Engine are PowerOff, PowerOn, and Restart that is a sequence of off and then on.

*   Sequential: Tab1 has higher priority then tab2 - In this case first device should be used, and if fencing operation fails then use the second device
*   Concurrent: Like in the case of double power supply, in this case fencing should be done to both concurrently, meaning both should be powered off and then on or fencing will not take effect.

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

### Documentation / External references

[ <http://h20566.www2.hp.com/portal/site/hpsc/public/kb/docDisplay/?docId=emr_na-c02510164&ac.admitted=1350494275400.876444892.199480143> Example from HP for redundant power supply with separate management - see Figure II]

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>

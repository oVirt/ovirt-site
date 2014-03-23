---
title: AdvancedForemanIntegration
authors: moti, ovedo, ybronhei
wiki_title: Features/AdvancedForemanIntegration
wiki_revision_count: 47
wiki_last_updated: 2014-11-10
---

# Advanced Foreman Integration

## Foreman Integration

### Summary

[Foreman](http://theforeman.org/) [1] The Foreman is a complete lifecycle management tool for physical and virtual servers. Through deep integration with configuration management, DHCP, DNS, TFTP, and PXE-based unattended installations, Foreman manages every stage of the lifecycle of your physical or virtual servers. The Foreman provides comprehensive, auditable interaction facilities including a web frontend and robust, RESTful API. [Cloud-init](https://launchpad.net/cloud-init/) [1] is a tool used to perform initial setup on cloud nodes, including networking, SSH keys, timezone, user data injection, and more. It is a service that runs on the guest, and supports various Linux distributions including Fedora, RHEL, and Ubuntu.

Integrating Foreman with oVirt will help adding hypervisor hosts that are managed by Foreman to the oVirt engine (installed hosts, discovered hosts, etc.) VM configuration and etc. Today, there is basic Foreman integration, described in [2], which allows the administrator to see hosts installed in Foreman, and get their basic details. This feature aims to extend this integration to cover other aspects such as Bare-Metal provisioning, VM provisioning and Host configuration.

### Owners

*   Name: Yaniv Bronheim
*   Email: ybronhei@redhatdotcom
*   Name: Oved Ourfali
*   Email: ovedo@redhatdotcom

### Current Status

Design phase

### Detailed Description

#### Use Cases

The following use-cases assume you already have a Foreman provider in the system. For more information on adding Foreman providers have a look at [2].

##### Bare-Metal provisioning

prerequisites:

*   Foreman admin has designated a host group(s) in foreman for that purpose
*   That Host group has the relevant templates (PXE / kickstart files ) associated with that host group for the relevant OSs
*   oVirt needs proper credentials to view relevant bare-metal hosts and host groups.
*   For now we assume a host group has all the required defaults needed to provision the host

User-flow:

1.  add a host in oVirt, which will be selected from a list of discovered hosts taken from Foreman (show the hosts in a provider sub-tab)
2.  select a host group for this host
3.  set the proper configuration needed for it (location/environment/other relevant properties)
4.  Press Okay
5.  Now, that will trigger the following system flow:
    1.  add the host to foreman using the API
    2.  Now there is a split:
        1.  RHEV-H hosts - will do the registration to the engine (assuming the kernel params are configured for that template)
        2.  RHEL hosts - at first step won't do the registration by themselves, but foreman will do that using a plugin (plugin will send RestAPI call to add the host , or could it just register it same like RHEVH ? need to check)

6.  The host now appears in the oVirt UI, it is being approved, we can modify the host properties, and bootstrapping starts.

Open issues:

1.  How to register the host in case of RHEL? What would be the oVirt API for that? Is it the same as the RHEV-H one?
2.  The proposal above assumes the operation is triggered from the Provider discovery sub-tab, which is different from the current way we add hosts. Need to verify that it is acceptable

**\1**

**API Design**

*   Engine/Backend/DB

**Additional changes**

### Benefit to oVirt

*   Better integration with external host providers, that will ease the work for the administrator
*   Providing an interface that other host providers can implement, to add their own properties and logic

### Dependencies / Related Features

### Documentation / External References

1.  Foreman homepage: <http://theforeman.org/>
2.  Basic Foreman integration feature page : <http://ovirt.org/Features/ForemanIntegration>

### Comments and Discussion

*   Refer to [Talk:Advanced Foreman Integration](Talk:Advanced Foreman Integration)

---
title: AdvancedForemanIntegration
authors: moti, ovedo, ybronhei
wiki_title: Features/AdvancedForemanIntegration
wiki_revision_count: 47
wiki_last_updated: 2014-11-10
---

# Advanced Foreman Integration

### Summary

[Foreman](http://theforeman.org/) [1] The Foreman is a complete lifecycle management tool for physical and virtual servers. Through deep integration with configuration management, DHCP, DNS, TFTP, and PXE-based unattended installations, Foreman manages every stage of the lifecycle of your physical or virtual servers. The Foreman provides comprehensive, auditable interaction facilities including a web frontend and robust, RESTful API. [Cloud-init](https://launchpad.net/cloud-init/) [1] is a tool used to perform initial setup on cloud nodes, including networking, SSH keys, timezone, user data injection, and more. It is a service that runs on the guest, and supports various Linux distributions including Fedora, RHEL, and Ubuntu.

Integrating Foreman with oVirt will help adding hypervisor hosts that are managed by Foreman to the oVirt engine (installed hosts, discovered hosts, etc.) VM configuration and etc.

Today, there is basic Foreman integration, described in [2], which allows the administrator to see hosts installed in Foreman, and get their basic details. This feature aims to extend this integration to cover other aspects such as Bare-Metal provisioning, VM provisioning and Host configuration.

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

##### First phase - Bare-Metal provisioning

Prerequisites:

*   Foreman admin has a designated host group(s) in foreman for that purpose to define full provision setup with default values
*   Have the proper images for the OS installation setup in the foreman setup
*   Correlate the defined Host group with relevant templates (PXE / kickstart files) associated to the relevant OSs

* For oVirt Node provisioning also provide appropriate cmdline arguments inside the PXE provision template, such as:

      append initrd=<%= @initrd %> ks=<%= foreman_url('provision')%> root=live:/[filename].iso BOOTIF=link storage_init rhevm_admin_password=123 adminpw=123 management_server=[ip]:[port] rootfstype=auto ro liveimg check RD_NO_LVM rd_NO_MULTIPATH rootflags=ro crashkernel=128M elevator=deadline quiet max_loop=256 rhgb rd_NO_LUKS rd_NO_MD rd_NO_DM ONERROR LOCALBOOT 0 

*   oVirt needs proper permissions to view relevant bare-metal hosts and host groups
*   Set Foreman's compute resource that correlates to the required permissions (Availability to approve and add host by custom plugin. For more information about Foreman plugin see [3])

User-flow:

1.  Add a host in oVirt, which will be selected from a list of discovered hosts taken from Foreman (show the hosts in a provider sub-tab)
2.  select a host group for this host
3.  set the proper configuration needed for it (location/environment/other relevant properties)
4.  Press Okay
5.  Now, the following system flow will occur:
    1.  add the host to foreman using the API (Provision the discovered host)
    2.  Now there is a split:
        1.  oVirt-node hosts - the registration will occur through the oVirt-node (assuming the kernel parameters are configured for that Foreman template)
        2.  regular hosts- at first step won't do the registration by themselves, but foreman will do that using a plugin (plugin will send REST-API call to add the host , or could it just register it same like oVirt-node?

6.  The host now appears in the oVirt UI, and when approving the host we can modify the host properties, and bootstrapping starts

Open issues:

1.  How to register the host in case of a regular host? What would be the oVirt API for that? Is it the same as the oVirt-node one?
2.  The proposal above assumes the operation is triggered from the Provider discovery sub-tab, which is different from the current way we add hosts. Need to verify that it is acceptable

##### Second phase - VM provisioning - add new VMs which will be configured by Foreman

We have two options here: a. Add the VM through oVirt, and then add it to Foreman as bare-metal (add the oVirt compute resource) - only PXE installation, passing the MAC address to foreman b. Add the VM through foreman (using compute resource)

I'd go with option "a", as it leaves the VM creation similar to what we have today. However, we don't really leverage oVirt templates with that approach.

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
3.  Foreman plugin examples: <http://projects.theforeman.org/projects/foreman/wiki/How_to_Create_a_Plugin>

### Comments and Discussion

*   Refer to [Talk:Advanced Foreman Integration](Talk:Advanced Foreman Integration)

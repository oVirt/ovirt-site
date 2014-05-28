---
title: AdvancedForemanIntegration
authors: moti, ovedo, ybronhei
wiki_title: Features/AdvancedForemanIntegration
wiki_revision_count: 47
wiki_last_updated: 2014-11-10
---

# Advanced Foreman Integration

![](Cover2.png "Cover2.png")

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

*   Approving final design concepts and last curve of implementation phase for tech preview
*   Using Foreman 1.6-develop version

### Detailed Description

#### Use Cases

*   The following use-cases assume you already have a Foreman provider in the system. For more information on adding Foreman providers have a look at [2].
*   Foreman setup must include the following plugins (for plugin installation guide follow [3]):

      * `[`https://github.com/bronhaim/ovirt-provision-plugin`](https://github.com/bronhaim/ovirt-provision-plugin)` (>=0.0.1)- Allows full integration with oVirt after provisioning new host
      * `[`https://github.com/theforeman/foreman_discovery`](https://github.com/theforeman/foreman_discovery)` (>=1.3.0.rc2)- Foreman pack for bare metal discovery feature

##### First phase - Bare-Metal provisioning

Prerequisites:

*   Foreman admin has a designated host group(s) in foreman for that purpose to define full provision setup with default values
*   Have the proper images for the OS installation setup in the foreman setup
*   Correlate the defined Host group with relevant templates (PXE / kickstart files) associated to the relevant OSs

* For oVirt Node provisioning also provide appropriate cmdline arguments inside the PXE provision template, such as:

      append initrd=<%= @initrd %> ks=<%= foreman_url('provision')%> root=live:/[filename].iso BOOTIF=link storage_init rhevm_admin_password=123 adminpw=123 management_server=[ip]:[port] rootfstype=auto ro liveimg check RD_NO_LVM rd_NO_MULTIPATH rootflags=ro crashkernel=128M elevator=deadline quiet max_loop=256 rhgb rd_NO_LUKS rd_NO_MD rd_NO_DM ONERROR LOCALBOOT 0 

*   oVirt needs proper permissions to view relevant bare-metal hosts, host groups, compute resources and execute provision request.
*   Set Foreman's compute resource that correlates to the required permissions (Availability to approve and add host by custom plugin. For more information about Foreman plugin see [3])
*   Define puppet class for installing oVirt-Engine public key to allow deploy oVirt on provisioned host

* For example:

      class ovirt-pk {                                                                
             # create a directory                                                    
             file { "/root/.ssh":                                                    
                     ensure => "directory",                                          
                     before => File['/root/.ssh/authorized_keys'],                   
             }                                                                       
             file { "/root/.ssh/authorized_keys":                                    
                     path => '/root/.ssh/authorized_keys',                           
                     ensure => file,                                                 
                     source => "puppet:///modules/ovirt-pk/authorized_keys",         
             }                                                                       
      }   

<big>**User-flow:**</big>
![](Discover-1-phase.png "fig:Discover-1-phase.png")
![](Discover-2-phase.png "fig:Discover-2-phase.png")
![](Discover-3-phase.png "fig:Discover-3-phase.png")
# Add new host form in oVirt shows new list of discovered hosts taken from Foreman ![](Discover-4-phase.png "fig:Discover-4-phase.png")

1.  Select a host group for this host. all proper configuration needs to be declared in host group definition (part of Foreman setup)
2.  Select compute resource to allow access back from Foreman to oVirt (part of Foreman setup)
3.  All "discovered" information will filled out in the new host form, edit them as desired
4.  Press Okay

![](Discover-5-phase.png "Discover-5-phase.png")

1.  the following system flow will occur:
    1.  add the host to foreman using the API (Provision the discovered host)
    2.  The host will be added and appear in the oVirt UI with status "Installing OS" util the following ends:
        1.  For oVirt-node hosts - the registration will occur through the oVirt-node (assuming the kernel parameters are configured for that Foreman template), and the host will be approved automatically by Foreman
        2.  For other OS - at first step won't do the registration by themselves, but foreman will do that using a plugin (plugin will send REST-API call to add or approve the host)

![](installingOSExample.png "installingOSExample.png")

Open issues:

##### Second phase - VM provisioning - add new VMs which will be configured by Foreman

We have two options here: a. Add the VM through oVirt, and then add it to Foreman as bare-metal (add the oVirt compute resource) - only PXE installation, passing the MAC address to foreman b. Add the VM through foreman (using compute resource)

I'd go with option "a", as it leaves the VM creation similar to what we have today. However, we don't really leverage oVirt templates with that approach.

### Benefit to oVirt

*   Better integration with external host providers, that will ease the work for the administrator
*   Providing an interface that other host providers can implement, to add their own properties and logic

### Dependencies / Related Features

### Documentation / External References

1.  Foreman homepage: <http://theforeman.org/>
2.  Basic Foreman integration feature page : <http://ovirt.org/Features/ForemanIntegration>
3.  Foreman plugin examples: <http://projects.theforeman.org/projects/foreman/wiki/How_to_Create_a_Plugin>

### Known issues for followup

*   <http://projects.theforeman.org/issues/5781>

### Comments and Discussion

*   Refer to [Talk:Advanced Foreman Integration](Talk:Advanced Foreman Integration)

---
title: ForemanIntegration
category: feature
authors: ovedo, ybronhei
wiki_category: Feature
wiki_title: Features/ForemanIntegration
wiki_revision_count: 19
wiki_last_updated: 2015-01-22
---

# Foreman Integration

### Summary

[Foreman](http://theforeman.org/) [1] The Foreman is a complete lifecycle management tool for physical and virtual servers. Through deep integration with configuration management, DHCP, DNS, TFTP, and PXE-based unattended installations, Foreman manages every stage of the lifecycle of your physical or virtual servers. The Foreman provides comprehensive, auditable interaction facilities including a web frontend and robust, RESTful API. [Cloud-init](https://launchpad.net/cloud-init/) [1] is a tool used to perform initial setup on cloud nodes, including networking, SSH keys, timezone, user data injection, and more. It is a service that runs on the guest, and supports various Linux distributions including Fedora, RHEL, and Ubuntu.

Integrating Foreman with oVirt will help adding hypervisor hosts that are managed by Foreman to the oVirt engine (installed hosts, discovered hosts, etc.) VM configuration and etc.

### Owner

*   Name: Oved Ourfali
*   Email: ovedo@redhatdotcom

### Current Status

Implementation

### Detailed Description

#### Use Cases

In the Foreman integration feature we plan to support the following use-cases:

##### Adding installed Foreman hosts as oVirt hosts

When adding a new host to oVirt, the administrator has to know in advance different details about the host, such as the FQDN, root password, power management options and etc. In this feature we will add a checkbox saying whether to show "external" hosts in the host dialog (external hosts are Foreman hosts, but in the future we might support other providers as well), and if so the hosts will be loaded from Foreman, and displayed in the external hosts list box. Once a user selects a host, it will automatically set the address as the FQDN we got from Foreman (non-changeable), and also set the name of the host to the FQDN (as a suggestion, changeable).

Screenshot 1 - The user didn't choose to show external providers

![](New-host-dialog-providers.png "New-host-dialog-providers.png")

Screenshot 2 - The user chose to see the external providers, and he selects one of them. A free text search is shown (provider specific search), and the user can either write a search query, or just press the search button, which will retrieve all hosts.

![](Selected-provider.png "Selected-provider.png")

Screenshot 3 - Selecting a host. The name and address were updated automatically (and in the future also other properties)

![](Selected-host-from-provider.png "Selected-host-from-provider.png")

Screenshot 4 - All the details that the host provider set, are updated automatically. The host address is grayed out. All the rest is editable.

![](Selected-host-properties.png "Selected-host-properties.png")

**\1**

**API Design** No changes in the API. The external provider's hosts will be shown only in the UI.

*   Engine/Backend/DB
    -   Adding the provider DB/engine/UI and etc. is covered in another feature, <http://www.ovirt.org/Features/Detailed_Quantum_Integration>.
    -   Additional changes:
        -   Adding a host provider interface, with implementation for Foreman
        -   The host provider will currently support listing hosts, filtered listing of hosts (we might add in the future a textbox in the add-host-dialog to support freetext search criteria), and testing connection (useful in the add provider dialog).
        -   Adding a query to get a provider by type (to get all the foreman providers)
        -   Adding a query to get all provider hosts

### Benefit to oVirt

*   Better integration with external host providers, that will ease the work for the administrator
*   Providing an interface that other host providers can implement, to add their own properties and logic

### Dependencies / Related Features

Related features:

*   Network provider feature - the network provider feature introduces the Provider entity, which is used by this feature

### Documentation / External References

1.  Foreman homepage: <http://theforeman.org/>

### Comments and Discussion

*   Refer to [Talk:Foreman Integration](Talk:Foreman Integration)

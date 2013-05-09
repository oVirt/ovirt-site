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

**Use Cases** **'Adding installed Foreman hosts as oVirt hosts**' When adding a new host to oVirt, the administrator has to know in advance different details about the host, such as the FQDN, root password, power management options and etc. In this feature we will add a checkbox saying whether to show "external" hosts in the host dialog (external hosts are Foreman hosts, but in the future we might support other providers as well), and if so the hosts will be loaded from Foreman, and displayed in the external hosts list box. Once a user selects a host, it will automatically set the address as the FQDN we got from Foreman (non-changeable), and also set the name of the host to the FQDN (as a suggestion, changeable).

See the following screenshot:

**\1**

**API Design**

### Required Changes

*   UI
*   REST API
*   Engine/Backend/Db

### Benefit to oVirt

### Dependencies / Related Features

Related features:

### Documentation / External References

1.  Foreman homepage: <http://theforeman.org/>

### Comments and Discussion

*   Refer to [Talk:Foreman Integration](Talk:Foreman Integration)

---
title: Default / Secure CPU Type Concept
category: feature
authors:
  - ljelinko
  - mskrivan
---

# Default / Secure CPU Type Concept

## Summary

Improve the maintainability of oVirt CPU Types by supporting only _default_ and _secure_ version of each CPU microarchitecture.

## Owner

*   Name: Lucia Jelinkova (ljelinko)

*   Email: <ljelinko@redhat.com>

## Detailed Description

oVirt keeps a list of supported CPU Types in the vdc_options table in the database under the key ServerCPUList. Previously, with every security update a new CPU Type was created for ALL affected architectures. Consequently, the list grew in length and looked like this:

- Intel Broadwell Client Family
- Intel Broadwell Client IBRS Family'
- Intel Broadwell Client IBRS SSBD Family'
- Intel Broadwell Client IBRS SSBD MDS Family
- Intel Skylake Client Family
- Intel Skylake Client IBRS Family'
- Intel Skylake Client IBRS SSBD Family'
- Intel Skylake Client IBRS SSBD MDS Family
- Intel Skylake Server Family
- Intel Skylake Server IBRS Family'
- Intel Skylake Server IBRS SSBD Family'
- Intel Skylake Server IBRS SSBD MDS Family

In order to keep the CPU list manageable, only 2 CPU Types are now supported for any CPU microarchitecture that has security updates. 

- Intel Broadwell Client Family
- Secure Intel Broadwell Client Family'
- Intel Skylake Client Family
- Secure Intel Skylake Client Family'
- Intel Skylake Server Family
- Secure Intel Skylake Server Family'

The _default_ CPU Type will not change over the time while the _secure_ CPU type will contain the latest updates. 

## Prerequisites
Previously, it was not possible to simply update the CPU Type configuration because all hosts that would not comply to the new configuration would become non operational.

To ensure that the hosts are operational even after the CPU configuration is changed, we store the currently used configuration in the cluster table. That ensures that even after configuration in vdc_options table is changed, the hosts stay operational. 

When all cluster hosts are compatible with the changed CPU, the cluster table is automatically updated to contain the same configuration as vdc_options table. 

## Benefit to oVirt

Improved maintainability of supported CPU Types.

## User Experience

If the CPU configuration is different in the cluster table than in the vdc_options table, it is important to notify the user. The following warnings are displayed in the UI:

### Administration Portal

#### Cluster
On a Clusters list page, the status column shows a warning icon in case the cluster has hosts that are not fully compatible with the cluster CPU Type configurations.

![](/images/wiki/secure-cpus-cluster-list-warning.png)

#### Host
On a Hosts list page, the status column shows a warning icon in case the host is not fully compatible with the current CPU Type configuration. The warning also lists all flags that are required by the configuration, but are not available on the host. 

![](/images/wiki/secure-cpus-host-list-warning.png)

#### VM
On a Virtual Machines list page, the status column shows a warning icon in case the virtual machine's CPU configuration is not the same as the configuration for cluster CPU Type.

![](/images/wiki/secure-cpus-vm-list-warning.png)

On a Virtual Machine detail page, the Guest CPU field shows a warning icon in case the virtual machine's CPU configuration is not the same as the configuration for cluster CPU Type. It also contains additional information about the current configuration for cluster CPU Type.

![](/images/wiki/secure-cpus-vm-detail-warning.png)
### REST API
These changes do to affect the REST API (except for the CPU Type rename). 

## Installation/Upgrade

During engine setup, the existing CPU Types are renamed and changed either to _default_ or _secure_ CPU Type. 

## User work-flows

1. User has cluster with 2 hosts named A and B
2. User updates oVirt engine and the update contains also new CPU microcode security updates
3. User opens the Administration Portal and sees a warning on the cluster in the Clusters list view that there are hosts not compatible with the current CPU Type configuration
4. User opens Host list view and sees that there are warnings on hosts A and B
5. User puts host A into the maintenance, updates the microcode and activates the host. The warning on the Host A disappears
6. User puts host B into the maintenance, updates the microcode and activates the host. The warning on the Host B disappears
7. There is no warning on the cluster in the Cluster list view


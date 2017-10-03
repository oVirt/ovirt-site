---
title: Introduction to Hypervisor Hosts
---

# Chapter 5: Introduction to Hypervisor Hosts

oVirt supports two types of hosts: oVirt Node and Enterprise Linux host. Depending on your environment requirement, you may want to use one type only or both in your oVirt environment. It is recommended that you install and attach at least two hosts to the oVirt environment. Where you attach only one host you will be unable to access features such as migration and high availability.

**Important:** SELinux is in enforcing mode upon installation. To verify, run `getenforce`. SELinux is required to be in enforcing mode on all hypervisors and Engine for your oVirt environment.

**Hosts**

| Host Type | Other Names | Description |
|-
| **oVirt Node** | Thin host | This is a minimal operating system based on Enterprise Linux. It is distributed as an ISO file and contains only the packages required for the machine to act as a host. |
| **Enterprise Linux Host** | EL-based hypervisor, thick host | Red Hat Enterprise Linux or CentOS can be used as hosts. |

## Host Compatibility Matrix

The following table outlines the supported host versions in each compatibility version of oVirt.

**Note:** The latest version of VDSM is backwards compatible with all previous versions of oVirt.

**Host Compatibility Matrix**

| Supported EL or oVirt Node Version | 3.6 | 4.0 | 4.1
|-
| 7.0 | ✓ |   |   |
| 7.1 | ✓ |   |   |
| 7.2 | ✓ | ✓ |   |
| 7.3 |   | ✓ | ✓ |
| 7.4 |   |   | ✓ |


When you create a new data center, you can set the compatibility version. Select the compatibility version that suits all the hosts in the data center. Once set, version regression is not allowed. For a fresh oVirt installation, the latest compatibility version is set in the Default Data Center and Default Cluster; to use an older compatibility version, you must create additional data centers and clusters.

**Prev:** [Chapter 4: oVirt Engine Related Tasks](../chap-oVirt_Engine_Related_Tasks) <br>
**Next:** [Chapter 6: oVirt Nodes](../chap-oVirt_Nodes)

# Introduction to Hosts

Red Hat Virtualization supports two types of hosts: Red Hat Virtualization Host (RHVH) and Red Hat Enterprise Linux host. Depending on your environment requirement, you may want to use one type only or both in your Red Hat Virtualization environment. It is recommended that you install and attach at least two hosts to the Red Hat Virtualization environment. Where you attach only one host you will be unable to access features such as migration and high availability.

**Important:** SELinux is in enforcing mode upon installation. To verify, run `getenforce`. SELinux is required to be in enforcing mode on all hypervisors and Managers for your Red Hat Virtualization environment to be supported by Red Hat.

**Hosts**

| Host Type | Other Names | Description |
|-
| **Red Hat Virtualization Host** | RHVH, thin host | This is a minimal operating system based on Red Hat Enterprise Linux. It is distributed as an ISO file from the Customer Portal and contains only the packages required for the machine to act as a host. |
| **Red Hat Enterprise Linux Host** | RHEL-based hypervisor, thick host | Red Hat Enterprise Linux hosts subscribed to the appropriate channels can be used as hosts. |

* [Host Compatibility Matrix](Host_Compatibility_Matrix)

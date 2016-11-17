# Introduction to Red Hat Virtualization

Red Hat Virtualization is an enterprise-grade server and desktop virtualization platform built on Red Hat Enterprise Linux. This guide covers:

* The installation and configuration of a Red Hat Virtualization Manager.
* The installation and configuration of hosts.
* Attach existing FCP storage to your Red Hat Virtualization environment. More storage options can be found in the [Administration Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide/#chap-Storage).

**Red Hat Virtualization Key Components**

| Component Name | Description |
|-
| Red Hat Virtualization Manager | A server that manages and provides access to the resources in the environment. |
| Hosts | Hosts are servers that provide the processing capabilities and memory resources used to run virtual machines. |
| Storage | Storage is used to store the data associated with virtual machines. |

**Important:** It is important to synchronize the system clocks of the hosts, Manager, and other servers in the environment to avoid potential timing or authentication issues. To do this, configure the Network Time Protocol (NTP) on each system to synchronize with the same NTP server.





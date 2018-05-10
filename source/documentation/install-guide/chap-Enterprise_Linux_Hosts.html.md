---
title: Enterprise Linux Hosts
---

# Chapter 7: Enterprise Linux Hosts

## Installing Enterprise Linux Hosts

An Enterprise Linux host (such as CentOS or RHEL), also known as an EL-based hypervisor is based on a standard basic installation of an Enterprise Linux operating system on a physical server.

Ensure that you have required repositories for your distribution.
On CentOS the Base, Optional and Extras repositories are already enabled by default and must be enabled.
On Red Hat Enterprise Linux you'll need a valid subscription and the following repositories enabled:

  - rhel-7-server-rpms 
  - rhel-7-server-optional-rpms
  - rhel-7-server-extras-rpms

To prepare the server to be included as a oVirt host just subscribe it to the oVirt project repository.
   For oVirt 4.2:

  `   # yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm)

See [Appendix G: Configuring a Hypervisor Host for PCI Passthrough](../appe-Configuring_a_Hypervisor_Host_for_PCI_Passthrough) for more information on how to enable the host hardware and software for device passthrough.

**Important:** Virtualization must be enabled in your host's BIOS settings. For information on changing your host's BIOS settings, refer to your host's hardware documentation.

**Important:** Third-party watchdogs should not be installed on Red Hat Enterprise Linux hosts, as they can interfere with the watchdog daemon provided by VDSM.

**Prev:** [Chapter 6: oVirt Nodes](../chap-oVirt_Nodes) <br>
**Next:** [Chapter 8: Adding a Hypervisor](../chap-Adding_a_Hypervisor)

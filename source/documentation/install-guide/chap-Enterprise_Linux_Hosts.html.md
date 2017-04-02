---
title: Enterprise Linux Hosts
---

# Chapter 7: Enterprise Linux Hosts

## Installing Enterprise Linux Hosts

An Enterprise Linux host (such as CentOS or RHEL), also known as an EL-based hypervisor is based on a standard basic installation of an Enterprise Linux operating system on a physical server.

See [Appendix G: Configuring a Hypervisor Host for PCI Passthrough](../appe-Configuring_a_Hypervisor_Host_for_PCI_Passthrough) for more information on how to enable the host hardware and software for device passthrough.

**Important:** Virtualization must be enabled in your host's BIOS settings. For information on changing your host's BIOS settings, refer to your host's hardware documentation.

**Important:** Third-party watchdogs should not be installed on Red Hat Enterprise Linux hosts, as they can interfere with the watchdog daemon provided by VDSM.

**Prev:** [Chapter 6: oVirt Nodes](../chap-oVirt_Nodes) <br>
**Next:** [Chapter 8: Adding a Hypervisor](../chap-Adding_a_Hypervisor)

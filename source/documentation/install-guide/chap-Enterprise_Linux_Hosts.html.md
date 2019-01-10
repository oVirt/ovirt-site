---
title: Enterprise Linux Hosts
---

# Chapter 7: Enterprise Linux Hosts

## Installing Enterprise Linux Hosts

An Enterprise Linux host (such as CentOS or RHEL), also known as an EL-based hypervisor is based on a standard basic installation of an Enterprise Linux operating system on a physical server.

The host must meet the minimum Host requirements out lined in [Chapter 2: System Requirements](chap-System_Requirements).

See [Appendix G, Configuring a Host for PCI Passthrough](appe-Configuring_a_Host_for_PCI_Passthrough) for more information on how to enable the host hardware and software for device passthrough.

**Important:** Virtualization must be enabled in your host's BIOS settings. For information on changing your host's BIOS settings, refer to your host's hardware documentation.

**Important:** Third-party watchdogs should not be installed on Red Hat Enterprise Linux hosts, as they can interfere with the watchdog daemon provided by VDSM.


## Installing Cockpit on Enterprise Linux Hosts

You can install a Cockpit user interface for monitoring the host’s resources and performing administrative tasks.

**Installing Cockpit on Enterprise Linux Hosts**

1. By default, when adding a host to the oVirt Engine, the Engine configures the required firewall ports. See [Chapter 8: Adding a Host to the oVirt Engine](chap-Adding_a_Host_to_the_oVirt_Engine) for details. However, if you disable Automatically configure host firewall when adding the host, manually configure the firewall according to the “Host Firewall Requirements” in [Chapter 2: System Requirements](chap-System_Requirements).

2. Install the dashboard packages:

      # yum install cockpit-ovirt-dashboard

3. Enable and start the cockpit.socket service:

      # systemctl enable cockpit.socket
      # systemctl start cockpit.socket

4. You can log in to the Cockpit user interface at https://HostFQDNorIP:9090.

**Prev:** [Chapter 6: oVirt Nodes](chap-oVirt_Nodes) <br>
**Next:** [Chapter 8: Adding a Host to the oVirt Engine](chap-Adding_a_Host_to_the_oVirt_Engine)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/installation_guide/chap-red_hat_enterprise_linux_hosts)

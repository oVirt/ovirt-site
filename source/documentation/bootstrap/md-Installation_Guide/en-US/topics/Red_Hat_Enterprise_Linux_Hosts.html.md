# Installing Red Hat Enterprise Linux Hosts

A Red Hat Enterprise Linux host, also known as a RHEL-based hypervisor is based on a standard basic installation of Red Hat Enterprise Linux on a physical server, with `Red Hat Enterprise Linux Server` and the `Red Hat Virtualization` entitlements enabled. For detailed installation instructions, see [Red Hat Enterprise Linux 7 Installation Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/index.html).

See [Configuring a Hypervisor Host for PCI Passthrough](appe-Configuring_a_Hypervisor_Host_for_PCI_Passthrough) for more information on how to enable the host hardware and software for device passthrough.

**Important:** Virtualization must be enabled in your host's BIOS settings. For information on changing your host's BIOS settings, refer to your host's hardware documentation.

**Important:** Third-party watchdogs should not be installed on Red Hat Enterprise Linux hosts, as they can interfere with the watchdog daemon provided by VDSM.

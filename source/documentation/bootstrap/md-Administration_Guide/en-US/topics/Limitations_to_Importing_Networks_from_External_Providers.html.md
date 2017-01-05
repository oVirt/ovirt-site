# Limitations to Using External Provider Networks

The following limitations apply to using logical networks imported from an external provider in a Red Hat Virtualization environment.

* Logical networks offered by external providers must be used as virtual machine networks, and cannot be used as display networks.

* The same logical network can be imported more than once, but only to different data centers.

* You cannot edit logical networks offered by external providers in the Manager. To edit the details of a logical network offered by an external provider, you must edit the logical network directly from the external provider that provides that logical network.

* Port mirroring is not available for virtual network interface cards connected to logical networks offered by external providers.

* If a virtual machine uses a logical network offered by an external provider, that provider cannot be deleted from the Manager while the logical network is still in use by the virtual machine.

* Networks offered by external providers are non-required. As such, scheduling for clusters in which such logical networks have been imported will not take those logical networks into account during host selection. Moreover, it is the responsibility of the user to ensure the availability of the logical network on hosts in clusters in which such logical networks have been imported.

**Important:** Logical networks imported from external providers are only compatible with Red Hat Enterprise Linux hosts and cannot be assigned to virtual machines running on RHVH.

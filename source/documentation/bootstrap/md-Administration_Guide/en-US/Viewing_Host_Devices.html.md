# Viewing Host Devices

You can view the host devices for each host in the details pane. If the host has been configured for direct device assignment, these devices can be directly attached to virtual machines for improved performance.

For more information on the hardware requirements for direct device assignment, see [Additional Hardware Considerations for Using Device Assignment](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/hardware-considerations-for-implementing-sr-iov/#Additional_Considerations) in *Red Hat Virtualization Hardware Considerations for Implementing SR-IOV*. 

For more information on configuring the host for direct device assignment, see [Configuring a Host for PCI Passthrough](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/installation-guide/appendix-g-configuring-a-hypervisor-host-for-pci-passthrough) in the *Installation Guide*.

For more information on attaching host devices to virtual machines, see [Host Devices](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/virtual-machine-management-guide/610-host-devices) in the *Virtual Machine Management Guide*.

**Viewing Host Devices**

1. Use the **Hosts** resource tab, tree mode, or the search function to find and select a host from the results list.

2. Click the **Host Devices** tab in the details pane.

The details pane lists the details of the host devices, including whether the device is attached to a virtual machine, and currently in use by that virtual machine.



# Hardware Considerations For Device Assignment

If you plan to implement device assignment and PCI passthrough so that a virtual machine can use a specific PCIe device from a host, ensure the following requirements are met:

* CPU must support IOMMU (for example, VT-d or AMD-Vi). IBM POWER8 supports IOMMU by default.

* Firmware must support IOMMU.

* CPU root ports used must support ACS or ACS-equivalent capability.

* PCIe device must support ACS or ACS-equivalent capability.

* It is recommended that all PCIe switches and bridges between the PCIe device and the root port should support ACS. For example, if a switch does not support ACS, all devices behind that switch share the same IOMMU group, and can only be assigned to the same virtual machine.

* For GPU support, Red Hat Enterprise Linux 7 supports PCI device assignment of NVIDIA K-Series Quadro (model 2000 series or higher), GRID, and Tesla as non-VGA graphics devices. Currently up to two GPUs may be attached to a virtual machine in addition to one of the standard, emulated VGA interfaces. The emulated VGA is used for pre-boot and installation and the NVIDIA GPU takes over when the NVIDIA graphics drivers are loaded. Note that the NVIDIA Quadro 2000 is not supported, nor is the Quadro K420 card.

Refer to vendor specification and datasheets to confirm that hardware meets these requirements. After you have installed a host, see [Configuring a Hypervisor Host for PCI Passthrough](appe-Configuring_a_Hypervisor_Host_for_PCI_Passthrough) for more information on how to enable the host hardware and software for device passthrough.

To implement SR-IOV, see [https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/hardware-considerations-for-implementing-sr-iov/](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/hardware-considerations-for-implementing-sr-iov/) for more information.

The `lspci -v` command can be used to print information for PCI devices already installed on a system.

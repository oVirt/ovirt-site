# Kernel Settings Explained

The **Kernel** settings table details the information required on the **Kernel** tab of the **New Host** or **Edit Host** window. Common kernel boot parameter options are listed as check boxes so you can easily select them. For more complex changes, use the free text entry field next to **Kernel command line** to add in any additional parameters required.</para>

**Important:** If the host is attached to the Manager already, ensure you place the host into maintenance mode before applying any changes. You will need to reinstall the host by clicking **Reinstall**, and then reboot the host after the reinstallation is complete for the changes to take effect.

**Kernel Settings**

| Field Name | Description |
|-
| **Hostdev Passthrough &amp; SR-IOV** | Enables the IOMMU flag in the kernel to allow a host device to be used by a virtual machine as if the device is a device attached directly to the virtual machine itself. The host hardware and firmware must also support IOMMU. The virtualization extension and IOMMU extension must be enabled on the hardware. See [Configuring a Host for PCI Passthrough](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/installation-guide/appendix-g-configuring-a-hypervisor-host-for-pci-passthrough) in the *Installation Guide*. IBM POWER8 has IOMMU enabled by default. |
| **Nested Virtualization** | Enables the vmx or svm flag to allow you to run virtual machines within virtual machines. This option is only intended for evaluation purposes and not supported for production purposes. The `vdsm-hook-nestedvt` hook must be installed on the host. |
| **Unsafe Interrupts**  | If IOMMU is enabled but the passthrough fails because the hardware does not support interrupt remapping, you can consider enabling this option. Note that you should only enable this option if the virtual machines on the host are trusted; having the option enabled potentially exposes the host to MSI attacks from the virtual machines. This option is only intended to be used as a workaround when using uncertified hardware for evaluation purposes. |
| **PCI Reallocation** | If your SR-IOV NIC is unable to allocate virtual functions because of memory issues, consider enabling this option. The host hardware and firmware must also support PCI reallocation. This option is only intended to be used as a workaround when using uncertified hardware for evaluation purposes. |
| **Kernel command line** | This field allows you to append more kernel parameters to the default parameters. |

**Note:** If the kernel boot parameters are grayed out, click the **reset** button and the options will be available.

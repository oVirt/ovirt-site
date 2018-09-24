---
title: Configuring a Host for PCI Passthrough
---

# Appendix G: Configuring a Host for PCI Passthrough

Enabling PCI passthrough allows a virtual machine to use a host device as if the device were directly attached to the virtual machine. To enable the PCI passthrough function, you need to enable virtualization extensions and the IOMMU function. The following procedure requires you to reboot the host. If the host is attached to the Engine already, ensure you place the host into maintenance mode before running the following procedure.

**Prerequisites:**

* Ensure that the host hardware meets the requirements for PCI device passthrough and assignment. See [Chapter 2: System Requirements](../chap-System_Requirements) for more information.

**Configuring a Host for PCI Passthrough**

1. Enable the virtualization extension and IOMMU extension in the BIOS.

2. Enable the IOMMU flag in the kernel by selecting the **Hostdev Passthrough & SR-IOV** check box when adding the host to the Manager or by editing the `grub` configuration file manually.

    * To enable the IOMMU flag from the Administration Portal, see "Adding a Host to the oVirt Engine" and "Kernel Settings Explained" in the [Administration Guide](/documentation/admin-guide/administration-guide/).

    * To edit the `grub` configuration file manually, see Enabling IOMMU Manually below.

3. For GPU passthrough, you need to run additional configuration steps on both the host and the guest system. See "Preparing Host and Guest Systems for GPU Passthrough" in the [Administration Guide](/documentation/admin-guide/administration-guide/) for more information.

**Enabling IOMMU Manually**

1. Enable IOMMU by editing the grub configuration file.

    **Note:** If you are using IBM POWER8 hardware, skip this step as IOMMU is enabled by default.

    * For Intel, boot the machine, and append `intel_iommu=on` to the end of the `GRUB_CMDLINE_LINUX` line in the `grub` configuration file.

            # vi /etc/default/grub
            ...
            GRUB_CMDLINE_LINUX="nofb splash=quiet console=tty0 ... intel_iommu=on
            ...

    * For AMD, boot the machine, and append `amd_iommu=on` to the end of the `GRUB_CMDLINE_LINUX` line in the `grub` configuration file.

            # vi /etc/default/grub
            ...
            GRUB_CMDLINE_LINUX="nofb splash=quiet console=tty0 ... amd_iommu=on
            ...

    **Note:** If `intel_iommu=on` or `amd_iommu=on` works, you can try replacing them with `intel_iommu=pt` or `amd_iommu=pt`. The `pt` option only enables IOMMU for devices used in passthrough and will provide better host performance. However, the option may not be supported on all hardware. Revert to previous option if the `pt` option doesn't work for your host.

    If the passthrough fails because the hardware does not support interrupt remapping, you can consider enabling the `allow_unsafe_interrupts` option if the virtual machines are trusted. The `allow_unsafe_interrupts` is not enabled by default because enabling it potentially exposes the host to MSI attacks from virtual machines. To enable the option:

        # vi /etc/modprobe.d
        options vfio_iommu_type1 allow_unsafe_interrupts=1

2. Refresh the `grub.cfg` file and reboot the host for these changes to take effect:

        # grub2-mkconfig -o /boot/grub2/grub.cfg

        # reboot

**Prev:** [Appendix F: Installing the Websocket Proxy on a Separate Machine](../appe-Installing_the_Websocket_Proxy_on_a_Separate_Machine)
**Next:** [Appendix H: Preparing a Host for vGPU Installation](../appe-Preparing_a_Host_for_vGPU_Installation)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/installation_guide/appe-configuring_a_hypervisor_host_for_pci_passthrough)

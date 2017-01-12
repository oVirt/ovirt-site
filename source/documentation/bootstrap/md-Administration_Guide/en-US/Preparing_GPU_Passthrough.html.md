# Preparing Host and Guest Systems for GPU Passthrough

The Graphics Processing Unit (GPU) device from a host can be directly assigned to a virtual machine. Before this can be achieved, both the host and the virtual machine require amendments to their `grub` configuration files. You can edit the host `grub` configuration file using the **Kernel command line** free text entry field in the Administration Portal. Both the host machine and the virtual machine require reboot for the changes to take effect.

This procedure is relevant for hosts with either x86_64 or ppc64le architecture.

For more information on the hardware requirements for direct device assignment, see [PCI Device Requirements](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/installation-guide/#PCI_Device_Requirements) in the *Installation Guide*.

**Important:** If the host is attached to the Manager already, ensure you place the host into maintenance mode before applying any changes.

**Preparing a Host for GPU Passthrough**

1. From the Administration Portal, select a host.

2. Click the **General** tab in the details pane, and click **Hardware**. Locate the GPU device `vendor ID:product ID`. In this example, the IDs are `10de:13ba` and `10de:0fbc`.

3. Right-click the host and select **Edit**. Click the **Kernel** tab.

4. In the **Kernel command line** free text entry field, enter the IDs located in the previous steps.

        pci-stub.ids=10de:13ba,10de:0fbc

5. Blacklist the corresponding drivers on the host. For example, to blacklist nVidia's nouveau driver, next to `pci-stub.ids=xxxx:xxxx`, enter **rdblacklist=nouveau**.

        pci-stub.ids=10de:13ba,10de:0fbc rdblacklist=nouveau

6. Click **OK** to save the changes.

7. Click **Reinstall** to commit the changes to the host.

8. Reboot the host after the reinstallation is complete.

**Note:** To confirm the device is bound to the `pci-stub` driver, run the `lspci` command:

    # lspci -nnk
    ...
    01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GM107GL [Quadro K2200] [10de:13ba] (rev a2)
            Subsystem: NVIDIA Corporation Device [10de:1097]
            Kernel driver in use: pci-stub
    01:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:0fbc] (rev a1)
            Subsystem: NVIDIA Corporation Device [10de:1097]
            Kernel driver in use: pci-stub
    ...

For instructions on how to make the above changes by editing the `grub` configuration file manually, see [Preparing Host and Guest Systems for GPU Passthrough](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Virtualization/3.6/html-single/Administration_Guide/index.html#Preparing_GPU_Passthrough) in the 3.6 *Administration Guide*.

Proceed to the next procedure to configure GPU passthrough on the guest system side.

**Preparing a Guest Virtual Machine for GPU Passthrough**

* For Linux

    1. Only proprietary GPU drivers are supported. Black list the corresponding open source driver in the `grub` configuration file. For example:

            $ vi /etc/default/grub
            ...
            GRUB_CMDLINE_LINUX="nofb splash=quiet console=tty0 ... rdblacklist=nouveau"
            ...

    2. Locate the GPU BusID. In this example, is BusID is `00:09.0`.

            # lspci | grep VGA
            00:09.0 VGA compatible controller: NVIDIA Corporation GK106GL [Quadro K4000] (rev a1)

    3. Edit the `/etc/X11/xorg.conf` file and append the following content:

            Section "Device"
            Identifier "Device0"
            Driver "nvidia"
            VendorName "NVIDIA Corporation"
            BusID "PCI:0:9:0"
            EndSection

    4. Restart the virtual machine.

* For Windows

    1. Download and install the corresponding drivers for the device. For example, for Nvidia drivers, go to [NVIDIA Driver Downloads](http://www.nvidia.com/Download/index.aspx?lang=en-us).

    2. Restart the virtual machine.

The host GPU can now be directly assigned to the prepared virtual machine. For more information on assigning host devices to virtual machines, see [Host Devices](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/virtual-machine-management-guide/610-host-devices) in the *Virtual Machine Management Guide*.


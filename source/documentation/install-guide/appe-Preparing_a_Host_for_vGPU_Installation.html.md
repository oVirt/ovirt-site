---
title: Preparing a Host for vGPU Installation
---

# Appendix H: Preparing a Host for vGPU Installation

You can use a host with a compatible graphics processing unit (GPU) to run virtual machines with virtual GPUs (vGPUs). A virtual machine with a vGPU is better suited for graphics-intensive tasks than a virtual machine without
a vGPU. A virtual machine with a vGPU can also run software that cannot run without a GPU, such as CAD.

**vGPU Requirements**

If you plan to configure a host to allow virtual machines on that host to install a vGPU, the following requirements must be met:

* vGPU-compatible GPU
* GPU-enabled host kernel
* Installed GPU with correct drivers
* Predefined **mdev_type** set to correspond with one of the mdev types supported by the device
* vGPU-capable drivers installed on each host in the cluster
* vGPU-supported virtual machine operating system with vGPU drivers installed

**Preparing a Host for vGPU Installation**

1. Install vGPU-capable drivers onto your host. Consult the documentation for your GPU card for more information.

2. Install **vdsm-hook-vfio-mdev**:

        # yum install vdsm-hook-vfio-mdev

You can now install vGPUs on the virtual machines running on this host.

**Installing a vGPU on a Virtual Machine**


1. Confirm the vGPU instance to use:

  * Click **Compute** &rarr; **Hosts**, click the required host’s name to go to the details view, and click the **Host Devices** tab. Available vGPU instances appear in the **Mdev Types** column.

  * Alternatively, run the following command on the host:

        # vdsm-client Host hostdevListByCaps

    Available vGPU instances appear in the **mdev** key **available_instances**.    

2. Install the required virtual machine operating system.

3. Shut down the virtual machine.

4. Add the vGPU instance to the virtual machine:

  i. Select the virtual machine and click Edit.
  ii. Click Show Advanced Options, then click the **Custom Properties** tab.
  iii. Select **mdev_type** from the drop-down list and enter the vGPU instance in the text field.
  iv. Click OK.

5. Start the virtual machine and install the vGPU driver through the vendor’s installer. Consult the documentation for your GPU card for more information.

6. Restart the virtual machine.

7. Verify that the vGPU is recognized by checking the virtual machine operating system’s device manager.

**Important:** You cannot migrate a virtual machine using a vGPU to a different host. When upgrading the virtual machine, verify the operating system and GPU vendor support in the vendor’s documentation.

**Prev:** [Appendix G: Configuring a Host for PCI Passthrough](../appe-Configuring_a_Host_for_PCI_Passthrough)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/installation_guide/preparing_a_host_for_vgpu_installation)

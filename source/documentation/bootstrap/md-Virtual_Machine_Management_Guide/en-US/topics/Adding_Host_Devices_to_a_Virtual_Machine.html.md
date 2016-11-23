# Adding a Host Device to a Virtual Machine

Virtual machines can be directly attached to the host devices for improved performance if a compatible host has been configured for direct device assignment.

**Adding Host Devices to a Virtual Machine**

1. Select a virtual machine and click the **Host Devices** tab in the details pane to list the host devices already attached to this virtual machine. A virtual machine can only have devices attached from the same host. If a virtual machine has attached devices from one host, and you attach a device from another host, the attached devices from the previous host will be automatically removed.

    Attaching host devices to a virtual machine requires the virtual machine to be in a `Down` state. If the virtual machine is running, the changes will not take effect until after the virtual machine has been shut down.

2. Click **Add device** to open the **Add Host Devices** window.

3. Use the **Pinned Host** dropdown menu to select a host.

4. Use the **Capability** dropdown menu to list the `pci`, `scsi`, or `usb_device` host devices.

5. Select the check boxes of the devices to attach to the virtual machine from the **Available Host Devices** pane and click the directional arrow button to transfer these devices to the **Host Devices to be attached** pane, creating a list of the devices to attach to the virtual machine.

6. When you have transferred all desired host devices to the **Host Devices to be attached** pane, click **OK** to attach these devices to the virtual machine and close the window.

These host devices will be attached to the virtual machine when the virtual machine is next powered on. 



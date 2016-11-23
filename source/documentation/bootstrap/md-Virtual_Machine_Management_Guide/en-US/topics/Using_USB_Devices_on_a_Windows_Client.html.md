# Using USB Devices on a Windows Client

The `usbdk` driver must be installed on the Windows client for the USB device to be redirected to the guest. Ensure the version of `usbdk` matches the architecture of the client machine. For example, the 64-bit version of `usbdk` must be installed on 64-bit Windows machines.

**Using USB Devices on a Windows Client**

1. When the `usbdk` driver is installed, select a virtual machine that has been configured to use the SPICE protocol.

2. Ensure USB support is set to **Native**:

    1. Click **Edit**.

    2. Click the **Console** tab.

    3. Select **Native** from the **USB Support** drop-down list.

    4. Click **OK**.

3. Click the **Console Options** button and select the **Enable USB Auto-Share** check box.

4. Start the virtual machine and click the **Console** button to connect to that virtual machine. When you plug your USB device into the client machine, it will automatically be redirected to appear on your guest machine.

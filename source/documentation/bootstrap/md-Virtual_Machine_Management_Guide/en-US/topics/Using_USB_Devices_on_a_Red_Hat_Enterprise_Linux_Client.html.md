# Using USB Devices on a Red Hat Enterprise Linux Client

The `usbredir` package enables USB redirection from Red Hat Enterprise Linux clients to virtual machines. `usbredir` is a dependency of the `virt-viewer` package, and is automatically installed together with that package.

**Using USB devices on a Red Hat Enterprise Linux client**

1. Click the **Virtual Machines** tab and select a virtual machine that has been configured to use the SPICE protocol.

2. Ensure USB support is set to **Native**:

    1. Click **Edit**.

    2. Click the **Console** tab.

    3. Select **Native** from the **USB Support** drop-down list.

    4. Click **OK**.

3. Click the **Console Options** button and select the **Enable USB Auto-Share** check box.

4. Start the virtual machine and click the **Console** button to connect to that virtual machine. When you plug your USB device into the client machine, it will automatically be redirected to appear on your guest machine.

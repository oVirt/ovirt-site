# Hot Plugging Virtual Memory

You can hot plug virtual memory. Hot plugging means enabling or disabling devices while a virtual machine is running. Each time memory is hot plugged, it appears as a new memory device in the **Vm Devices** tab in the details pane, up to a maximum of 16. When the virtual machine is shut down and restarted, these devices are cleared from the **Vm Devices** tab without reducing the virtual machine's memory, allowing you to hot plug more memory devices.

**Important:** Hot unplugging virtual memory is not currently supported in Red Hat Virtualization.

**Hot Plugging Virtual Memory**

1. Click the **Virtual Machines** tab and select a running virtual machine.

2. Click **Edit**.

3. Click the **System** tab.

4. Edit the **Memory Size** as required. Memory can be added in multiples of 256 MB.

5. Click **OK**.

    This action opens the **Next Start Configuration** window, as the **MemSizeMb** value will not change until the virtual machine is restarted. However, the hot plug action is triggered by the change to the **memory** value, which can be applied immediately.

    **Hot Plug Virtual Memory**

    ![](images/7327.png)

6. Clear the **Apply later** check box to apply the change immediately.

7. Click **OK**.

The virtual machine's **Defined Memory** is updated in the **General** tab in the details pane. You can see the newly added memory device in the **Vm Devices** tab in the details pane.

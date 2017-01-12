# Configuring Host Power Management Settings

Configure your host power management device settings to perform host life-cycle operations (stop, start, restart) from the Administration Portal.

It is necessary to configure host power management in order to utilize host high availability and virtual machine high availability.

**Important:** Ensure that your host is in `maintenance mode` before configuring power management settings. Otherwise, all running virtual machines on that host will be stopped ungracefully upon restarting the host, which can cause disruptions in production environments. A warning dialog will appear if you have not correctly set your host to `maintenance mode.`

**Configuring Power Management Settings**

1. In the **Hosts** tab, select the host in the results list.

2. Click **Edit** to open the **Edit Host** window.

3. Click the **Power Management** tab to display the Power Management settings.

4. Select the **Enable Power Management** check box to enable the fields.

5. Select the **Kdump integration** check box to prevent the host from fencing while performing a kernel crash dump.

    **Important:** When you enable **Kdump integration** on an existing host, the host must be reinstalled for kdump to be configured. See [Reinstalling Virtualization Hosts](Reinstalling_Virtualization_Hosts).

6. Optionally, select the **Disable policy control of power management** check box if you do not want your host's power management to be controlled by the **Scheduling Policy** of the host's **cluster**.

7. Click the plus (**+**) button to add a new power management device. The **Edit fence agent** window opens.

8. Enter the **Address**, **User Name**, and **Password** of the power management device into the appropriate fields.

9. Select the power management device **Type** from the drop-down list.

10. Enter the **SSH Port** number used by the power management device to communicate with the host.

11. Enter the **Slot** number used to identify the blade of the power management device.

12. Enter the **Options** for the power management device. Use a comma-separated list of `'key=value'` entries.

13. Select the **Secure** check box to enable the power management device to connect securely to the host.

14. Click **Test** to ensure the settings are correct. *Test Succeeded, Host Status is: on* will display upon successful verification.

15. Click **OK** to close the **Edit fence agent** window.

16. In the **Power Management** tab, optionally expand the **Advanced Parameters** and use the up and down buttons to specify the order in which the Manager will search the host's **cluster** and **dc** (datacenter) for a fencing proxy.

17. Click **OK**.

The **Power Management** drop-down menu is now enabled in the Administration Portal.

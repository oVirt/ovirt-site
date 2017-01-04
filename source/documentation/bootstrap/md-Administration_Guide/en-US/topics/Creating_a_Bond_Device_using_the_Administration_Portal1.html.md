# Creating a Bond Device Using the Administration Portal

You can bond compatible network devices together. This type of configuration can increase available bandwidth and reliability. You can bond multiple network interfaces, pre-existing bond devices, and combinations of the two. A bond can carry both VLAN tagged and non-VLAN traffic.

**Creating a Bond Device using the Administration Portal**

1. Click the **Hosts** resource tab, and select the host in the results list.

2. Click the **Network Interfaces** tab in the details pane to list the physical network interfaces attached to the host.

3. Click **Setup Host Networks** to open the **Setup Host Networks** window.

4. Select and drag one of the devices over the top of another device and drop it to open the **Create New Bond** window. Alternatively, right-click the device and select another device from the drop-down menu.

    If the devices are incompatible, the bond operation fails and suggests how to correct the compatibility issue.

5. Select the **Bond Name** and **Bonding Mode** from the drop-down menus.

    Bonding modes 1, 2, 4, and 5 can be selected. Any other mode can be configured using the **Custom** option.

6. Click **OK** to create the bond and close the **Create New Bond** window.

7. Assign a logical network to the newly created bond device.

8. Optionally choose to **Verify connectivity between Host and Engine** and **Save network configuration**.

9. Click **OK** accept the changes and close the **Setup Host Networks** window.

Your network devices are linked into a bond device and can be edited as a single interface. The bond device is listed in the **Network Interfaces** tab of the details pane for the selected host.

Bonding must be enabled for the ports of the switch used by the host. The process by which bonding is enabled is slightly different for each switch; consult the manual provided by your switch vendor for detailed information on how to enable bonding.

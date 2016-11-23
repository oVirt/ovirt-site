# Configuring Multiple Displays for Windows Virtual Machines

A maximum of four displays can be configured for a single Windows virtual machine when connecting to the virtual machine using the SPICE protocol.

1. Click the **Virtual Machines** tab and select a virtual machine.

2. With the virtual machine in a powered-down state, click **Edit**.

3. Click the **Console** tab.

4. Select the number of displays from the **Monitors** drop-down list.

    **Note:** This setting controls the maximum number of displays that can be enabled for the virtual machine. While the virtual machine is running, additional displays can be enabled up to this number.

5. Click **Ok**.

6. Start a SPICE session with the virtual machine.

7. Open the **View** drop-down menu at the top of the SPICE client window.

8. Open the **Display** menu.

9. Click the name of a display to enable or disable that display.

    **Note:** By default, **Display 1** is the only display that is enabled on starting a SPICE session with a virtual machine. If no other displays are enabled, disabling this display will close the session.

# Accessing Cockpit from the Administration Portal

The Cockpit UI plug-in is an optional feature that can be installed in Red Hat Virtualization environments. The plug-in provides access to the Cockpit user interface, used for monitoring and administering host resources, through the Administration Portal. When a host with Cockpit installed is selected, the **Cockpit** sub-tab shows the Cockpit user interface directly in the details pane in the Administration Portal. Alternatively, the **Cockpit** button in the main **Hosts** menu opens the Cockpit user interface in a new browser tab. 

The Cockpit user interface is available by default on Red Hat Virtualization Host (RHVH). It is currently not supported on Red Hat Enterprise Linux hosts.

**Accessing Cockpit from the Administration Portal**

1. Install the Cockpit UI plug-in on the Manager machine:

        # yum install cockpit-ovirt-uiplugin

2. Restart the `ovirt-engine` service:

        # systemctl restart ovirt-engine.service

3. In the Administration Portal, click the **Hosts** tab and select a host. 

4. Open the Cockpit user interface in a new tab, or view it directly through the Administration Portal: 

    * Right-click the host and select **Cockpit** to open the Cockpit user interface in a new browser tab.

    * Click the **Cockpit** sub-tab to view the Cockpit user interface in the details pane of the **Hosts** tab.

        **Note:** If Cockpit is not available on the selected host, the Cockpit sub-tab shows basic troubleshooting steps.

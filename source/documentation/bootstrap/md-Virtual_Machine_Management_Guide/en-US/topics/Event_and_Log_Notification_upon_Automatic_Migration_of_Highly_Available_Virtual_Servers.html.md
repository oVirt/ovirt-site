# Event and Log Notification upon Automatic Migration of Highly Available Virtual Servers

When a virtual server is automatically migrated because of the high availability function, the details of an automatic migration are documented in the **Events** tab and in the engine log to aid in troubleshooting, as illustrated in the following examples:

**Notification in the Events Tab of the Web Admin Portal**

Highly Available `Virtual_Machine_Name` failed. It will be restarted automatically.

`Virtual_Machine_Name` was restarted on Host `Host_Name`

**Notification in the Manager engine.log**

This log can be found on the Red Hat Virtualization Manager at `/var/log/ovirt-engine/engine.log`:

Failed to start Highly Available VM. Attempting to restart. VM Name: `Virtual_Machine_Name`, VM Id:`Virtual_Machine_ID_Number`

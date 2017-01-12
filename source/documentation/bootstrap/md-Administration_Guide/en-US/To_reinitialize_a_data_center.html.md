# Re-Initializing a Data Center: Recovery Procedure

This recovery procedure replaces the master data domain of your data center with a new master data domain; necessary in the event of data corruption of your master data domain. Re-initializing a data center allows you to restore all other resources associated with the data center, including clusters, hosts, and non-problematic storage domains.

You can import any backup or exported virtual machines or templates into your new master data domain.

**Re-Initializing a Data Center**

1. Click the **Data Centers** resource tab and select the data center to re-initialize.

2. Ensure that any storage domains attached to the data center are in maintenance mode.

3. Right-click the data center and select **Re-Initialize Data Center** from the drop-down menu to open the **Data Center Re-Initialize** window.

4. The **Data Center Re-Initialize** window lists all available (detached; in maintenance mode) storage domains. Click the radio button for the storage domain you are adding to the data center.

5. Select the **Approve operation** check box.

6. Click **OK** to close the window and re-initialize the data center.

The storage domain is attached to the data center as the master data domain and activated. You can now import any backup or exported virtual machines or templates into your new master data domain.

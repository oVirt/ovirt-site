# Moving Storage Domains to Maintenance Mode

Detaching and removing storage domains requires that they be in maintenance mode. This is required to redesignate another data domain as the master data domain.

Expanding iSCSI domains by adding more LUNs can only be done when the domain is active.

**Moving storage domains to maintenance mode**

1. Shut down all the virtual machines running on the storage domain.

2. Click the **Storage** resource tab and select a storage domain.

3. Click the **Data Centers** tab in the details pane.

4. Click **Maintenance** to open the **Storage Domain maintenance** confirmation window.

5. Click **OK** to initiate maintenance mode. The storage domain is deactivated and has an `Inactive` status in the results list.

You can now edit, detach, remove, or reactivate the inactive storage domains from the data center.

**Note:** You can also activate, detach and place domains into maintenance mode using the Storage tab on the details pane of the data center it is associated with.

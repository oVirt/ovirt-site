# Detaching a Storage Domain from a Data Center

Detaching a storage domain from a data center will stop the data center from associating with that storage domain. The storage domain is not removed from the Red Hat Virtualization environment; it can be attached to another data center.

Data, such as virtual machines and templates, remains attached to the storage domain.

**Note:** The master storage, if it is the last available storage domain, cannot be removed.

**Detaching a Storage Domain from a Data Center**

1. Click the **Data Centers** resource tab and select the appropriate data center.

2. Select the **Storage** tab in the details pane to list the storage domains attached to the data center.

3. Select the storage domain to detach. If the storage domain is `Active`, click **Maintenance** to open the **Maintenance Storage Domain(s)** confirmation window.

4. Click **OK** to initiate maintenance mode.

5. Click **Detach** to open the **Detach Storage** confirmation window.

6. Click **OK**.

You have detached the storage domain from the data center. It can take up to several minutes for the storage domain to disappear from the details pane.

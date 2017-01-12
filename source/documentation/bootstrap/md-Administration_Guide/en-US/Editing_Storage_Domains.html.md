# Editing Storage Domains

You can edit storage domain parameters through the Administration Portal. Depending on the state of the storage domain, either active or inactive, different fields are available for editing. Fields such as **Data Center**, **Domain Function**, **Storage Type**, and **Format** cannot be changed.

* **Active**: When the storage domain is in an active state, the **Name**, **Description**, **Comment**, **Warning Low Space Indicator (%)**, **Critical Space Action Blocker (GB)**, and **Wipe After Delete** fields can be edited. The **Name** field can only be edited while the storage domain is active. All other fields can also be edited while the storage domain is inactive.

* **Inactive**: When the storage domain is in maintenance mode or unattached, thus in an inactive state, you can edit all fields except **Name**, **Data Center**, **Domain Function**, **Storage Type**, and **Format**. The storage domain must be inactive to edit storage connections, mount options, and other advanced parameters. This is only supported for NFS, POSIX, and Local storage types.

    **Note:** iSCSI storage connections cannot be edited via the Administration Portal, but can be edited via the REST API. See [Updating an iSCSI Storage Connection](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/rest-api-guide/#Updating_an_iSCSI_Storage_Connection) in the *REST API Guide*.

**Editing an Active Storage Domain**

1. Click the **Storage** tab and select a storage domain.

2. Click **Edit**.

3. Edit the available fields as required.

4. Click **OK**.

**Editing an Inactive Storage Domain**

1. Click the **Storage** tab and select a storage domain.

2. If the storage domain is active, click the **Data Center** tab in the details pane and click **Maintenance**.

3. Click **Edit**.

4. Edit the storage path and other details as required. The new connection details must be of the same storage type as the original connection.

5. Click **OK**.

6. Click the **Data Center** tab in the details pane and click **Activate**.






# Creating a Storage Volume

You can create new volumes using the Administration Portal. When creating a new volume, you must specify the bricks that comprise the volume and specify whether the volume is to be distributed, replicated, or striped.

You must create brick directories or mountpoints before you can add them to volumes.

**Important:** It is recommended that you use replicated volumes, where bricks exported from different hosts are combined into a volume. Replicated volumes create copies of files across multiple bricks in the volume, preventing data loss when a host is fenced.

**Creating A Storage Volume**

1. Click the **Volumes** resource tab to list existing volumes in the results list.

2. Click **New** to open the **New Volume** window.

3. Use the drop-down menus to select the **Data Center** and **Volume Cluster**.

4. Enter the **Name** of the volume.

5. Use the drop-down menu to select the **Type** of the volume.

6. If active, select the appropriate **Transport Type** check box.

7. Click the **Add Bricks** button to select bricks to add to the volume. Bricks must be created externally on the Red Hat Gluster Storage nodes.

8. If active, use the **Gluster**, **NFS**, and **CIFS** check boxes to select the appropriate access protocols used for the volume.

9. Enter the volume access control as a comma-separated list of IP addresses or hostnames in the **Allow Access From** field.

    You can use the * wildcard to specify ranges of IP addresses or hostnames.

10. Select the **Optimize for Virt Store** option to set the parameters to optimize your volume for virtual machine storage. Select this if you intend to use this volume as a storage domain.

11. Click **OK** to create the volume. The new volume is added and displays on the **Volume** tab.

You have added a Red Hat Gluster Storage volume. You can now use it for storage.

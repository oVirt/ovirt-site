# Importing an Unregistered Disk Image from an Imported Storage Domain

Import floating virtual disks from a storage domain using the **Disk Import** tab of the details pane. Floating disks created outside of a Red Hat Virtualization environment are not registered with the Manager. Scan the storage domain to identify unregistered floating disks to be imported.

**Note:** Only QEMU-compatible disks can be imported into the Manager.

**Importing a Disk Image**

1. Select a storage domain that has been imported into the data center.

2. Right-click the storage domain and select **Scan Disks** so that the Manager can identify unregistered disks.

3. In the details pane, click **Disk Import**. 

4. Select one or more disk images and click **Import** to open the **Import Disk(s)** window.

5. Select the appropriate **Disk Profile** for each disk.

6. Click **OK** to import the selected disks.

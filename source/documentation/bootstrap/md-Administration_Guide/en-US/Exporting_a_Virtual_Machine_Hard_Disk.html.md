# Exporting a Virtual Machine Disk to an OpenStack Image Service

**Summary**

Virtual machine disks can be exported to an OpenStack Image Service that has been added to the Manager as an external provider.

1. Click the **Disks** resource tab.

2. Select the disks to export.

3. Click the **Export** button to open the **Export Image(s)** window.

4. From the **Domain Name** drop-down list, select the OpenStack Image Service to which the disks will be exported.

5. From the **Quota** drop-down list, select a quota for the disks if a quota is to be applied.

6. Click **OK**.

**Result**

The virtual machine disks are exported to the specified OpenStack Image Service where they are managed as virtual machine disk images.

**Important:** Virtual machine disks can only be exported if they do not have multiple volumes, are not thinly provisioned, and do not have any snapshots.

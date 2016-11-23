# Deleting a Snapshot

You can delete a virtual machine snapshot and permanently remove it from your Red Hat Virtualization environment. This operation is supported on a running virtual machine and does not require the virtual machine to be in a down state.

**Important:** When you delete a snapshot from an image chain, one of three things happens:

* If the snapshot being deleted is contained in a RAW (preallocated) base image, a new volume is created that is the same size as the base image.

* If the snapshot being deleted is contained in a QCOW2 (thin provisioned) base image, the volume subsequent to the volume containing the snapshot being deleted is extended to the cumulative size of the successor volume and the base volume.

* If the snapshot being deleted is contained in a QCOW2 (thin provisioned), non-base image hosted on internal storage, the successor volume is extended to the cumulative size of the successor volume and the volume containing the snapshot being deleted.

The data from the two volumes is merged in the new or resized volume. The new or resized volume grows to accommodate the total size of the two merged images; the new volume size will be, at most, the sum of the two merged images. To delete a snapshot, you must have enough free space in the storage domain to temporarily accommodate both the original volume and the newly merged volume. Otherwise, snapshot deletion will fail and you will need to export and re-import the volume to remove snapshots. For detailed information on snapshot deletion for all disk formats, see [https://access.redhat.com/solutions/527613](https://access.redhat.com/solutions/527613).

**Deleting a Snapshot**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Snapshots** tab in the details pane to list the snapshots for that virtual machine.

    **Snapshot List**

    ![](images/5602.png)

3. Select the snapshot to delete.

4. Click **Delete**.

5. Click **OK**.

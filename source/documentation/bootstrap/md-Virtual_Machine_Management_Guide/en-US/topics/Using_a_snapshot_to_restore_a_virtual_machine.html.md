# Using a Snapshot to Restore a Virtual Machine

A snapshot can be used to restore a virtual machine to its previous state.

**Using Snapshots to Restore Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Snapshots** tab in the details pane to list the available snapshots.

3. Select a snapshot to restore in the left side-pane. The snapshot details display in the right side-pane.

4. Click the drop-down menu beside **Preview** to open the **Custom Preview Snapshot** window.

    **Custom Preview Snapshot**

    ![](images/5031.png)

5. Use the check boxes to select the **VM Configuration**, **Memory**, and disk(s) you want to restore, then click **OK**. This allows you to create and restore from a customized snapshot using the configuration and disk(s) from multiple snapshots.

    **The Custom Preview Snapshot Window**

    ![](images/5032.png)

    The status of the snapshot changes to `Preview Mode`. The status of the virtual machine briefly changes to `Image Locked` before returning to `Down`.

6. Start the virtual machine; it runs using the disk image of the snapshot.

7. Click **Commit** to permanently restore the virtual machine to the condition of the snapshot. Any subsequent snapshots are erased.

8. Alternatively, click the **Undo** button to deactivate the snapshot and return the virtual machine to its previous state.

# Read Only Disks in Red Hat Virtualization

Some applications require administrators to share data with read-only rights. You can do this when creating or editing a disk attached to a virtual machine via the **Disks** tab in the details pane of the virtual machine and selecting the **Read Only** check box. That way, a single disk can be read by multiple cluster-aware guests, while an administrator maintains writing privileges.

You cannot change the read-only status of a disk while the virtual machine is running.

**Important:** Mounting a journaled file system requires read-write access. Using the **Read Only** option is not appropriate for virtual machine disks that contain such file systems (e.g. `EXT3`, `EXT4`, or `XFS`).


# Virtual Disk User Roles Explained

**Virtual Disk User Permission Roles**

The table below describes the user roles and privileges applicable to using and administrating virtual machine disks in the User Portal.

**Red Hat Virtualization System Administrator Roles**

| Role | Privileges | Notes |
|-
| DiskOperator | Virtual disk user. | Can use, view and edit virtual disks. Inherits permissions to use the virtual machine to which the virtual disk is attached. |
| DiskCreator | Can create, edit, manage and remove virtual machine disks within assigned clusters or data centers. | This role is not applied to a specific virtual disk; apply this role to a user for the whole environment with the **Configure** window. Alternatively apply this role for specific data centers, clusters, or storage domains. |

# Force Removing a Data Center

A data center becomes `Non Responsive` if the attached storage domain is corrupt or if the host becomes `Non Responsive`. You cannot **Remove** the data center under either circumstance.

**Force Remove** does not require an active host. It also permanently removes the attached storage domain.

It may be necessary to **Destroy** a corrupted storage domain before you can **Force Remove** the data center.

**Force Removing a Data Center**

1. Click the **Data Centers** resource tab and select the data center to remove.

2. Click **Force Remove** to open the **Force Remove Data Center** confirmation window.

3. Select the **Approve operation** check box.

4. Click **OK**

The data center and attached storage domain are permanently removed from the Red Hat Virtualization environment.

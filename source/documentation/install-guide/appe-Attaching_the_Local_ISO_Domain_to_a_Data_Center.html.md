---
title: Attaching the Local ISO Domain to a Data Center
---

# Appendix B: Attaching the Local ISO Domain to a Data Center

The local ISO domain, created during the Engine installation, appears in the Administration Portal as **Unattached**. To use it, attach it to a data center. The ISO domain must be of the same **Storage Type** as the data center. Each host in the data center must have read and write access to the ISO domain. In particular, ensure that the Storage Pool Engine has access.

Only one ISO domain can be attached to a data center.

**Attaching the Local ISO Domain to a Data Center**

1. In the Administration Portal, click **Compute &rarr; Data Centers** and select the appropriate data center.

2. Click the data center's name to go to the details view.

3. Click the **Storage** tab to list the storage domains already attached to the data center.

4. Click **Attach ISO** to open the **Attach ISO Library** window.

4. Click the radio button for the local ISO domain.

5. Click **OK**.

The ISO domain is now attached to the data center and is automatically activated.

**Prev:** [Appendix A: Changing the Permissions for the Local ISO Domain](../appe-Changing_the_Permissions_for_the_Local_ISO_Domain) <br>
**Next:** [Appendix C: Enabling Gluster Processes on Gluster Storage Nodes](../appe-Enabling_Gluster_Processes_on_Gluster_Storage_Nodes)

# Resolving Status Conflicts

**Summary**

A hook that does not have a consistent status across the servers and engine will be flagged as having a conflict. To resolve the conflict, select a status to be enforced across all servers in the environment.

**Resolving a Status Conflict**

1. Use the **Cluster** resource tab, tree mode, or the search function to find and select a cluster in the results list.

2. Select the **Gluster Hooks** sub-tab to list the hooks in the details pane.

3. Select the conflicting hook and click the **Resolve Conflicts** button to open the **Resolve Conflicts** window.

4. Set **Hook Status** to **Enable** or **Disable**.

5. Click **OK** to resolve the conflict and close the window.

**Result**

The selected status for the hook is enforced across the engine and the servers to be consistent across the environment.

# Resolving Content Conflicts

**Summary**

A hook that is not consistent across the servers and engine will be flagged as having a conflict. To resolve the conflict, you must select a version of the hook to be copied across all servers and the engine.

**Resolving a Content Conflict**

1. Use the **Cluster** resource tab, tree mode, or the search function to find and select a cluster in the results list.

2. Select the **Gluster Hooks** sub-tab to list the hooks in the details pane.

3. Select the conflicting hook and click the **Resolve Conflicts** button to open the **Resolve Conflicts** window.

4. Select the engine or a server from the list of sources to view the content of that hook and establish which version of the hook to copy.

    **Note:** The content of the hook will be overwritten in all servers and in the engine.

5. Use the **Use content from** drop-down menu to select the preferred server or the engine.

6. Click **OK** to resolve the conflict and close the window.

**Result**

The hook from the selected server is copied across all servers and the engine to be consistent across the environment.

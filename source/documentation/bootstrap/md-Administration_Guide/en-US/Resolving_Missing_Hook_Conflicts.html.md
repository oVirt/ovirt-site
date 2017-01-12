# Resolving Missing Hook Conflicts

**Summary**

A hook that is not present on all the servers and the engine will be flagged as having a conflict. To resolve the conflict, either select a version of the hook to be copied across all servers and the engine, or remove the missing hook entirely.

**Resolving a Missing Hook Conflict**

1. Use the **Cluster** resource tab, tree mode, or the search function to find and select a cluster in the results list.

2. Select the **Gluster Hooks** sub-tab to list the hooks in the details pane.

3. Select the conflicting hook and click the **Resolve Conflicts** button to open the **Resolve Conflicts** window.

4. Select any source with a status of **Enabled** to view the content of the hook.

5. Select the appropriate radio button, either **Copy the hook to all the servers** or **Remove the missing hook**. The latter will remove the hook from the engine and all servers.

6. Click **OK** to resolve the conflict and close the window.

** Result**

Depending on your chosen resolution, the hook has either been removed from the environment entirely, or has been copied across all servers and the engine to be consistent across the environment.

# Resolving Conflicts

The hooks are displayed in the **Gluster Hooks** sub-tab of the **Cluster** tab. Hooks causing a conflict are displayed with an exclamation mark. This denotes either that there is a conflict in the content or the status of the hook across the servers in the cluster, or that the hook script is missing in one or more servers. These conflicts can be resolved via the Manager. The hooks in the servers are periodically synchronized with engine database and the following conflicts can occur for the hooks:

* Content Conflict - the content of the hook is different across servers.

* Missing Conflict - one or more servers of the cluster do not have the hook.

* Status Conflict - the status of the hook is different across servers.

* Multiple Conflicts - a hook has a combination of two or more of the aforementioned conflicts.

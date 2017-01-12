# Reinstalling Hosts

Reinstall Red Hat Virtualization Hosts (RHVH) and Red Hat Enterprise Linux hosts from the Administration Portal. Use this procedure to reinstall RHVH from the same version of the RHVH ISO image from which it is currently installed; the procedure reinstalls VDSM on Red Hat Enterprise Linux hosts. This includes stopping and restarting the host. If migration is enabled at cluster level, virtual machines are automatically migrated to another host in the cluster; as a result, it is recommended that host reinstalls are performed at a time when the host's usage is relatively low.

The cluster to which the host belongs must have sufficient memory reserve in order for its hosts to perform maintenance. Moving a host with live virtual machines to maintenance in a cluster that lacks sufficient memory causes the virtual machine migration operation to hang and then fail. You can reduce the memory usage of this operation by shutting down some or all virtual machines before moving the host to maintenance.

**Important:** Ensure that the cluster contains more than one host before performing a reinstall. Do not attempt to reinstall all the hosts at the same time, as one host must remain available to perform Storage Pool Manager (SPM) tasks.

**Reinstalling Red Hat Virtualization Host or Red Hat Enterprise Linux hosts**

1. Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.

2. Click **Maintenance**. If migration is enabled at cluster level, any virtual machines running on the host are migrated to other hosts. If the host is the SPM, this function is moved to another host. The status of the host changes as it enters maintenance mode.

3. Click **Reinstall** to open the **Install Host** window.

4. Click **OK** to reinstall the host.

Once successfully reinstalled, the host displays a status of **Up**. Any virtual machines that were migrated off the host, are at this point able to be migrated back to it.

**Important:** After a Red Hat Virtualization Host is successfully registered to the Red Hat Virtualization Manager and then reinstalled, it may erroneously appear in the Administration Portal with the status of **Install Failed**. Click **Activate**, and the Host will change to an **Up** status and be ready for use.


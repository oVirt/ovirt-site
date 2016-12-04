# Updating Hosts

Use the host upgrade manager to update individual hosts directly from the Red Hat Virtualization Manager. The upgrade manager checks for and notifies you of available host updates, and reduces the time required by automating the process of putting the host into maintenance mode, updating packages, and bringing the host back up. On large deployments with many hosts, this automated process can save a significant amount of time.

On Red Hat Enterprise Linux hosts, the upgrade manager checks for updates to Red Hat Virtualization packages by default. You can specify additional packages for the upgrade manager to monitor for updates using the system configuration value `UserPackageNamesForCheckUpdate`. This value accepts wildcards. Run the `engine-config` command on the Manager machine. For example: 

    # engine-config -m UserPackageNamesForCheckUpdate=vdsm-hook-ethtool-options

**Warning:** For other updates, such as security fixes for the operating system, you must manually update Red Hat Enterprise Linux hosts with `yum update` as shown in [Manually Updating Virtualization Hosts](Manually_Updating_Virtualization_Hosts).

On Red Hat Virtualization Host (RHVH), the upgrade manager checks for updates to the RHVH image. Because the RHVH image as a whole is updated, rather than individual packages, manually running `yum update` for other packages is not necessary. Modified content in only the `/etc` and `/var` directories is preserved during an update. Modified data in other paths is completely replaced during an update.

The upgrade manager checks for updates every 24 hours by default. You can change this setting using the `HostPackagesUpdateTimeInHours` configuration value. Run the `engine-config` command on the Manager machine. For example:

    # engine-config -s HostPackagesUpdateTimeInHours=48

If migration is enabled at cluster level, virtual machines are automatically migrated to another host in the cluster; as a result, it is recommended that host updates are performed at a time when the host's usage is relatively low.

Ensure that the cluster to which the host belongs has sufficient memory reserve in order for its hosts to perform maintenance. If a cluster lacks sufficient memory, the virtual machine migration operation will hang and then fail. You can reduce the memory usage of this operation by shutting down some or all virtual machines before updating the host.

**Important:** Ensure that the cluster contains more than one host before performing an update. Do not attempt to update all the hosts at the same time, as one host must remain available to perform Storage Pool Manager (SPM) tasks.

**Updating Red Hat Enterprise Linux hosts and Red Hat Virtualization Host**

1. Click the **Hosts** tab and select the host to be updated.

    * If the host requires updating, an alert message under **Action Items** and an icon next to the host's name indicate that a new version is available.

    * If the host does not require updating, no alert message or icon is displayed and no further action is required.

2. Click **Upgrade** to open the **Upgrade Host** confirmation window.

3. Click **OK** to update the host. The details of the host are updated in the **Hosts** tab, and the status will transition through these stages:

    * **Maintenance**

    * **Installing**

    *  **Up**

Once successfully updated, the host displays a status of **Up**. Any virtual machines that were migrated off the host are, at this point, able to be migrated back to it. Repeat the update procedure for each host in the Red Hat Virtualization environment.

**Note:** If the update fails, the host's status changes to **Install Failed**. From **Install Failed** you can click **Upgrade** again.


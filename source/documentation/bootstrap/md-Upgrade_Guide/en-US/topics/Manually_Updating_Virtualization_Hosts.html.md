# Manually Updating Hosts

Red Hat Enterprise Linux hosts use the `yum` command in the same way as regular Red Hat Enterprise Linux systems. Red&nbsp;Hat Virtualization Host (RHVH) can use the `yum` command for updates; however, installing additional packages is not currently supported. It is highly recommended that you use `yum` to update your systems regularly, to ensure timely application of security and bug fixes. Updating a host includes stopping and restarting the host. If migration is enabled at cluster level, virtual machines are automatically migrated to another host in the cluster; as a result, it is recommended that host updates are performed at a time when the host's usage is relatively low.

The cluster to which the host belongs must have sufficient memory reserve in order for its hosts to perform maintenance. Moving a host with live virtual machines to maintenance in a cluster that lacks sufficient memory causes any virtual machine migration operations to hang and then fail. You can reduce the memory usage of this operation by shutting down some or all virtual machines before moving the host to maintenance.

**Important:** Ensure that the cluster contains more than one host before performing an update. Do not attempt to update all the hosts at the same time, as one host must remain available to perform Storage Pool Manager (SPM) tasks.

**Manually Updating Hosts**

1. From the Administration Portal, click the **Hosts** tab and select the host to be updated.

2. Click **Maintenance** to place the host into maintenance mode.

    * On a Red Hat Enterprise Linux host, log in to the host machine and run the following command:

            # yum update

    * On a Red Hat Virtualization Host, log in to the Cockpit user interface, click **Tools** &gt; **Terminal**, and run the following command:

            # yum update

3. Restart the host to ensure all updates are correctly applied.

Repeat this process for each host in the Red Hat Virtualization environment.

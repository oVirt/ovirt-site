---
title: Manually Updating Hosts
---

# Appendix C: Manually Updating Hosts

You can use the `yum` command to update your hosts. Update your systems regularly, to ensure timely application of security and bug fixes.

**Important:** On oVirt Node, the update only preserves modified content in the **/etc** and **/var** directories. Modified data in other paths is overwritten during an update.

**Prerequisites**

* If migration is enabled at cluster level, virtual machines are automatically migrated to another host in the cluster; as a result, it is recommended that host updates are performed at a time when the host’s usage is relatively low.

* Ensure that the cluster contains more than one host before performing an update. Do not attempt to update all the hosts at the same time, as one host must remain available to perform Storage Pool Manager (SPM) tasks.

* Ensure that the cluster to which the host belongs has sufficient memory reserve in order for its hosts to perform maintenance. If a cluster lacks sufficient memory, the virtual machine migration operation will hang and then fail. You can reduce the memory usage of this operation by shutting down some or all virtual machines before updating the host.

* You cannot migrate a virtual machine using a vGPU to a different host. Virtual machines with vGPUs installed must be shut down before updating the host.

**Procedure**

1. Ensure the correct repositories are enabled. You can check which repositories are currently enabled by running `yum repolist`.

2. In the Administration Portal, click **Compute** → **Hosts** and select the host to be updated.

3. Click **Management** → **Maintenance**.

4. Update the host:
   If you are updating from a previous 4.3 release to latest 4.3 release you can use directly

       # yum update ovirt-node-ng-image-update
   
   If you are updating from 4.2 you need to provide the URL to latest 4.3 release. For example:
   
       # yum update https://resources.ovirt.org/pub/ovirt-4.3/rpm/el7/noarch/ovirt-node-ng-image-update-4.3.6-1.el7.noarch.rpm 

5. Reboot the host to ensure all updates are correctly applied.

    **Note:**  Check the imgbased logs to see if any additional package updates have failed for an oVirt Node. If some packages were not successfully reinstalled after the update, check that the packages are listed in **/var/imgbased/persisted-rpms**. Add any missing packages then run `rpm -Uvh /var/imgbased/persisted-rpms/*`.

Repeat this process for each host in the oVirt environment.

**Prev:** [Appendix C: Manually Updating Hosts](appe-Manually_Updating_Hosts)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/upgrade_guide/manually_updating_hosts_upgrade)

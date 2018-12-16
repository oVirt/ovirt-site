---
title: Upgrading from 4.0 to oVirt 4.2
---

# Upgrading from 4.0 to oVirt 4.2

## Planning an Upgrade from 4.0 to 4.2

You cannot upgrade the Manager directly from 4.0 to 4.2. You must upgrade your environment in the following sequence:

1. Update the 4.0 Manager to the latest version of 4.0

2. Upgrade the Manager from 4.0 to 4.1

3. Upgrade the Manager from 4.1 to 4.2

4. Upgrade the hosts

5. Perform [post-upgrade tasks](chap-Post-Upgrade_Tasks/)

## Update the oVirt Engine

Updates to the oVirt Engine are released through the oVirt repositories.

**Procedure**

1. On the oVirt Engine machine, check if updated packages are available:

        # engine-upgrade-check

    **Note:** If updates are expected, but not available, enable the required repositories. See Enabling the oVirt Engine Repositories in the Installation Guide.

2. Update the setup packages:

       # yum update ovirt\*setup\*

3. Update the oVirt Engine. The `engine-setup` script prompts you with some configuration questions, then stops the **ovirt-engine** service, downloads and installs the updated packages, backs up and updates the database, performs post-installation configuration, and starts the **ovirt-engine** service.

        # engine-setup

    **Note:** The `engine-setup` script is also used during the oVirt Engine installation process, and it stores the configuration values supplied. During an update, the stored values are displayed when previewing the configuration, and may not be up to date if `engine-config` was used to update configuration after installation. For example, if `engine-config` was used to update `SANWipeAfterDelete` to `true` after installation, `engine-setup` will output "Default SAN wipe after delete: False" in the configuration preview. However, the updated values will not be overwritten by `engine-setup`.

    **Important:** The update process may take some time; allow time for the update process to complete and do not stop the process once initiated.

4. Update the base operating system and any optional packages installed on the Engine:

        # yum update

    **Important:** If the update upgraded any kernel packages, reboot the system to complete the changes.

## Upgrading the Engine from 4.0 to 4.1

You must upgrade the Manager to 4.1 before upgrading it to 4.2.

The following procedure outlines the process for upgrading oVirt Engine 4.0 to oVirt Engine 4.1 in a standard deployment. See "Upgrading a Self-Hosted Engine Environment" in the [Self-Hosted Engine Guide](../self-hosted/Self-Hosted_Engine_Guide/) for more information about upgrading the Engine in a Self-hosted Engine deployment.

This procedure assumes that the system on which the Engine is installed is subscribed to the entitlements for receiving oVirt 4.0 packages.

   **Important:** If the upgrade fails, the `engine-setup` command will attempt to roll your oVirt Engine installation back to its previous state. For this reason, the repositories required by oVirt 4.0 must not be removed until after the upgrade is complete. If the upgrade fails, detailed instructions display that explain how to restore your installation.

   **Important:** Ensure that you are running the latest minor version of oVirt Engine 4.0 before upgrading by running `engine-upgrade-check`.

**Upgrading to oVirt Engine 4.1**

1. Update the setup packages:

        # yum update ovirt\*setup\*

2. Run the following command and follow the prompts to upgrade the oVirt Engine:

        # engine-setup

3. Remove or disable the oVirt Engine 4.0 repository to ensure the system does not use any oVirt Engine 4.0 packages:

        # yum remove ovirt-release40

4. Update the base operating system:

        # yum update

      **Important:** If any kernel packages were updated, reboot the system to complete the update.

You must now change the cluster and data center compatibility version to 4.1.

## Upgrading the Engine from 4.1 to 4.2

**Prerequisites**

This procedure assumes that the system on which the Manager is installed is attached to the subscriptions for receiving oVirt 4.1 packages.

   **Important:** If the upgrade fails, the `engine-setup` command will attempt to roll your oVirt Engine installation back to its previous state. For this reason, the repositories required by oVirt 4.0 must not be removed until after the upgrade is complete. If the upgrade fails, detailed instructions display that explain how to restore your installation.

**Procedure**

1. Update the setup packages:

        # yum update ovirt\*setup\*

2. Run the following command and follow the prompts to upgrade the oVirt Engine:

        # engine-setup

3. Remove or disable the oVirt Engine 4.1 repositories to ensure the system does not use any oVirt Engine 4.1 packages:

        # yum remove ovirt-release41

4. Update the base operating system:

        # yum update

      **Important:** If any kernel packages were updated, reboot the system to complete the update.

You can now update the hosts.

## Update the Hosts

Use the host upgrade manager to update individual hosts directly from the oVirt Engine.

oVirt 3.6 supported three types of host. If you are using Enterprise Linux hosts or oVirt Nodes 3.6, use this procedure to update them. However, if you are using oVirt Node 4.0+, you must reinstall them with oVirt Node 4.2.

If you are not sure if you are using oVirt Node 3.6 or oVirt Node 4.0+, run:

    # imgbase check

If the command fails, the host is oVirt Node 3.6. If the command succeeds, the host is oVirt Node.

   **Note:** The upgrade manager only checks host with a status of `Up` or `Non-operational`, but not `Maintenance`.

   **Important:** On oVirt Node 4.0+, the update only preserves modified content in the /etc and /var directories. Modified data in other paths is overwritten during an update.

**Prerequisites**

* If migration is enabled at cluster level, virtual machines are automatically migrated to another host in the cluster; as a result, it is recommended that host updates are performed at a time when the host’s usage is relatively low.

* Ensure that the cluster contains more than one host before performing an update. Do not attempt to update all the hosts at the same time, as one host must remain available to perform Storage Pool Manager (SPM) tasks.

* Ensure that the cluster to which the host belongs has sufficient memory reserve in order for its hosts to perform maintenance. If a cluster lacks sufficient memory, the virtual machine migration operation will hang and then fail. You can reduce the memory usage of this operation by shutting down some or all virtual machines before updating the host.
* You cannot migrate a virtual machine using a vGPU to a different host. Virtual machines with vGPUs installed must be shut down before updating the host.

**Procedure**

1. If your Enterprise Linux hosts are set to version 7.3, you must reset them to the general EL 7 version before updating.

        # subscription-manager release --set=7Server

2. Disable your current repositories:

        # subscription-manager repos --disable=*

3. Ensure the correct repositories are enabled. You can check which repositories are currently enabled by running yum repolist.

  * For oVirt Nodes and CentOS:

        # yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm

  * For Red Hat Enterprise Linux hosts:

        # subscription-manager repos --enable=rhel-7-server-rpms
        # subscription-manager repos --enable=rhel-7-server-optional-rpms
        # subscription-manager repos --enable=rhel-7-server-extras-rpms
        # yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm

4. Click **Compute** &rarr; **Hosts** and select the host to be updated.

5. Click **Installation** &rarr; **Check** for Upgrade.

6. Click **OK** to begin the upgrade check.

7. Click **Installation** &rarr; **Upgrade**.

8. Click **OK** to update the host. The details of the host are updated in Compute → Hosts and the status will transition through these stages:

  * **Maintenance**

  * **Installing**

  * **Up**

   After the update, the host is rebooted. Once successfully updated, the host displays a status of `Up`. If any virtual machines were migrated off the host, they are now migrated back.

   **Note:** If the update fails, the host’s status changes to Install Failed. From Install Failed you can click **Installation** &rarr; **Upgrade** again.

Repeat this procedure for each host in the oVirt environment.

**Prev:** [Chapter 2: Upgrading from 3.6 to oVirt 4.2](chap-Upgrading_from_3.6_to_oVirt_4.2)<br>
**Next:** [Chapter 4: Upgrading from 4.1 to oVirt 4.2](chap-Upgrading_from_4.1_to_oVirt_4.2)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/upgrade_guide/chap-upgrading_from_4.0_to_red_hat_virtualization_4.2)

---
title: Upgrading the Self-Hosted Engine
---

# Chapter 6: Upgrading the Self-Hosted Engine

## Upgrading a Self-Hosted Engine Environment

**Upgrading from 3.6 to 4.2**

To upgrade from oVirt 3.6 to oVirt 4.2, see the “Upgrading a oVirt Node 3.6 Self-Hosted Engine to a oVirt Node 4.2 Self-Hosted Engine” below.

**Upgrading from 4.0 to 4.2**

To upgrade from oVirt 4.0 to oVirt 4.2 you must upgrade sequentially:

* Update to the latest minor version of oVirt 4.0. See the Self-Hosted Engine Guide for oVirt 4.0.

* Upgrade from 4.0 to 4.1. See the Self-Hosted Engine Guide for oVirt 4.1.

* Upgrade to 4.2 as described in this section.

**Upgrading from 4.1 to 4.2**

To upgrade your oVirt self-hosted engine environment from version 4.1 to 4.2, upgrade the Engine virtual machine, the self-hosted engine nodes, and any standard hosts. All hosts in a self-hosted engine environment must be the same version; you cannot upgrade only some of the hosts.

The upgrade process involves the following key steps:

* Place the high-availability agents that manage the Engine virtual machine into the global maintenance mode.

* Upgrade the 4.1 Engine virtual machine to the latest 4.1 minor version.

* Upgrade the Engine virtual machine.

* Place a self-hosted engine node into maintenance. The Engine virtual machine and other virtual machines will be migrated to another host in the cluster if necessary.

* Update the self-hosted engine node. Repeat for all hosts. Red Hat recommends updating all hosts in the environment, including standard hosts.

* After all hosts in the cluster and the Engine virtual machine have been upgraded, change the cluster compatibility version to 4.2.

Before upgrading the Engine virtual machine, ensure the `/var/tmp` directory contains enough free space to extract the appliance files. If it does not, you can specify a different directory or mount alternate storage that does have the required space. The VDSM user and KVM group must have read, write, and execute permissions on the directory.

The upgrade procedure creates a backup disk on the self-hosted engine storage domain. You therefore need additional free space on the storage domain for the new appliance being deployed (50 GB by default). To increase the storage on iSCSI or Fibre Channel storage, you need to manually extend the LUN size on the storage and then extend the storage domain using the Engine. Refer to "Increasing iSCSI or FCP Storage" in the [Administration Guide](/documentation/admin-guide/administration-guide/) for more information about resizing a LUN.

The backup created during the upgrade procedure is not automatically deleted. You need to manually delete it after confirming the upgrade has been successful. The backup disks are labeled with `hosted-engine-backup-*`.

**Important:** During the upgrade procedure you will be asked to create a backup of the Engine and copy it to the host machine where the upgrade is being performed.

**Upgrading a Self-Hosted Engine Environment**

1. In the Administration Portal, right-click a self-hosted engine node and select **Enable Global HA Maintenance**.

2. Wait a few minutes and ensure that you see **Hosted Engine HA: Global Maintenance Enabled** in the **General** tab.

3. Log into the Engine virtual machine and upgrade the Engine to the latest minor version:

  i. Check if updated packages are available:

          # engine-upgrade-check

    * If there are no updates available, the command will output the text `No upgrade`:

            # engine-upgrade-check
            VERB: queue package ovirt-engine-setup for update
            VERB: package ovirt-engine-setup queued
            VERB: Building transaction
            VERB: Empty transaction
            VERB: Transaction Summary:
            No upgrade

    * If updates are available, the command will list the packages to be updated:

            # engine-upgrade-check
            VERB: queue package ovirt-engine-setup for update
            VERB: package ovirt-engine-setup queued
            VERB: Building transaction
            VERB: Transaction built
            VERB: Transaction Summary:
            VERB:     updated    - ovirt-engine-lib-4.1.2-0.50.el7ev.noarch
            VERB:     update     - ovirt-engine-lib-4.1.0-0.13.el7ev.noarch
            ...

            Upgrade available

  ii. Update the setup packages:

          # yum update ovirt\*setup\*

  iii. Update the oVirt Engine. By running engine-setup, the script will prompt you with some configuration questions like updating the firewall rules, updating PKI certificates, and backing up the Data Warehouse database. The script will then go through the process of stopping the ovirt-engine service, downloading and installing the updated packages, backing up and updating the database, performing post-installation configuration, and starting the ovirt-engine service.

      **Note:** The `engine-setup` script is also used during the oVirt Engine installation process, and it stores the configuration values that were supplied. During an update, the stored values are displayed when previewing the configuration, and may not be up to date if `engine-config` was used to update configuration after installation. For example, if `engine-config` was used to update `SANWipeAfterDelete` to true after installation, engine-setup will output "Default SAN wipe after delete: False" in the configuration preview. However, the updated values will not be overwritten by `engine-setup`.

          # engine-setup

      **Important:** The update process may take some time; allow time for the update process to complete and do not stop the process once initiated.

  iv. Update the base operating system and any optional packages installed on the Engine:

          # yum update

      **Important:** If any kernel packages were updated, reboot the system to complete the update.

4. Log in to the Engine virtual machine to upgrade the oVirt Engine:

  i. Enable the oVirt Engine, oVirt Tools, and Ansible Engine repositories:

          # subscription-manager repos --enable=rhel-7-server-rhv-4.2-manager-rpms
          # subscription-manager repos --enable=rhel-7-server-rhv-4-manager-tools-rpms
          # subscription-manager repos --enable=rhel-7-server-ansible-2-rpms

  ii. Update the setup packages:

          # yum update ovirt\*setup\*

  iii. Run `engine-setup` and follow the prompts to upgrade the oVirt Engine:

          # engine-setup

  iv. Remove or disable the oVirt Engine 4.1 repositories to ensure the system does not use any oVirt Engine 4.1 packages:

          # subscription-manager repos --disable=rhel-7-server-rhv-4.1-manager-rpms
          # subscription-manager repos --disable=rhel-7-server-rhv-4.1-rpms

  v. Update the base operating system:

          # yum update

      **Important:** If any kernel packages were updated, reboot the Engine virtual machine manually to complete the update. See Troubleshooting the Engine Virtual Machine.

  vi. In the Administration Portal, click **Compute** &rarr; **Hosts** and select a self-hosted engine node. Click **More Actions** &rarr; **Disable Global HA Maintenance**.

5. Update the self-hosted engine nodes, then any standard hosts in the environment:

  i. In the Administration Portal, click **Compute** &rarr; **Hosts** and select a host. Click **Management** &rarr; **Maintenance** to place the host into local maintenance. If the host is hosting the Engine virtual machine, the virtual machine will be migrated to another host. Any other virtual machines will be migrated according to your virtual machine migration policy. The high-availability agents are automatically placed into local maintenance.

  ii. Ensure the correct repositories are enabled:

          # subscription-manager repos --enable=rhel-7-server-rhv-4-mgmt-agent-rpms
          # subscription-manager repos --enable=rhel-7-server-ansible-2-rpms

  iii. Update the host:

    * On an Enterprise Linux host, log in to the host machine and run the following command:

            # yum update

    * On an oVirt Node, log in to the Cockpit user interface, click **Terminal**, and run the following command:

            # yum update

        **Important:** If any kernel packages were updated, reboot the host to complete the update.

  iv. Select the same host and click **Management** &rarr; **Activate**.

  v. Repeat these steps to update all hosts.

6. Update the cluster and data center compatibility version to 4.2. See Post-Upgrade Tasks in the Upgrade Guide for more information.

    **Important:** Only update the compatibility version if all hosts have been updated to oVirt 4.2, to avoid some hosts becoming non-operational.

## Upgrading an oVirt Node 3.6 Self-Hosted Engine to an oVirt 4.2 Self-Hosted Engine

To upgrade a oVirt 3.6 self-hosted engine environment that contains only oVirt Node to oVirt 4.2, you must remove the hosts and reinstall them as oVirt Node 4.2.

Self-hosted engine nodes in oVirt 3.6 are added using the `hosted-engine --deploy` command, which cannot be used to add more nodes in oVirt Node 4.2, and self-hosted engine nodes in oVirt 4.1 are added using the UI, which is not available in oVirt 3.6. Therefore, to upgrade the environment from 3.6 to 4.2, you must first install a self-hosted engine node running oVirt Node 4.0, where adding more nodes using the `hosted-engine --deploy` command is deprecated but still available.

    **Note:** This scenario does not impact self-hosted engine environments that contain some (or only) Enterprise Linux self-hosted engine nodes, as they can be updated without being removed from the environment.

    **Important:** Before upgrading the Engine virtual machine, ensure the **/var/tmp** directory contains 5 GB free space to extract the appliance files. If it does not, you can specify a different directory or mount alternate storage that does have the required space. The VDSM user and KVM group must have read, write, and execute permissions on the directory.

Upgrading from a oVirt 3.6 self-hosted engine environment with oVirt Node 3.6 hosts to a oVirt 4.2 environment with oVirt Node 4.2 hosts involves the following key steps:

* Install a new oVirt Node 4.0 host and add it to the 3.6 self-hosted engine environment. The new host can be an existing oVirt Node 3.6 host removed from the environment and reinstalled with oVirt Node 4.0.

* Upgrade the Engine from 3.6 to 4.0.

* Remove the rest of the oVirt Node 3.6 hosts and reinstall them with oVirt Node 4.2.

* Add the oVirt Node 4.2 hosts to the 4.0 environment.

* Upgrade the Engine from 4.0 to 4.1.

* Upgrade the Engine from 4.1 to 4.2.

* Upgrade the remaining oVirt Node 4.0 host to oVirt Node 4.2.

* Upgrading a oVirt Node 3.6 Self-Hosted Engine to a oVirt Node 4.2 Self-Hosted Engine

**Upgrading a oVirt Node 3.6 Self-Hosted Engine to a oVirt Node 4.2 Self-Hosted Engine**

1. If you are reusing an existing oVirt Node 3.6 host, remove it from the 3.6 environment. See Removing a Host from a Self-Hosted Engine Environment.

2. Upgrade the environment from 3.6 to 4.0 using the instructions in Upgrading a oVirt Node-Based Self-Hosted Engine Environment in the oVirt 4.0 Self-Hosted Engine Guide. These instructions include installing a oVirt Node 4.0 host.

3. Upgrade each remaining oVirt Node 3.6 host directly to oVirt Node 4.2:

  i. Remove the host from the self-hosted engine environment.

  ii. Reinstall the host with oVirt Node 4.2.

  iii. Add the host to the 4.0 environment.

4. Upgrade the Engine from 4.0 to 4.1. place the host in global maintenance mode:

  i. In the Administration Portal, right-click a self-hosted engine node and select **Enable Global HA Maintenance**.

  ii. Wait a few minutes and ensure that you see **Hosted Engine HA: Global Maintenance Enabled** in the **General** tab.

  iii. Use the instructions in Upgrading to oVirt Engine 4.1.

5. Upgrade the Engine from 4.1 to 4.2 and then upgrade the final remaining oVirt Node 4.0 host to 4.2 using the instructions in Upgrading a Self-Hosted Engine Environment.

**Prev:** [Chapter 5: Migrating from Bare Metal to an EL-Based Self-Hosted Environment](chap-Migrating_from_Bare_Metal_to_an_EL-Based_Self-Hosted_Environment) <br>
**Next:** [Chapter 7: Backing up and Restoring an EL-Based Self-Hosted Environment](chap-Backing_up_and_Restoring_an_EL-Based_Self-Hosted_Environment)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/self-hosted_engine_guide/chap-upgrading_the_self-hosted_engine)

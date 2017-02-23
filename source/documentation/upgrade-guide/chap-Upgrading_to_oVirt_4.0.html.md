# Chapter 3: Upgrading to oVirt 4.0

## oVirt 4.0 Upgrade Considerations

The following is a list of key considerations that must be made when planning your upgrade.

**Upgrading to version 4.0 can only be performed from version 3.6**

To upgrade a version of oVirt earlier than 3.6 to oVirt 4.0, you must sequentially upgrade to any newer versions of oVirt before upgrading to the latest version. For example, if you are using oVirt 3.5, you must upgrade to the latest minor version of oVirt 3.6 before you can upgrade to oVirt 4.0. See the [Upgrade Guide](/documentation/upgrade-guide/upgrade-guide/) for oVirt 3.6 for instructions to upgrade to the latest 3.6 minor version.

The data center and cluster compatibility version must be at version 3.6 before performing the upgrade.

**oVirt Engine 4.0 is supported to run on Red Hat Enterprise Linux 7.2**

Upgrading to version 4.0 involves also upgrading the base operating system of the machine that hosts the Engine.

## Upgrading to oVirt Engine 4.0

oVirt Engine 4.0 is only supported on Red Hat Enterprise Linux 7. A clean installation of Red Hat Enterprise Linux 7 and oVirt Engine 4.0 is required, even if you are using the same physical machine used to run oVirt Engine 3.6. The upgrade process involves restoring oVirt Engine 3.6 backup files onto the oVirt Engine 4.0 machine.

**Important:** All data centers and clusters in the environment must have the cluster compatibility level set to version 3.6 before attempting the procedure.

After the Engine has been upgraded, you can upgrade the hosts. See [Chapter 2: Updates between Minor Releases](../chap-Updates_between_Minor_Releases). Then the cluster compatibility level can be updated to 4.0. See [Chapter 4: Post-Upgrade Tasks](../chap-Post-Upgrade_Tasks).

**Note:** Connected hosts and virtual machines can continue to work while the Engine is being upgraded.

If the Engine has a different IP address or FQDN after the upgrade, use `ovirt-engine-rename` to rename the Engine.

If any optional extension packages, such as `ovirt-engine-extension-aaa-ldap`, `ovirt-engine-extension-aaa-misc`, or `ovirt-engine-extension-logger-log4j` are installed on oVirt Engine 3.6, these will need to be installed on the upgraded Engine before running `engine-setup`. The settings for these package extensions are not migrated as part of the upgrade.

**Upgrading to oVirt Engine 4.0**

1. On oVirt Engine 3.6, back up the environment.

        # engine-backup --scope=all --mode=backup --file=backup.bck --log=backuplog.log

2. Copy the backup file to a suitable device.

3. Install Enterprise Linux 7.

4. Install oVirt Engine 4.0. See the [Installation Guide](/documentation/install-guide/Installation_Guide/).

4. Copy the backup file to the oVirt Engine 4.0 machine and restore the backup.

        # engine-backup --mode=restore --file=backup.bck --log=restore.log --provision-db --provision-dwh-db --restore-permissions

    **Note:** If the backup contained grants for extra database users, this command will create the extra users with random passwords. You must change these passwords manually if the extra users require access to the restored system. See [https://access.redhat.com/articles/2686731](https://access.redhat.com/articles/2686731).

    **Note:** Use the `--provision-dwh-db` option if the backup contains Data Warehouse data.

    Reports have been deprecated in oVirt 4.0 and will not be restored. See [BZ#1340810](https://bugzilla.redhat.com/show_bug.cgi?id=1340810) for more information.

5. Install optional extension packages if they were installed on the oVirt Engine 3.6 machine.

        # yum install ovirt-engine-extension-aaa-ldap ovirt-engine-extension-aaa-misc ovirt-engine-extension-logger-log4j

    **Note:** The configuration for these package extensions must be manually reapplied because they are not migrated as part of the backup and restore process.

6. Decommission the oVirt Engine 3.6 machine if a different machine is used for oVirt Engine 4.0.

7. Run `engine-setup` to configure the Engine.

        # engine-setup

8. Run `ovirt-engine-rename` to rename the Engine if the IP address or FQDN differs from the oVirt Engine 3.6 machine, and follow the prompts to set the new details.

        # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename

**Note:** If you use external CA to sign HTTPS certificates, follow the steps in "Replacing the oVirt Engine SSL Certificate" in the [Administration Guide](/documentation/admin-guide/administration-guide/) to log in to the Administration portal after the upgrade. Ensure the CA certificate is added to system-wide trust stores of all clients to ensure the foreign menu of virt-viewer works.

Before updating the Red Hat Enterprise Linux hosts in the environment, disable the version 3.6 repositories and enable the required 4.0 repository.

oVirt Node hosts must be reinstalled with oVirt Node 4.0. See "oVirt Nodes" in the [Installation Guide](/documentation/install-guide/Installation_Guide/).

You may now update the hosts, then change the cluster and data center compatibility version to 4.0.

## Upgrading the Self-Hosted Engine

To upgrade a Red Hat Enterprise Linux-based self-hosted environment, see "Upgrading an Enterprise Linux-Based Self-Hosted Engine Environment" in the [Self-Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/).

To upgrade an oVirt Hypervisor-based self-hosted environment to an oVirt Node-based self-hosted environment, see "Upgrading an oVirt Node-Based Self-Hosted Engine Environment" in the [Self-Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide/).

**Prev:** [Chapter 2: Updates Between Minor Releases](../chap-Updates_between_Minor_Releases) <br>
**Next:** [Chapter 4: Post-Upgrade Tasks](../chap-Post-Upgrade_Tasks)

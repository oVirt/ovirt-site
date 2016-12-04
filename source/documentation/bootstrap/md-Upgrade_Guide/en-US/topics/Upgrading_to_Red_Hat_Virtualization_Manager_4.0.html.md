# Upgrading to Red Hat Virtualization Manager 4.0

Red Hat Virtualization Manager 4.0 is only supported on Red Hat Enterprise Linux 7. A clean installation of Red Hat Enterprise Linux 7 and Red Hat Virtualization Manager 4.0 is required, even if you are using the same physical machine used to run Red Hat Enterprise Virtualization Manager 3.6. The upgrade process involves restoring Red Hat Enterprise Virtualization Manager 3.6 backup files onto the Red Hat Virtualization Manager 4.0 machine. 

**Important:** All data centers and clusters in the environment must have the cluster compatibility level set to version 3.6 before attempting the procedure.

After the Manager has been upgraded, you can upgrade the hosts. See [Updates between Minor Releases](chap-Updates_between_Minor_Releases). Then the cluster compatibility level can be updated to 4.0. See [Post-Upgrade Tasks](chap-Post-Upgrade_Tasks).

**Note:** Connected hosts and virtual machines can continue to work while the Manager is being upgraded.

If the Manager has a different IP address or FQDN after the upgrade, use `ovirt-engine-rename` to rename the Manager.

If any optional extension packages, such as `ovirt-engine-extension-aaa-ldap`, `ovirt-engine-extension-aaa-misc`, or `ovirt-engine-extension-logger-log4j` are installed on Red Hat Enterprise Virtualization Manager 3.6, these will need to be installed on the upgraded Manager before running `engine-setup`. The settings for these package extensions are not migrated as part of the upgrade.

**Upgrading to Red Hat Virtualization Manager 4.0**

1. On Red Hat Enterprise Virtualization Manager 3.6, back up the environment.

        # engine-backup --scope=all --mode=backup --file=backup.bck --log=backuplog.log

2. Copy the backup file to a suitable device.

3. Install Red Hat Enterprise Linux 7. See the [*Red Hat Enterprise Linux Installation Guide*](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/index.html) for more information.

4. Install Red Hat Virtualization Manager 4.0. See the [*Red Hat Virtualization Installation Guide*](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/installation-guide#part-Installing_Red_Hat_Enterprise_Virtualization).

4. Copy the backup file to the Red Hat Virtualization Manager 4.0 machine and restore the backup.

        # engine-backup --mode=restore --file=backup.bck --log=restore.log --provision-db --provision-dwh-db --restore-permissions

    **Note:** If the backup contained grants for extra database users, this command will create the extra users with random passwords. You must change these passwords manually if the extra users require access to the restored system. See [https://access.redhat.com/articles/2686731](https://access.redhat.com/articles/2686731).

    **Note:** Use the `--provision-dwh-db` option if the backup contains Data Warehouse data.

    Reports have been deprecated in Red Hat Virtualization 4.0 and will not be restored. See [BZ#1340810](https://bugzilla.redhat.com/show_bug.cgi?id=1340810) for more information.

5. Install optional extension packages if they were installed on the Red Hat Enterprise Virtualization Manager 3.6 machine.

        # yum install ovirt-engine-extension-aaa-ldap ovirt-engine-extension-aaa-misc ovirt-engine-extension-logger-log4j

    **Note:** The configuration for these package extensions must be manually reapplied because they are not migrated as part of the backup and restore process.

6. Decommission the Red Hat Enterprise Virtualization Manager 3.6 machine if a different machine is used for Red Hat Virtualization Manager 4.0.

7. Run `engine-setup` to configure the Manager. 

        # engine-setup

8. Run `ovirt-engine-rename` to rename the Manager if the IP address or FQDN differs from the Red Hat Enterprise Virtualization Manager 3.6 machine, and follow the prompts to set the new details.

        # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename

**Note:** If you use external CA to sign HTTPS certificates, follow the steps in [Replacing the Red Hat Virtualization Manager SSL Certificate](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/administration-guide/#Replacing_the_Manager_SSL_Certificate) in the *Administration Guide* to log in to the Administration portal after the upgrade. Ensure the CA certificate is added to system-wide trust stores of all clients to ensure the foreign menu of virt-viewer works. See [BZ#1313379](https://bugzilla.redhat.com/show_bug.cgi?id=1313379) for more information.

Before updating the Red Hat Enterprise Linux hosts in the environment, disable the version 3.6 repositories and enable the required 4.0 repository by running the following commands on the host you wish to update.

    # subscription-manager repos --disable=*
    # subscription-manager repos --enable=rhel-7-server-rhv-4-mgmt-agent-rpms

RHEV-H hosts must be reinstalled with RHVH 4.0. See [Red Hat Virtualization Hosts](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/installation-guide/#Red_Hat_Virtualization_Hosts) in the *Installation Guide*.

You may now update the hosts, then change the cluster and data center compatibility version to 4.0.

---
title: Upgrading a Remote Database Environment from 3.6 to oVirt 4.2
---

# Chapter 5: Upgrading a Remote Database Environment from 3.6 to oVirt 4.2

## oVirt 4.0 Planning an Upgrade from a 3.6 Environment with a Remote Database to 4.2

You cannot upgrade the Engine directly from 3.6 to 4.2. You must upgrade your environment in the following sequence:

1. Update the 3.6 Engine to the latest version of 3.6

2. Upgrade the Engine 3.6 to 4.0

3. Upgrade the Engine from 4.0 to 4.1

4. Upgrade the database from PostgreSQL 9.2 to 9.5

5. Upgrade the Engine from 4.1 to 4.2

6. Upgrade the hosts

7. Perform [post-upgrade tasks](../chap-Post-Upgrade_Tasks/)

## Update the oVirt Engine

Updates to the oVirt Engine are released through the oVirt repositories.

**Procedure**

1. On the oVirt Engine machine, check if updated packages are available:

        # engine-upgrade-check

    **Note:** If updates are expected, but not available, enable the required repositories. See Enabling the oVirt Engine Repositories in the Installation Guide.

2. Update the setup packages:

    # yum update ovirt\*setup\*

    # yum update rhevm-setup

3. Update the oVirt Engine. The `engine-setup` script prompts you with some configuration questions, then stops the **ovirt-engine** service, downloads and installs the updated packages, backs up and updates the database, performs post-installation configuration, and starts the **ovirt-engine** service.

        # engine-setup

    **Note:** The `engine-setup` script is also used during the oVirt Engine installation process, and it stores the configuration values supplied. During an update, the stored values are displayed when previewing the configuration, and may not be up to date if `engine-config` was used to update configuration after installation. For example, if `engine-config` was used to update `SANWipeAfterDelete` to `true` after installation, `engine-setup` will output "Default SAN wipe after delete: False" in the configuration preview. However, the updated values will not be overwritten by `engine-setup`.

    **Important:** The update process may take some time; allow time for the update process to complete and do not stop the process once initiated.

4. Update the base operating system and any optional packages installed on the Engine:

        # yum update

    **Important:** If the update upgraded any kernel packages, reboot the system to complete the changes.

## Upgrading the Engine from 3.6 to 4.0

You must upgrade the Engine to 4.0 before upgrading it to 4.1.

oVirt Engine 4.0 is only supported on Enterprise Linux 7. A clean installation of Enterprise Linux 7 and oVirt Engine 4.0 is required, even if you are using the same physical machine used to run oVirt Engine 3.6. The upgrade process involves restoring oVirt Engine 3.6 backup files onto the oVirt Engine 4.0 machine.

    **Important:** All data centers and clusters in the environment must have the cluster compatibility level set to version 3.6 before attempting the procedure.

    **Important:** Directory servers configured using the domain management tool are not supported after oVirt 3.6. If your directory servers are configured using the domain management tool, migrate to the new extension-based provider before backing up the environment.

After the Engine has been upgraded, you can upgrade the hosts. See [Chapter 9: Updates between Minor Releases](../chap-Updates_between_Minor_Releases). Then the cluster compatibility level can be updated to 4.0. See [Chapter 8: Post-Upgrade Tasks](../chap-Post-Upgrade_Tasks).

    **Note:** Connected hosts and virtual machines can continue to work while the Engine is being upgraded.

Use `ovirt-engine-rename` to rename the Engine only if the Engine has a different FQDN after the upgrade.

If any optional extension packages, such as `ovirt-engine-extension-aaa-ldap`, `ovirt-engine-extension-aaa-misc`, or `ovirt-engine-extension-logger-log4j` are installed on oVirt Engine 3.6, these will need to be installed on the upgraded Engine before running `engine-setup`. The settings for these package extensions are not migrated as part of the upgrade.

**Upgrading to oVirt Engine 4.0**

1. On oVirt Engine 3.6, back up the environment.

        # engine-backup --scope=all --mode=backup --file=backup.bck --log=backuplog.log

2. Copy the backup file to a suitable device.

3. If the ISO storage domain is on the same host as the engine, back up the contents of `/var/lib/exports/iso`:

        # cd /var/lib/exports/iso
        # tar zcf iso_domain.tar.gz UUID

   The ISO storage backup file will be restored after the upgrade.

4. Install Enterprise Linux 7.

5. Install oVirt Engine 4.0. See the [Installation Guide](/documentation/install-guide/Installation_Guide/).

6. Copy the backup file to the oVirt Engine 4.0 machine and restore the backup.

        # engine-backup --mode=restore --file=backup.bck --log=restore.log --provision-db --provision-dwh-db --restore-permissions

    **Note:** If the backup contained grants for extra database users, this command will create the extra users with random passwords. You must change these passwords manually if the extra users require access to the restored system. See [https://access.redhat.com/articles/2686731](https://access.redhat.com/articles/2686731).

    **Note:** Use the `--provision-dwh-db` option if the backup contains Data Warehouse data.

    Reports have been deprecated in oVirt 4.0 and will not be restored. See [BZ#1340810](https://bugzilla.redhat.com/show_bug.cgi?id=1340810) for more information.

7. Install optional extension packages if they were installed on the oVirt Engine 3.6 machine.

        # yum install ovirt-engine-extension-aaa-ldap ovirt-engine-extension-aaa-misc ovirt-engine-extension-logger-log4j

    **Note:** The configuration for these package extensions must be manually reapplied because they are not migrated as part of the backup and restore process.

8. Decommission the oVirt Engine 3.6 machine if a different machine is used for oVirt Engine 4.0.

9. Run `engine-setup` to configure the Engine.

        # engine-setup

10. Run `ovirt-engine-rename` to rename the Engine if the IP address or FQDN differs from the oVirt Engine 3.6 machine, and follow the prompts to set the new details.

        # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename

      **Note:** If you use external CA to sign HTTPS certificates, follow the steps in "Replacing the oVirt Engine SSL Certificate" in the [Administration Guide](/documentation/admin-guide/administration-guide/) to log in to the Administration portal after the upgrade. Ensure the CA certificate is added to system-wide trust stores of all clients to ensure the foreign menu of virt-viewer works.

Before updating the Enterprise Linux hosts in the environment, disable the version 3.6 repositories and enable the required 4.0 repository.

oVirt Node hosts must be reinstalled with oVirt Node 4.0. See "oVirt Nodes" in the [Installation Guide](/documentation/install-guide/Installation_Guide/).

You may now update the hosts, then change the cluster and data center compatibility version to 4.0.

## Upgrading the Engine from 4.0 to 4.1

You must upgrade the Manager to 4.1 before upgrading it to 4.2.

The following procedure outlines the process for upgrading oVirt Engine 4.0 to oVirt Engine 4.1 in a standard deployment. See "Upgrading a Self-Hosted Engine Environment" in the [Self-Hosted Engine Guide](../../self-hosted/Self-Hosted_Engine_Guide/) for more information about upgrading the Engine in a Self-hosted Engine deployment.

This procedure assumes that the system on which the Engine is installed is subscribed to the entitlements for receiving oVirt 4.0 packages.

    **Important:** If the upgrade fails, the `engine-setup` command will attempt to roll your oVirt Engine installation back to its previous state. For this reason, the repositories required by oVirt 4.0 must not be removed until after the upgrade is complete. If the upgrade fails, detailed instructions display that explain how to restore your installation.

    **Important:** Ensure that you are running the latest minor version of oVirt Engine 4.0 before upgrading by running `engine-upgrade-check`.

**Upgrading to oVirt Engine 4.1**

1. Update the setup packages:

        # yum update ovirt\*setup\*

2. Run the following command and follow the prompts to upgrade the oVirt Engine:

        # engine-setup

3. Remove or disable the oVirt Engine 4.0 repository to ensure the system does not use any oVirt Engine 4.0 packages:

        # subscription-manager repos --disable=rhel-7-server-rhv-4.0-rpms

4. Update the base operating system:
        # yum update

          **Important:** If any kernel packages were updated, reboot the system to complete the update.

You must now change the cluster and data center compatibility version to 4.1.

## Upgrading Remote Databases

oVirt 4.2 uses PostgreSQL 9.5 instead of PostgreSQL 9.2. If your databases are installed locally, the upgrade script will automatically upgrade them from version 9.2 to 9.5, and you can skip this section and proceed to the next step. However, if either of your databases (Engine or Data Warehouse) is installed on a separate machine, you must perform the following procedure on each remote database before upgrading the Engine.

1. Stop the service running on the machine:

  * Stop the ovirt-engine service on the Manager machine:

          # systemctl stop ovirt-engine

  * Stop the ovirt-engine-dwh service on the Data Warehouse machine:

          # systemctl stop ovirt-engine-dwhd

2. Install the PostgreSQL 9.5 packages:

        # yum install rh-postgresql95 rh-postgresql95-postgresql-contrib

3. Stop and disable the PostgreSQL 9.2 service:

        # systemctl stop postgresql
        # systemctl disable postgresql

4. Upgrade the PostgreSQL 9.2 database to PostgreSQL 9.5:

        # scl enable rh-postgresql95 -- postgresql-setup upgrade

5. Start and enable the `rh-postgresql95-postgresql.service` and check that it is running:

        # systemctl start rh-postgresql95-postgresql.service
        # systemctl enable rh-postgresql95-postgresql.service
        # systemctl status rh-postgresql95-postgresql.service

  Ensure that you see an output similar to the following:

        rh-postgresql95-postgresql.service - PostgreSQL database server
           Loaded: loaded (/usr/lib/systemd/system/rh-postgresql95-postgresql.service;
        enabled; vendor preset: disabled)
           Active: active (running) since Mon 2018-05-07 08:48:27 CEST; 1h 59min ago

6. Log in to the database and enable the uuid-ossp extension:

        # su - postgres -c "scl enable rh-postgresql95 -- psql -d database-name"

7. Execute the following SQL commands:

        # database-name=# DROP FUNCTION IF EXISTS uuid_generate_v1();
        # database-name=# CREATE EXTENSION "uuid-ossp";

8. Copy the `pg_hba.conf` client configuration file from the 9.2 environment to your 9.5 environment:

        # cp -p /var/lib/pgsql/data/pg_hba.conf  /var/opt/rh/rh-postgresql95/lib/pgsql/data/pg_hba.conf

9. Update the following parameters in the postgresql.conf file:

# vi /var/opt/rh/rh-postgresql95/lib/pgsql/data/postgresql.conf

        listen_addresses='\*'
        autovacuum_vacuum_scale_factor='0.01'
        autovacuum_analyze_scale_factor='0.075'
        autovacuum_max_workers='6'
        maintenance_work_mem='65536'
        max_connections='150'
        work_mem = '8192'

10. Restart the PostgreSQL 9.5 service to apply the configuration changes:

        # systemctl restart rh-postgresql95-postgresql.service

The remote databases have been upgraded.

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

        # subscription-manager repos --disable=rhel-7-server-rhv-4.1-rpms
        # subscription-manager repos --disable=rhel-7-server-rhv-4.1-manager-rpms
        # subscription-manager repos --disable=rhel-7-server-rhv-4-tools-rpms

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

  * For oVirt Nodes:

        # subscription-manager repos --enable=rhel-7-server-oVirt Node-4-rpms

  * For Enterprise Linux hosts:

        # subscription-manager repos --enable=rhel-7-server-rpms
        # subscription-manager repos --enable=rhel-7-server-rhv-4-mgmt-agent-rpms
        # subscription-manager repos --enable=rhel-7-server-ansible-2-rpms

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

**Prev:** [Chapter 4: Upgrading from 4.1 to oVirt 4.2](../chap-Upgrading_from_4.1_to_oVirt_4.2)<br>
**Next:** [Chapter 6: Upgrading a Remote Database Environment from 4.0 to oVirt 4.2](../chap-Upgrading_a_Remote_Database_Environment_from_4.0_to_oVirt_4.2)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/upgrade_guide/chap-upgrading_to_red_hat_virtualization_4.2)

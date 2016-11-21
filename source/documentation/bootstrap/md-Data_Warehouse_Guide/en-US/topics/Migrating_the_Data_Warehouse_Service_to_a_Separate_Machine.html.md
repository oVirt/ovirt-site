# Migrating the Data Warehouse Service to a Separate Machine

Migrate a Data Warehouse service that was installed and configured on the Red Hat Virtualization Manager to a dedicated host machine. Hosting the Data Warehouse service on a separate machine helps to reduce the load on the Manager machine. Note that this procedure migrates the Data Warehouse service only; to migrate the Data Warehouse database (also known as the `ovirt_engine_history` database) prior to migrating the Data Warehouse service, see [Migrating the Data Warehouse Database to a Separate Machine](Migrating_the_Data_Warehouse_Database_to_a_Separate_Machine).

Installing this scenario involves four key steps:

1. Set up the new Data Warehouse machine.

2. Stop the Data Warehouse service on the Manager machine.

3. Configure the new Data Warehouse machine.

4. Remove the Data Warehouse package from the Manager machine.

**Prerequisites**

Ensure that you have completed the following prerequisites:

1. You must have installed and configured the Manager and Data Warehouse on the same machine.

2. To set up the new Data Warehouse machine, you must have the following:

    * A virtual or physical machine with Red Hat Enterprise Linux 7 installed.

    * A subscription to the `Red Hat Enterprise Linux Server` and `Red Hat Virtualization` entitlement pools.

    * The password from the Manager's `/etc/ovirt-engine/engine.conf.d/10-setup-database.conf` file.

    * Allowed access from the Data Warehouse machine to the Manager database machine's TCP port 5432.

    * The `ovirt_engine_history` database credentials from the Manager's `/etc/ovirt-engine-dwh/ovirt-engine-dwhd.conf.d/10-setup-database.conf` file. If you migrated the `ovirt_engine_history` database using [Migrating the Data Warehouse Database to a Separate Machine](Migrating_the_Data_Warehouse_Database_to_a_Separate_Machine), retrieve the credentials you defined during the database setup on that machine.

**Step 1: Setting up the New Data Warehouse Machine**

1. Register your system with the Content Delivery Network, entering your Customer Portal user name and password when prompted:

        # subscription-manager register

2. Find the `Red Hat Enterprise Linux Server` and `Red Hat Virtualization` subscription pools and note down the pool IDs.

        # subscription-manager list --available

3. Use the pool IDs located in the previous step to attach the entitlements to the system:

        # subscription-manager attach --pool=pool_id

4. Disable all existing repositories:

        # subscription-manager repos --disable=*

5. Enable the required channels:

        # subscription-manager repos --enable=rhel-7-server-rpms
        # subscription-manager repos --enable=rhel-7-server-supplementary-rpms
        # subscription-manager repos --enable=rhel-7-server-rhv-4.0-rpms
        # subscription-manager repos --enable=jb-eap-7-for-rhel-7-server-rpms

6. Ensure that all packages currently installed are up to date:

        # yum update

7. Install the `ovirt-engine-dwh-setup` package:

        # yum install ovirt-engine-dwh-setup

**Step 2: Stopping the Data Warehouse Service on the Manager Machine**

1. Stop the Data Warehouse service:

        # systemctl stop ovirt-engine-dwhd.service

2. If the `ovirt_engine_history` database, the Manager database, or both are hosted on the Manager machine and were configured by a previous version (Red Hat Enterprise Virtualization 3.4 or prior) that was then upgraded, you must allow the new Data Warehouse machine to access them. Edit the `/var/lib/pgsql/data/postgresql.conf` file and modify the `listen_addresses` line so that it matches the following:

        listen_addresses = '*'

    If the line does not exist or has been commented out, add it manually.

    If one or both databases are hosted on a remote machine, you must manually grant access by editing the `postgres.conf` file on each machine, and adding the `listen_addresses` line, as above. If both databases are hosted on the Manager machine and were configured during a clean setup of Red Hat Virtualization Manager, access is granted by default.

3. Restart the postgresql service:

        # systemctl restart postgresql.service

**Step 3: Configuring the New Data Warehouse Machine**

1. Run the `engine-setup` command to begin configuration of Data Warehouse on the machine:

        # engine-setup

2. Press **Enter** to configure Data Warehouse:

        Configure Data Warehouse on this host (Yes, No) [Yes]:

3. Press **Enter** to automatically configure the firewall, or type `No` and press **Enter** to maintain existing settings:

        Setup can automatically configure the firewall on this system.
        Note: automatic configuration of the firewall may overwrite current settings.
        Do you want Setup to configure the firewall? (Yes, No) [Yes]: 

    If you choose to automatically configure the firewall, and no firewall managers are active, you are prompted to select your chosen firewall manager from a list of supported options. Type the name of the firewall manager and press **Enter**. This applies even in cases where only one option is listed.

4. Press **Enter** to accept the automatically detected hostname, or enter an alternative hostname and press **Enter**:

        Host fully qualified DNS name of this server [autodetected host name]: 

5. Answer the following question about the location of the `ovirt_engine_history` database:

        Where is the DWH database located? (Local, Remote) [Local]: Remote

    Type the alternative option as shown above and then press **Enter**.

6. Enter the fully qualified domain name and password for your `ovirt_engine_history` database host. Press **Enter** to accept the default values in each other field:

        DWH database host []: dwh-db-fqdn
        DWH database port [5432]:
        DWH database secured connection (Yes, No) [No]:
        DWH database name [ovirt_engine_history]:
        DWH database user [ovirt_engine_history]:
        DWH database password: password

7. Enter the fully qualified domain name and password for the Manager database machine. Press **Enter** to accept the default values in each other field:

        Engine database host []: engine-db-fqdn
        Engine database port [5432]:
        Engine database secured connection (Yes, No) [No]:
        Engine database name [engine]:
        Engine database user [engine]:
        Engine database password: password

8. Press **Enter** to create a backup of the existing Data Warehouse database:

        Would you like to backup the existing database before upgrading it? (Yes, No) [Yes]:

    The time and space required for the database backup depends on the size of the database. It may take several hours to complete. If you choose not to back up the database here, and `engine-setup` fails for any reason, you will not be able to restore the database or any of the data within it. The location of the backup file appears at the end of the setup script.

9. Confirm that you want to permanently disconnect the existing Data Warehouse service from the Manager:

        Do you want to permanently disconnect this DWH from the engine? (Yes, No) [No]:

10. Confirm your installation settings:

        Please confirm installation settings (OK, Cancel) [OK]:

**Step 4: Removing the Data Warehouse Package from the Manager Machine**

1. Remove the Data Warehouse package:

        # yum remove ovirt-engine-dwh

    This step prevents the Data Warehouse service from attempting to automatically restart after an hour.

2. Remove the Data Warehouse files:

        # rm -rf /etc/ovirt-engine-dwh /var/lib/ovirt-engine-dwh

The Data Warehouse service is now hosted on a separate machine from that on which the Manager is hosted.

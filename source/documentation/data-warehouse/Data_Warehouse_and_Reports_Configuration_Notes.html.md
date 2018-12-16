---
title: Installing and Configuring Data Warehouse on a Separate Machine
---

## Installing and Configuring Data Warehouse on a Separate Machine

Install and configure Data Warehouse on a separate machine from that on which the oVirt Engine is installed. Hosting the Data Warehouse service on a separate machine helps to reduce the load on the Engine machine.

**Prerequisites**

* You must have installed and configured the Engine on a separate machine.

* To set up the Data Warehouse machine, you must have the following:

  * A virtual or physical machine with Enterprise Linux 7 installed.

  * The password from the Engine’s **/etc/ovirt-engine/engine.conf.d/10-setup-database.conf** file.

  * Allowed access from the Data Warehouse machine to the Engine database machine’s TCP port 5432.

* If you choose to use a remote Data Warehouse database, you must set up the database before installing the Data Warehouse service. A remote Data Warehouse database provides better performance than a local database. You must have the following information about the database host:

  * The fully qualified domain name of the host

  * The port through which the database can be reached (5432 by default)

  * The database name

  * The database user

  * The database password

  * You must manually grant access by editing the **postgresql.conf** file. Edit the **/var/opt/rh/rh-postgresql95/lib/pgsql/data/postgresql.conf** file and modify the `listen_addresses` line so that it matches the following:

          listen_addresses = '\*'

    If the line does not exist or has been commented out, add it manually.

    If the database is hosted on the Engine machine and was configured during a clean setup of the oVirt Engine, access is granted by default.

    **Note:** If you want to install a remote Data Warehouse database manually, see Preparing a Remote PostgreSQL Database in the Installation Guide.

**Installing and Configuring Data Warehouse on a Separate Machine**

1. Attach the required repositories to your system.

2. Ensure that all packages currently installed are up to date:

        # yum update

3. Install the `ovirt-engine-dwh-setup` package:

        # yum install ovirt-engine-dwh-setup

4. Run the `engine-setup` command and follow the prompts to configure Data Warehouse on the machine:

        # engine-setup
        Configure Data Warehouse on this host (Yes, No) [Yes]:

5. Press `Enter` to accept the automatically-detected host name, or enter an alternative host name and press `Enter`:

        Host fully qualified DNS name of this server [autodetected hostname]:

6. Press `Enter` to automatically configure the firewall, or type `No` and press `Enter` to maintain existing settings:

        Setup can automatically configure the firewall on this system.
        Note: automatic configuration of the firewall may overwrite current settings.
        Do you want Setup to configure the firewall? (Yes, No) [Yes]:

   If you choose to automatically configure the firewall, and no firewall Engines are active, you are prompted to select your chosen firewall Engine from a list of supported options. Type the name of the firewall Engine and press Enter. This applies even in cases where only one option is listed.

7. Enter the fully qualified domain name of the Engine machine, and then press `Enter`:

        Host fully qualified DNS name of the engine server []:

8. Press `Enter` to allow setup to sign the certificate on the Engine via SSH:

        Setup will need to do some actions on the remote engine server. Either automatically, using ssh as root to access it, or you will be prompted to manually perform each such action.
        Please choose one of the following:
        1 - Access remote engine server using ssh as root
        2 - Perform each action manually, use files to copy content around
        (1, 2) [1]:

9. Press `Enter` to accept the default SSH port, or enter an alternative port number and then press `Enter`:

        ssh port on remote engine server [22]:

10. Enter the root password for the Engine machine:

        root password on remote engine server Engine.example.com:

11. Answer the following questions about the Data Warehouse database:

        Where is the DWH database located? (Local, Remote) [Local]:
        Setup can configure the local postgresql server automatically for the DWH to run. This may conflict with existing applications.
        Would you like Setup to automatically configure postgresql and create DWH database, or prefer to perform that manually? (Automatic, Manual) [Automatic]:

    Press `Enter` to choose the highlighted defaults, or type your alternative preference and then press `Enter`. If you select `Remote`, you are prompted to provide details about the remote database host. Input the following values for the preconfigured remote database host:

        DWH database host []: dwh-db-fqdn
        DWH database port [5432]:
        DWH database secured connection (Yes, No) [No]:
        DWH database name [ovirt_engine_history]:
        DWH database user [ovirt_engine_history]:
        DWH database password: password

    See the “Migrating the Data Warehouse Database to a Separate Machine” section for more information on how to configure and migrate the Data Warehouse database.

12. Enter the fully qualified domain name and password for the Engine database machine. Press `Enter` to accept the default values in each other field:

        Engine database host []: engine-db-fqdn
        Engine database port [5432]:
        Engine database secured connection (Yes, No) [No]:
        Engine database name [engine]:
        Engine database user [engine]:
        Engine database password: password

13. Choose how long Data Warehouse will retain collected data:

        Please choose Data Warehouse sampling scale:
        (1) Basic
        (2) Full
        (1, 2)[1]:

    `Full` uses the default values for the data storage settings listed in the “Application Settings for the Data Warehouse service in ovirt-engine-dwhd.conf” section (recommended when Data Warehouse is installed on a remote host).

    `Basic` reduces the values of `DWH_TABLES_KEEP_HOURLY` to `720` and `DWH_TABLES_KEEP_DAILY` to `0`, easing the load on the Engine machine (recommended when the Engine and Data Warehouse are installed on the same machine).

14. Confirm your installation settings:

        Please confirm installation settings (OK, Cancel) [OK]:

15. On the oVirt Engine, restart the ovirt-engine service:

        # systemctl restart ovirt-engine.service

16. Optionally, set up SSL to secure database connections using the instructions at link: http://www.postgresql.org/docs/9.5/static/ssl-tcp.html#SSL-FILE-USAGE.

**Prev:** [Overview of Configuring Data Warehouse](Data_Collection_Setup_and_Reports_Installation_Overview)<br>
**Next:** [Migrating Data Warehouse to a Separate Machine](Migrating_Data_Warehouse_to_a_Separate_Machine)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/data_warehouse_guide/installing_and_configuring_data_warehouse_on_a_separate_machine)

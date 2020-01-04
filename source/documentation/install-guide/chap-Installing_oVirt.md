---
title: Installing oVirt
---

# Chapter 3: Installing oVirt

## Installing the oVirt Engine Packages

Before you can configure and use the oVirt Engine, you must install the `ovirt-engine` package and dependencies.

**Installing the oVirt Engine Packages**

1. Before you can start installing oVirt, add the official repository:

        # yum install https://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm

2. To ensure all packages are up to date, run the following command on the machine where you are installing the oVirt Engine:

        # yum update

    **Note:** Reboot the machine if any kernel related packages have been updated.

3. Run the following command to install the `ovirt-engine` package and dependencies.

        # yum install ovirt-engine

Proceed to the next step to configure your oVirt Engine.

## Configuring the oVirt Engine

After you have installed the `ovirt-engine` package and dependencies, you must configure the oVirt Engine using the `engine-setup` command. This command asks you a series of questions and, after you provide the required values for all questions, applies that configuration and starts the `ovirt-engine` service.

By default, `engine-setup` creates and configures the Engine database locally on the Engine machine. Alternatively, you can configure the Engine to use a remote database or a manually-configured local database; however, you must set up that database before running `engine-setup`.

To set up a remote database see [Preparing a Remote PostgreSQL Database](appe-Preparing_a_Remote_PostgreSQL_Database). To set up a manually-configured local database, see [Preparing a Local Manually-Configured PostgreSQL Database](appe-Preparing_a_Local_Manually-Configured_PostgreSQL_Database).

By default, `engine-setup` will configure a websocket proxy on the Engine. However, for security and performance reasons, the user can choose to configure it on a separate host. See [Installing the Websocket Proxy on a different host](appe-Installing_the_Websocket_Proxy_on_a_different_host) for instructions.

**Important:** The `engine-setup` command guides you through several distinct configuration stages, each comprising several steps that require user input. Suggested configuration defaults are provided in square brackets; if the suggested value is acceptable for a given step, press **Enter** to accept that value.

You can run `engine-setup --accept-defaults` to automatically accept all questions that have default answers. This option should be used with caution and only if you are familiar with engine-setup.

**Configuring the oVirt Engine**

1. Run the `engine-setup` command to begin configuration of the oVirt Engine:

        # engine-setup

2. Press **Enter** to configure the Engine:

        Configure Engine on this host (Yes, No) [Yes]:

3. Optionally allow `engine-setup` to configure the Image I/O Proxy (`ovirt-imageio-proxy`) to allow the Engine to upload virtual disks into storage domains.

        Configure Image I/O Proxy on this host? (Yes, No) [Yes]:

4. Optionally allow `engine-setup` to configure a websocket proxy server for allowing users to connect to virtual machines via the noVNC or HTML 5 consoles:

        Configure WebSocket Proxy on this machine? (Yes, No) [Yes]:

    To configure the websocket proxy on a separate machine, select `No` and refer to [Installing the Websocket Proxy on a Separate Machine](appe-Installing_the_Websocket_Proxy_on_a_Separate_Machine) for configuration instructions.

5. Choose whether to configure Data Warehouse on the Engine machine.

        Please note: Data Warehouse is required for the engine. If you choose to not configure it on this host, you have to configure it on a remote host, and then configure the engine on this host so that it can access the database of the remote Data Warehouse host.
        Configure Data Warehouse on this host (Yes, No) [Yes]:

6. Optionally allow access to a virtual machines's serial console from the command line.

        Configure VM Console Proxy on this host (Yes, No) [Yes]:

    Additional configuration is required on the client machine to use this feature. See "Opening a Serial Console to a Virtual Machine" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/).

7. Optionally install Open Virtual Network (OVN). Selecting Yes will install an OVN central server on the Engine machine, and add it to oVirt as an external network provider. The default cluster will use OVN as its default network provider, and hosts added to the default cluster will automatically be configured to communicate with OVN.

        Configure ovirt-provider-ovn (Yes, No) [Yes]:

8. Press **Enter** to accept the automatically detected hostname, or enter an alternative hostname and press **Enter**. Note that the automatically detected hostname may be incorrect if you are using virtual hosts.

        Host fully qualified DNS name of this server [*autodetected host name*]:

9. The `engine-setup` command checks your firewall configuration and offers to modify that configuration to open the ports used by the Engine for external communication such as TCP ports 80 and 443. If you do not allow `engine-setup` to modify your firewall configuration, then you must manually open the ports used by the Engine. Firewalld will be configured as the firewall manager because `iptables` have been deprecated.

        Setup can automatically configure the firewall on this system.
        Note: automatic configuration of the firewall may overwrite current settings.
        NOTICE: iptables is deprecated and will be removed in future releases
        Do you want Setup to configure the firewall? (Yes, No) [Yes]:

    If you choose to automatically configure the firewall, and no firewall managers are active, you are prompted to select your chosen firewall manager from a list of supported options. Type the name of the firewall manager and press **Enter**. This applies even in cases where only one option is listed.

10. Choose to use either a local or remote PostgreSQL database as the Data Warehouse database:

        Where is the DWH database located? (Local, Remote) [Local]:

    * If you select `Local`, the `engine-setup` command can configure your database automatically (including adding a user and a database), or it can connect to a preconfigured local database:

            Setup can configure the local postgresql server automatically for the DWH to run. This may conflict with existing applications.
            Would you like Setup to automatically configure postgresql and create DWH database, or prefer to perform that manually? (Automatic, Manual) [Automatic]:

    * If you select `Automatic` by pressing **Enter**, no further action is required here.

    * If you select `Manual`, input the following values for the manually-configured local database:

            DWH database secured connection (Yes, No) [No]:
            DWH database name [ovirt_engine_history]:
            DWH database user [ovirt_engine_history]:
            DWH database password:

        **Note:** `engine-setup` requests these values after the Engine database is configured in the next step.

    * If you select `Remote`, input the following values for the preconfigured remote database host:

            DWH database host [localhost]:
            DWH database port [5432]:
            DWH database secured connection (Yes, No) [No]:
            DWH database name [ovirt_engine_history]:
            DWH database user [ovirt_engine_history]:
            DWH database password:

        **Note:** `engine-setup` requests these values after the Engine database is configured in the next step.

11. Choose to use either a local or remote PostgreSQL database as the Engine database:

        Where is the Engine database located? (Local, Remote) [Local]:

    * If you select `Local`, the `engine-setup` command can configure your database automatically (including adding a user and a database), or it can connect to a preconfigured local database:

            Setup can configure the local postgresql server automatically for the engine to run. This may conflict with existing applications.
            Would you like Setup to automatically configure postgresql and create Engine database, or prefer to perform that manually? (Automatic, Manual) [Automatic]:

        * If you select `Automatic` by pressing **Enter**, no further action is required here.

        * If you select `Manual`, input the following values for the manually-configured local database:

                Engine database secured connection (Yes, No) [No]:
                Engine database name [engine]:
                Engine database user [engine]:
                Engine databuase password:

        * If you select `Remote`, input the following values for the preconfigured remote database host:

                Engine database host [localhost]:
                Engine database port [5432]:
                Engine database secured connection (Yes, No) [No]:
                Engine database name [engine]:
                Engine database user [engine]:
                Engine database password:

12. Set a password for the automatically created administrative user of the oVirt Engine:

        Engine admin password:
        Confirm engine admin password:

13. Select **Gluster**, **Virt**, or **Both**:

        Application mode (Both, Virt, Gluster) [Both]:

    **Both** offers the greatest flexibility. In most cases, select `Both`. Virt application mode allows you to run virtual machines in the environment; Gluster application mode only allows you to manage GlusterFS from the Administration Portal.

14. If you installed the OVN provider, you can choose to use the default credentials, or specify an alternative.

        Use default credentials (admin@internal) for ovirt-provider-ovn (Yes, No) [Yes]:
        oVirt OVN provider user[admin@internal]:
        oVirt OVN provider password:

15. Set the default value for the `wipe_after_delete` flag, which wipes the blocks of a virtual disk when the disk is deleted.

        Default SAN wipe after delete (Yes, No) [No]:

16. The Engine uses certificates to communicate securely with its hosts. This certificate can also optionally be used to secure HTTPS communications with the Engine. Provide the organization name for the certificate:

        Organization name for certificate [*autodetected domain-based name*]:

17. Optionally allow `engine-setup` to make the landing page of the Engine the default page presented by the Apache web server:

        Setup can configure the default page of the web server to present the application home page. This may conflict with existing applications.
        Do you wish to set the application as the default web page of the server? (Yes, No) [Yes]:

18. By default, external SSL (HTTPS) communication with the Engine is secured with the self-signed certificate created earlier in the configuration to securely communicate with hosts. Alternatively, choose another certificate for external HTTPS connections; this does not affect how the Engine communicates with hosts:

        Setup can configure apache to use SSL using a certificate issued from the internal CA.
        Do you wish Setup to configure that, or prefer to perform that manually? (Automatic, Manual) [Automatic]:

19. Choose how long Data Warehouse will retain collected data:

    **Note:** This step is skipped if you chose not to configure Data Warehouse on the Engine machine.

        Please choose Data Warehouse sampling scale:
        (1) Basic
        (2) Full
        (1, 2)[1]:

    `Full` uses the default values for the data storage settings listed in the [Data Warehouse Guide](/documentation/data-warehouse/Data_Warehouse_Guide/) (recommended when Data Warehouse is installed on a remote host).

    `Basic` reduces the values of `DWH_TABLES_KEEP_HOURLY` to `720` and `DWH_TABLES_KEEP_DAILY` to `0`, easing the load on the Engine machine (recommended when the Engine and Data Warehouse are installed on the same machine).

20. Review the installation settings, and press **Enter** to accept the values and proceed with the installation:

        Please confirm installation settings (OK, Cancel) [OK]:

    When your environment has been configured, `engine-setup` displays details about how to access your environment. If you chose to manually configure the firewall, `engine-setup` provides a custom list of ports that need to be opened, based on the options selected during setup. The `engine-setup` command also saves your answers to a file that can be used to reconfigure the Engine using the same values, and outputs the location of the log file for the oVirt Engine configuration process.

21. If you intend to link your oVirt environment with a directory server, configure the date and time to synchronize with the system clock used by the directory server to avoid unexpected account expiry issues.

22. Install the certificate authority according to the instructions provided by your browser. You can get the certificate authority’s certificate by navigating to`http://your-manager-fqdn/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA`, replacing your-manager-fqdn with the fully qualified domain name (FQDN) that you provided during the installation.

Proceed to the next section to connect to the Administration Portal as the `admin@internal` user. Then, proceed with setting up hosts, and attaching storage.

## Connecting to the Administration Portal

Access the Administration Portal using a web browser.

1. In a web browser, navigate to `https://your-manager-fqdn/ovirt-engine`, replacing *`your-manager-fqdn`* with the fully qualified domain name that you provided during installation.

    **Note:** You can access the Administration Portal using alternate host names or IP addresses. To do so, you need to add a configuration file under **/etc/ovirt-engine/engine.conf.d/**. For example:

          # vi /etc/ovirt-engine/engine.conf.d/99-custom-sso-setup.conf
          SSO_ALTERNATE_ENGINE_FQDNS="alias1.example.com alias2.example.com"

    The list of alternate host names needs to be separated by spaces. You can also add the IP address of the Engine to the list, but using IP addresses instead of DNS-resolvable host names is not recommended.

2. Click **Administration Portal**. An SSO login page displays. SSO login enables you to log in to the Administration and VM Portal at the same time.

3. Enter your **User Name** and **Password**. If you are logging in for the first time, use the user name `admin` in conjunction with the password that you specified during installation.

4. Select the domain against which to authenticate from the **Domain** list. If you are logging in using the internal `admin` user name, select the `internal` domain.

5. Click **Log In**.

6. You can view the Administration Portal in multiple languages. The default selection will be chosen based on the locale settings of your web browser. If you would like to view the Administration Portal in a language other than the default, select your preferred language from the drop-down list on the welcome page.

To log out of the oVirt Administration Portal, click your user name in the header bar and click **Sign Out**. You are logged out of all portals and the Engine welcome screen displays.

The next chapter contains additional Engine-related tasks that are optional. If the tasks are not applicable to your environment, proceed to **Part III: Installing Hosts**.

**Prev:** [Chapter 2: System Requirements](chap-System_Requirements) <br>
**Next:** [Chapter 4: oVirt Engine Related Tasks](chap-oVirt_Engine_Related_Tasks)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/installation_guide/chap-red_hat_virtualization_manager)

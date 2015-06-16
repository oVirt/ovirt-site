---
title: DraftInstallationGuide
category: documentation
authors: bproffitt
wiki_title: DraftInstallationGuide
wiki_revision_count: 17
wiki_last_updated: 2014-07-10
---

# Draft Installation Guide

**Abstract**

A comprehensive guide to installing oVirt 3.4.

## ⁠Chapter 1. Installing oVirt

### Workflow Progress - Installing oVirt

![](images/1191.png "images/1191.png")

### Installing oVirt

*Overview*'

oVirt can be installed under one of two arrangements - a standard setup in which oVirt is installed on an independent physical machine or virtual machine, or a self-hosted engine setup in which oVirt runs on a virtual machine that oVirt itself controls.

<div class="alert alert-info">
**Important:** While the prerequisites for and basic configuration of oVirt itself are the same for both standard and self-hosted engine setups, the process for setting up a self-hosted engine is different from that of a standard setup.

</div>
**Prerequisites**

Before installing oVirt, you must ensure that you meet all the prerequisites. To complete installation of oVirt successfully, you must also be able to determine:

1.  The ports to be used for HTTP and HTTPS communication. The defaults ports are `80` and `443` respectively.
2.  The fully qualified domain name (FQDN) of the system on which oVirt is to be installed.
3.  The password you use to secure the oVirt administration account.
4.  The location of the database server to be used. You can use the setup script to install and configure a local database server or use an existing remote database server. To use a remote database server you must know:
    -   The host name of the system on which the remote database server exists.
    -   The port on which the remote database server is listening.
    -   That the `uuid-ossp` extension had been loaded by the remote database server.

    You must also know the user name and password of a user that is known to the remote database server. The user must have permission to create databases in PostgreSQL.

5.  The organization name to use when creating oVirt's security certificates.
6.  The storage type to be used for the initial data center attached to oVirt. The default is NFS.
7.  The path to use for the ISO share, if oVirt is being configured to provide one. The display name, which will be used to label the domain in oVirt also needs to be provided.
8.  The firewall rules, if any, present on the system that need to be integrated with the rules required for oVirt to function.

**Configuration**

Before installation is completed the values selected are displayed for confirmation. Once the values have been confirmed they are applied and oVirt is ready for use.

⁠

**Example 1.1. Completed Installation**

    --== CONFIGURATION PREVIEW ==--

    Engine database name                    : engine
    Engine database secured connection      : False
    Engine database host                    : localhost
    Engine database user name               : engine
    Engine database host name validation    : False
    Engine database port                    : 5432
    NFS setup                               : True
    PKI organization                        : Your Org
    Application mode                        : both
    Firewall manager                        : iptables
    Update Firewall                         : True
    Configure WebSocket Proxy               : True
    Host FQDN                               : Your Manager's FQDN
    NFS export ACL                          : 0.0.0.0/0.0.0.0(rw)
    NFS mount point                         : /var/lib/exports/iso
    Datacenter storage type                 : nfs
    Configure local Engine database         : True
    Set application as default page         : True
    Configure Apache SSL                    : True

    Please confirm installation settings (OK, Cancel) [OK]:

<div class="alert alert-info">
**Note:** Automated installations are created by providing `engine-setup` with an answer file. An answer file contains answers to the questions asked by the setup command.

</div>
*   To create an answer file, use the *`--generate-answer`* parameter to specify a path and file name with which to create the answer file. When this option is specified, the `engine-setup` command records your answers to the questions in the setup process to the answer file.
        # engine-setup --generate-answer=[ANSWER_FILE]

*   To use an answer file for a new installation, use the *`--config-append`* parameter to specify the path and file name of the answer file to be used. The `engine-setup` command will use the answers stored in the file to complete the installation.
        # engine-setup --config-append=[ANSWER_FILE]

Run `engine-setup --help` for a full list of parameters.

<div class="alert alert-info">
**Note:** Offline installation requires the creation of a software repository local to your oVirt environment. This software repository must contain all of the packages required to install oVirt, Red Hat Enterprise Linux virtualization hosts, and Red Hat Enterprise Linux virtual machines. To create such a repository, see the *Installing Red Hat Enterprise Virtualization Offline* technical brief, available at [<https://access.redhat.com/knowledge/techbriefs/installing-red-hat-enterprise-virtualization-offline-rhev-30>](https://access.redhat.com/knowledge/techbriefs/installing-red-hat-enterprise-virtualization-offline-rhev-30).

</div>
### Installing oVirt

#### Configuring an Offline Repository for oVirt Installation

This task documents the creation of an offline repository containing all packages needed to install a oVirt environment. Follow these steps to create a repository you can use to install oVirt components on systems without a direct connection to Red Hat Network.

1.  **Install Red Hat Enterprise Linux**
    Install Red Hat Enterprise Linux 6 Server on a system that has access to Red Hat Network. This system downloads all required packages, and distribute them to your offline system(s).

    **Important**

    Ensure that the system used has a large amount of free disk space available. This procedure downloads a large number of packages, and requires up to 1.5 GB of free disk space.

2.  **Register Red Hat Enterprise Linux**
    Register the system with Red Hat Network (RHN) using either Subscription Manager or RHN Classic.

    -   **Subscription Manager**
        Use the `subscription-manager` command as `root` with the *`register`* parameter.

            # subscription-manager register

    -   **RHN Classic**
        Use the `rhn_register` command as `root`.

            # rhn_register

3.  **Add required channel subscriptions**
    Subscribe the system for all channels listed in the *Red Hat Enterprise Virtualization - Installation Guide*.

    -   **Subscription Manager**
    -   **RHN Classic**

4.  **Configure File Transfer Protocol (FTP) access**
    Servers that are not connected to the Internet can access the software repository using File Transfer Protocol (FTP). To create the FTP repository you must install and configure vsftpd, while logged in to the system as the `root` user:

    1.  **Install vsftpd**
        Install the vsftpd package.

            # yum install vsftpd

    2.  **Start vsftpd**
        Start the `vsftpd` daemon.

            # chkconfig vsftpd on    service vsftpd start

    3.  **Create sub-directory**
        Create a sub-directory inside the `/var/ftp/pub/` directory. This is where the downloaded packages will be made available.

            # mkdir /var/ftp/pub/rhevrepo

5.  **Download packages**
    Once the FTP server has been configured, you must use the `reposync` command to download the packages to be shared. It downloads all packages from all configured software repositories. This includes repositories for all Red Hat Network channels the system is subscribed to, and any locally configured repositories.

    1.  As the `root` user, change into the `/var/ftp/pub/rhevrepo` directory.
            # cd /var/ftp/pub/rhevrepo

    2.  Run the `reposync` command.
            # reposync --plugins .

6.  **Create local repository metadata**
    Use the `createrepo` command to create repository metadata for each of the sub-directories where packages were downloaded under `/var/ftp/pub/rhevrepo`.

        # for DIR in `find /var/ftp/pub/rhevrepo -maxdepth 1 -mindepth 1 -type d`; do createrepo $DIR; done;

7.  **Create repository configuration files**
    Create a `yum` configuration file, and copy it to the `/etc/yum.repos.d/` directory on client systems that you want to connect to this software repository. Ensure that the system hosting the repository is connected to the same network as the client systems where the packages are to be installed.

    The configuration file can be created manually, or using a script. If using a script, then before running it you must replace `ADDRESS` in the *`baseurl`* with the IP address or Fully Qualified Domain Name (FQDN) of the system hosting the repository. The script must be run on this system and then distributed to the client machines. For example:

        #!/bin/sh

        REPOFILE=&quot;/etc/yum.repos.d/rhev.repo&quot;

        for DIR in `find /var/ftp/pub/rhevrepo -maxdepth 1 -mindepth 1 -type d`; do  
            echo -e &quot;[`basename $DIR`]&quot;   &gt; $REPOFILE  
            echo -e &quot;name=`basename $DIR`&quot; &gt;&gt; $REPOFILE 
            echo -e &quot;baseurl=ftp://ADDRESS/pub/rhevrepo/`basename $DIR`&quot; &gt;&gt; $REPOFILE   
            echo -e &quot;enabled=1&quot; &gt;&gt; $REPOFILE  
            echo -e &quot;gpgcheck=0&quot; &gt;&gt; $REPOFILE 
            echo -e &quot;\n&quot; &gt;&gt; $REPOFILE
        done;

8.  **Copy the repository configuration file to client system**
    Copy the repository configuration file to the `/etc/yum.repos.d/` directory on every system that you want to connect to this software repository. For example: oVirt system(s), all Red Hat Enterprise Linux virtualization hosts, and all Red Hat Enterprise Linux virtual machines.

Now that your client systems have been configured to use your local repository, you can proceed with management server, virtualization host, and virtual machine installation as documented in the oVirt product documentation. Instead of installing packages from Red Hat Network, you can install them from your newly created local repository.

<div class="alert alert-info">
**Note:** You can also provide the software repository created here to client systems using removable media, such as a portable USB drive. To do this, first create the repository using the steps provided, and then:

1.  Recursively copy the `/var/ftp/pub/rhevrepo` directory, and all its contents, to the removable media.
2.  Modify the `/etc/yum.repos.d/rhev.repo` file, replacing the `baseurl` values with the path to which the removable media will be mounted on the client systems. For example `file:///media/disk/rhevrepo/`.
    </div>

<div class="alert alert-info">
**Note:** As updated packages are released to Red Hat Network - addressing security issues, fixing bugs, and adding enhancements - you must update your local repository. To do this, repeat the procedure for synchronizing and sharing the channels. Adding the *`--newest-only`* parameter to the `reposync` command ensures that it only retrieves the newest version of each available package. Once the repository is updated you must ensure it is available to each of your client systems and then run `yum update` on it.

</div>
#### Installing oVirt Packages

**Summary**

Before you can configure and use oVirt, you must install the rhevm package and dependencies.

**Procedure 1.1. Installing oVirt Packages**

1.  To ensure all packages are up to date, run the following command on the machine where you are installing oVirt:
        # yum update

2.  Run the following command to install the rhevm package and dependencies.
        # yum install rhevm

    **Note**

    The rhevm-doc package is installed as a dependency of the rhevm package, and provides a local copy of the Red Hat Enterprise Virtualization documentation suite. This documentation is also used to provide context sensitive help links from the Administration and User Portals. You can run the following commands to search for translated versions of the documentation:

        # yum search rhevm-doc

**Result**

You have installed the rhevm package and dependencies.

####  Configuring oVirt

After you have installed the rhevm package and dependencies, you must configure oVirt using the `engine-setup` command. This command asks you a series of questions and, after you provide the required values for all questions, applies that configuration and starts the `ovirt-engine` service.

<div class="alert alert-info">
**Note:** The `engine-setup` command guides you through several distinct configuration stages, each comprising several steps that require user input. Suggested configuration defaults are provided in square brackets; if the suggested value is acceptable for a given step, press **Enter** to accept that value.

</div>
⁠

**Procedure 1.2. Configuring oVirt**

1.  **Packages**
    The `engine-setup` command checks to see if it is performing an upgrade or an installation, and whether any updates are available for the packages linked to oVirt. No user input is required at this stage.

        [ INFO  ] Checking for product updates...
        [ INFO  ] No product updates found

2.  **Network Configuration**
    A reverse lookup is performed on the host name of the machine on which oVirt is being installed. The host name is detected automatically, but you can correct this host name if it is incorrect or if you are using virtual hosts. There must be forward and reverse lookup records for the provided host name in DNS, especially if you will also install the reports server.

        Host fully qualified DNS name of this server [autodetected host name]:

    The `engine-setup` command checks your firewall configuration and offers to modify that configuration for you to open the ports used by oVirt for external communication such as TCP ports 80 and 443. If you do not allow the `engine-setup` command to modify your firewall configuration, then you must manually open the ports used by oVirt.

        Do you want Setup to configure the firewall? (Yes, No) [Yes]:

3.  **Database Configuration**
    You can use either a local or remote PostgreSQL database. The `engine-setup` command can configure your database automatically (including adding a user and a database), or it can use values that you supply.

        Where is the database located? (Local, Remote) [Local]: 
        Setup can configure the local postgresql server automatically for the engine to run. This may conflict with existing applications.
        Would you like Setup to automatically configure postgresql and create Engine database, or prefer to perform that manually? (Automatic, Manual) [Automatic]:

4.  **oVirt Engine Configuration**
    Select **Gluster**, **Virt**, or **Both**:

        Application mode (Both, Virt, Gluster) [Both]:

    **Both** offers the greatest flexibility.

    Choose the initial data center storage type. You can have many data centers in your environment, each with a different type of storage; this is the storage type of your first data center:

        Default storage type: (NFS, FC, ISCSI, POSIXFS) [NFS]:

    Set a password for the automatically created administrative user of oVirt:

        Engine admin password:
        Confirm engine admin password:

5.  **PKI Configuration**
    oVirt uses certificates to communicate securely with its hosts. You provide the organization name for the certificate. This certificate can also optionally be used to secure https communications with oVirt.

        Organization name for certificate [autodetected domain-based name]:

6.  **Apache Configuration**
    By default, external SSL (HTTPS) communication with oVirt is secured with the self-signed certificate created in the PKI configuration stage to securely communicate with hosts. Another certificate may be chosen for external HTTPS connections, without affecting how oVirt communicates with hosts.

        Setup can configure apache to use SSL using a certificate issued from the internal CA.
        Do you wish Setup to configure that, or prefer to perform that manually? (Automatic, Manual) [Automatic]:

    oVirt uses the Apache web server to present a landing page to users. The `engine-setup` command can make the landing page of oVirt the default page presented by Apache.

        Setup can configure the default page of the web server to present the application home page. This may conflict with existing applications.
        Do you wish to set the application as the default web page of the server? (Yes, No) [Yes]:

7.  **System Configuration**
    The `engine-setup` command can create an NFS share on oVirt to use as an ISO storage domain. Hosting the ISO domain locally to oVirt simplifies keeping some elements of your environment up to date.

        Configure an NFS share on this server to be used as an ISO Domain? (Yes, No) [Yes]: 
        Local ISO domain path [/var/lib/exports/iso]: 
        Local ISO domain ACL [0.0.0.0/0.0.0.0(rw)]: 
        Local ISO domain name [ISO_DOMAIN]:

8.  **Websocket Proxy Server Configuration**
    The `engine-setup` command can optionally configure a websocket proxy server for allowing users to connect to virtual machines via the noVNC or HTML 5 consoles.

        Configure WebSocket Proxy on this machine? (Yes, No) [Yes]:

9.  **Miscellaneous Configuration**
    You can use the `engine-setup` command to allow a proxy server to broker transactions from the Red Hat Access plug-in.

        Would you like transactions from the Red Hat Access Plugin sent from the RHEV Manager to be brokered through a proxy server? (Yes, No) [No]:

        [ INFO  ] Stage: Setup validation

10. **Configuration Preview**
    Check the configuration preview to confirm the values you entered before they are applied. If you choose to proceed, `engine-setup` configures oVirt using those values.

        Engine database name                    : engine
        Engine database secured connection      : False
        Engine database host                    : localhost
        Engine database user name               : engine
        Engine database host name validation    : False
        Engine database port                    : 5432
        NFS setup                               : True
        PKI organization                        : Your Org
        Application mode                        : both
        Firewall manager                        : iptables
        Update Firewall                         : True
        Configure WebSocket Proxy               : True
        Host FQDN                               : Your Manager's FQDN
        NFS export ACL                          : 0.0.0.0/0.0.0.0(rw)
        NFS mount point                         : /var/lib/exports/iso
        Datacenter storage type                 : nfs
        Configure local Engine database         : True
        Set application as default page         : True
        Configure Apache SSL                    : True

        Please confirm installation settings (OK, Cancel) [OK]:

    When your environment has been configured, the `engine-setup` command displays details about how to access your environment and related security details.

11. **Clean Up and Termination**
    The `engine-setup` command cleans up any temporary files created during the configuration process, and outputs the location of the log file for oVirt configuration process.

        [ INFO  ] Stage: Clean up
                  Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-installation-date.log
        [ INFO  ] Stage: Pre-termination
        [ INFO  ] Stage: Termination
        [ INFO  ] Execution of setup completed successfully

**Result**

oVirt has been configured and is running on your server. You can log in to the Administration Portal as the `admin@internal` user to continue configuring oVirt. Furthermore, the `engine-setup` command saves your answers to a file that can be used to reconfigure oVirt using the same values.

####  Preparing a PostgreSQL Database for Use with oVirt

**Summary**

You can manually configure a database server to host the database used by oVirt. The database can be hosted either locally on the machine on which oVirt is installed, or remotely on another machine.

<div class="alert alert-info">
**Important:** The database must be prepared prior to running the `engine-setup` command.

</div>
⁠

**Procedure 1.3. Preparing a PostgreSQL Database for use with oVirt**

1.  Run the following commands to initialize the PostgreSQL database, start the `postgresql` service and ensure this service starts on boot:
        # service postgresql initdb
        # service postgresql start
        # chkconfig postgresql on

2.  Create a user for oVirt to use when it writes to and reads from the database, and a database in which to store data about the oVirt environment. You must perform this step on both local and remote databases. Use the **psql** terminal as the `postgres` user.
        # su - postgres
        $ psql              
        postgres=# create role [user name] with login encrypted password '[password]';
        postgres=# create database [database name] owner [user name] template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';

3.  Run the following commands to connect to the new database and add the `plpgsql` language:
        postgres=# \c [database name]
        CREATE LANGUAGE plpgsql;

4.  Ensure the database can be accessed remotely by enabling client authentication. Edit the `/var/lib/pgsql/data/pg_hba.conf` file, and add the following in accordance with the location of the database:
    -   For local databases, add the two following lines immediately underneath the line starting with `Local` at the bottom of the file:
            host    [database name]    [user name]    0.0.0.0/0  md5
            host    [database name]    [user name]    ::0/0      md5

    -   For remote databases, add the following line immediately underneath the line starting with `Local` at the bottom of the file, replacing *X.X.X.X* with the IP address of oVirt:
            host    [database name]    [user name]    X.X.X.X/32   md5

5.  Allow TCP/IP connections to the database. You must perform this step for remote databases. Edit the `/var/lib/pgsql/data/postgresql.conf` file and add the following line:
        listen_addresses='*'

    This example configures the `postgresql` service to listen for connections on all interfaces. You can specify an interface by giving its IP address.

6.  Restart the `postgresql` service. This step is required on both local and remote manually configured database servers.
        # service postgresql restart

**Result**

You have manually configured a PostgreSQL database to use with oVirt.

####  Configuring oVirt to Use a Manually Configured Local or Remote PostgreSQL Database

**Summary**

During the database configuration stage of configuring oVirt using the `engine-setup` script, you can choose to use a manually configured database. You can select to use a locally or remotely installed PostgreSQL database.

⁠

**Procedure 1.4. Configuring oVirt to use a Manually Configured Local or Remote PostgreSQL Database**

1.  During configuration of oVirt, the `engine-setup` command prompts you to decide where your database is located:
        Where is the database located? (Local, Remote) [Local]:

    The steps involved in manually configuring oVirt to use local or remotely hosted databases are the same. However, to use a remotely hosted database you must provide the host name of the remote database server and the port on which it is listening.

2.  When prompted, enter `Manual` to manually configure the database:
        Would you like Setup to automatically configure postgresql, or prefer to perform that manually? (Automatic, Manual) [Automatic]: Manual

3.  If you are using a remotely hosted database, supply the `engine-setup` command with the host name of your database server and the port on which it is listening:
        Database host [localhost]:
        Database port [5432]:

4.  For both local and remotely hosted databases, you must select whether or not your database uses a secured connection. You must also enter the name of the database you configured, the user oVirt can use to access the database, and the password of that user.
        Database secured connection (Yes, No) [No]: 
        Database name [engine]: 
        Database user [engine]: 
        Database password:

    **Note**

    Using a secured connection to your database requires you to also have manually configured secured database connections.

**Result**

You have configured oVirt to use a manually configured database. The `engine-setup` command continues with the rest of your environment configuration.

####  Connecting to the Administration Portal

**Summary**

Access the Administration Portal using a web browser.

⁠

**Procedure 1.5. Connecting to the Administration Portal**

1.  Open a supported web browser.
2.  Navigate to `https://[your-manager-fqdn]/ovirt-engine`, replacing *[your-manager-fqdn]* with the fully qualified domain name that you provided during installation to open the login screen.
    **Important**

    The first time that you connect to the Administration Portal, you are prompted to trust the certificate being used to secure communications between your browser and the web server.

3.  Enter your **User Name** and **Password**. If you are logging in for the first time, use the user name `admin` in conjunction with the administrator password that you specified during installation.
4.  Select the domain against which to authenticate from the **Domain** drop-down list. If you are logging in using the internal `admin` user name, select the `internal` domain.
5.  You can view the Administration Portal in multiple languages. The default selection will be chosen based on the locale settings of your web browser. If you would like to view the Administration Portal in a language other than the default, select your preferred language from the list.
6.  Click **Login**.

**Result**

You have logged into the Administration Portal.

####  Removing oVirt

**Summary**

You can use the `engine-cleanup` command to remove specific components or all components of oVirt. ⁠

**Procedure 1.6. Removing oVirt**

1.  Run the following command on the machine on which oVirt is installed:
        # engine-cleanup

2.  You are prompted whether to remove all oVirt components:
    -   Type `Yes` and press **Enter** to remove all components:
            Do you want to remove all components? (Yes, No) [Yes]:

    -   Type `No` and press **Enter** to select the components to remove. You can select whether to retain or remove each component individually:
            Do you want to remove Engine database content? All data will be lost (Yes, No) [No]: 
            Do you want to remove PKI keys? (Yes, No) [No]: 
            Do you want to remove PKI configuration? (Yes, No) [No]: 
            Do you want to remove Apache SSL configuration? (Yes, No) [No]:

3.  You are given another opportunity to change your mind and cancel the removal of oVirt. If you choose to proceed, the `ovirt-engine` service is stopped, and your environment's configuration is removed in accordance with the options you selected.
        During execution engine service will be stopped (OK, Cancel) [OK]:
        ovirt-engine is about to be removed, data will be lost (OK, Cancel) [Cancel]:OK

<div class="alert alert-info">
**Note:** A backup of the engine database and a compressed archive of the PKI keys and configuration are always automatically created. These files are saved under `/var/lib/ovirt-engine/backups/`, and include the date and `engine-` and `engine-pki-` in their file names, respectively.

</div>
**Result**

The configuration files of your environment have been removed according to your selections when you ran `engine-cleanup`.

You can now safely remove the oVirt packages using the `yum` command.

    # yum remove rhevm* vdsm-bootstrap

## ⁠Chapter 2. The Self-Hosted Engine

### About the Self-Hosted Engine

A self-hosted engine is a virtualized environment in which the engine, or Manager, runs on a virtual machine on the hosts managed by that engine. The virtual machine is created as part of the host configuration, and the engine is installed and configured in parallel to that host configuration process, referred to in these procedures as the deployment.

The virtual machine running the engine is created to be highly available. This means that if the host running the virtual machine goes into maintenance mode, or fails unexpectedly, the virtual machine will be migrated automatically to another host in the environment.

The primary benefit of the self-hosted engine is that it requires less hardware to deploy an instance of oVirt as the engine runs as a virtual machine, not on physical hardware. Additionally, the engine is configured to be highly available automatically, rather than requiring a separate cluster.

The self-hosted engine currently only runs on Red Hat Enterprise Linux 6.5 hosts. oVirt Nodes and older versions of Red Hat Enterprise Linux are not recommended for use with a self-hosted engine.

### Limitations of the Self-Hosted Engine

At present there are two main limitations of the self-hosted engine configuration:

*   An NFS storage domain is required for the configuration. NFS is the only supported file system for the self-hosted engine.
*   The host and hosted engine must use Red Hat Enterprise Linux 6.5 or above. oVirt Nodes are not supported.

### Installing the Self-Hosted Engine

**Error**

Topic 25551 failed Injection processing and is not included in this build.

Please review the compiler error for [Topic ID 25551](#TagErrorXRef25551) for more detailed information.

### Configuring the Self-Hosted Engine

**Summary**

When package installation is complete, oVirt must be configured. The `hosted-engine` deployment script is provided to assist with this task. The script asks you a series of questions, and configures your environment based on your answers. When the required values have been provided, the updated configuration is applied and oVirt services are started.

The `hosted-engine` deployment script guides you through several distinct configuration stages. The script suggests possible configuration defaults in square brackets. Where these default values are acceptable, no additional input is required.

This procedure requires a new Red Hat Enterprise Linux 6.5 host with the ovirt-hosted-engine-setup package installed. This host is referred to as 'Host-HE1', with a fully qualified domain name (FQDN) of `Host-HE1.example.com` in this procedure.

The hosted engine, the virtual machine created during configuration of Host-HE1 to manage the environment, is referred to as 'my-engine'. You will be prompted by the `hosted-engine` deployment script to access this virtual machine multiple times to install an operating system and to configure the engine.

All steps in this procedure are to be conducted as the `root` user for the specified machine.

⁠

**Procedure 2.1. Configuring the Self-Hosted Engine**

1.  **Initiating Hosted Engine Deployment**
    Begin configuration of the self-hosted environment by deploying the `hosted-engine` customization script on Host_HE1. To escape the script at any time, use the **CTRL**+**D** keyboard combination to abort deployment.

        # hosted-engine --deploy

2.  **Configuring Storage**
    Select the version of NFS and specify the full address, using either the FQDN or IP address, and path name of the shared storage domain. Choose the storage domain and storage data center names to be used in the environment.

        During customization use CTRL-D to abort.
        Please specify the storage you would like to use (nfs3, nfs4)[nfs3]: 
        Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine/nfs
        [ INFO  ] Installing on first host
        Please provide storage domain name. [hosted_storage]: 
        Local storage datacenter name is an internal name and currently will not be shown in engine's admin UI.Please enter local datacenter name [hosted_datacenter]: 

3.  **Configuring the Network**
    The script detects possible network interface controllers (NICs) to use as a management bridge for the environment. It then checks your firewall configuration and offers to modify it for console (SPICE or VNC) access HostedEngine-VM. Provide a pingable gateway IP address, to be used by the `ovirt-ha-agent` to help determine a host's suitability for running HostedEngine-VM.

        Please indicate a nic to set rhevm bridge on: (eth1, eth0) [eth1]:
        iptables was detected on your computer, do you wish setup to configure it? (Yes, No)[Yes]: 
        Please indicate a pingable gateway IP address [X.X.X.X]: 

4.  **Configuring the Virtual Machine**
    The script creates a virtual machine to be configured as oVirt, the hosted engine referred to in this procedure as HostedEngine-VM. Specify the boot device and, if applicable, the path name of the installation media, the CPU type, the number of virtual CPUs, and the disk size. Specify a MAC address for the HostedEngine-VM, or accept a randomly generated one. The MAC address can be used to update your DHCP server prior to installing the operating system on the virtual machine. Specify memory size and console connection type for the creation of HostedEngine-VM.

        Please specify the device to boot the VM from (cdrom, disk, pxe) [cdrom]: 
        The following CPU types are supported by this host:
                  - model_Penryn: Intel Penryn Family
                  - model_Conroe: Intel Conroe Family
        Please specify the CPU type to be used by the VM [model_Penryn]: 
        Please specify the number of virtual CPUs for the VM [Defaults to minimum requirement: 2]: 
        Please specify the disk size of the VM in GB [Defaults to minimum requirement: 25]: 
        You may specify a MAC address for the VM or accept a randomly generated default [00:16:3e:77:b2:a4]: 
        Please specify the memory size of the VM in MB [Defaults to minimum requirement: 4096]: 
        Please specify the console type you would like to use to connect to the VM (vnc, spice) [vnc]: 

5.  **Configuring the Hosted Engine**
    Specify the name for Host-HE1 to be identified in the oVirt environment, and the password for the `admin@internal` user to access the Administrator Portal. Provide the FQDN for HostedEngine-VM; this procedure uses the FQDN *HostedEngine-VM.example.com*. Finally, provide the name and TCP port number of the SMTP server, the email address used to send email notifications, and a comma-separated list of email addresses to receive these notifications.

        Enter the name which will be used to identify this host inside the Administrator Portal [hosted_engine_1]: Host-HE1
        Enter 'admin@internal' user password that will be used for accessing the Administrator Portal: 
        Confirm 'admin@internal' user password: 
        Please provide the FQDN for the engine you would like to use. This needs to match the FQDN that you will use for the engine installation within the VM: HostedEngine-VM.example.com
        Please provide the name of the SMTP server through which we will send notifications [localhost]: 
        Please provide the TCP port number of the SMTP server [25]: 
        Please provide the email address from which notifications will be sent [root@localhost]: 
        Please provide a comma-separated list of email addresses which will get notifications [root@localhost]: 

6.  **Configuration Preview**
    Before proceeding, the `hosted-engine` script displays the configuration values you have entered, and prompts for confirmation to proceed with these values.

        Bridge interface                   : eth1
        Engine FQDN                        : HostedEngine-VM.example.com
        Bridge name                        : rhevm
        SSH daemon port                    : 22
        Firewall manager                   : iptables
        Gateway address                    : X.X.X.X
        Host name for web application      : Host-HE1
        Host ID                            : 1
        Image size GB                      : 25
        Storage connection                 : storage.example.com:/hosted_engine/nfs
        Console type                       : vnc
        Memory size MB                     : 4096
        MAC address                        : 00:16:3e:77:b2:a4
        Boot type                          : pxe
        Number of CPUs                     : 2
        CPU Type                           : model_Penryn

        Please confirm installation settings (Yes, No)[No]: 

7.  **Creating HostedEngine-VM**
    The script creates a virtual machine to be HostedEngine-VM and provides connection details. You must install an operating system on HostedEngine-VM before the `hosted-engine` script can proceed on Host-HE1.

        [ INFO  ] Generating answer file '/etc/ovirt-hosted-engine/answers.conf'
        [ INFO  ] Stage: Transaction setup
        [ INFO  ] Stage: Misc configuration
        [ INFO  ] Stage: Package installation
        [ INFO  ] Stage: Misc configuration
        [ INFO  ] Configuring libvirt
        [ INFO  ] Generating VDSM certificates
        [ INFO  ] Configuring VDSM
        [ INFO  ] Starting vdsmd
        [ INFO  ] Waiting for VDSM hardware info
        [ INFO  ] Creating Storage Domain
        [ INFO  ] Creating Storage Pool
        [ INFO  ] Connecting Storage Pool
        [ INFO  ] Verifying sanlock lockspace initialization
        [ INFO  ] Initializing sanlock lockspace
        [ INFO  ] Initializing sanlock metadata
        [ INFO  ] Creating VM Image
        [ INFO  ] Disconnecting Storage Pool
        [ INFO  ] Start monitoring domain
        [ INFO  ] Configuring VM
        [ INFO  ] Updating hosted-engine configuration
        [ INFO  ] Stage: Transaction commit
        [ INFO  ] Stage: Closing up
        [ INFO  ] Creating VM
        You can now connect to the VM with the following command:
            /usr/bin/remote-viewer vnc://localhost:5900
        Use temporary password &quot;3042QHpX&quot; to connect to vnc console.
        Please note that in order to use remote-viewer you need to be able to run graphical applications.
        This means that if you are using ssh you have to supply the -Y flag (enables trusted X11 forwarding).
        Otherwise you can run the command from a terminal in your preferred desktop environment.
        If you cannot run graphical applications you can connect to the graphic console from another host or connect to the console using the following command:
        virsh -c qemu+tls://Test/system console HostedEngine
        If you need to reboot the VM you will need to start it manually using the command:
        hosted-engine --vm-start
        You can then set a temporary password using the command:
        hosted-engine --add-console-password
        The VM has been started.  Install the OS and shut down or reboot it.  To continue please make a selection:

                  (1) Continue setup - VM installation is complete
                  (2) Reboot the VM and restart installation
                  (3) Abort setup

                  (1, 2, 3)[1]:

    Using the naming convention of this procedure, connect to the virtual machine using VNC with the following command:

        /usr/bin/remote-viewer vnc://Host-HE1.example.com:5900

8.  **Installing the Virtual Machine Operating System**
    Connect to HostedEngine-VM, the virtual machine created by the hosted-engine script, and install a Red Hat Enterprise Linux 6.5 operating system. Ensure the machine is rebooted once installation has completed.

9.  **Synchronizing the Host and the Virtual Machine**
    Return to Host-HE1 and continue the `hosted-engine` deployment script by selecting option 1:

        (1) Continue setup - VM installation is complete

         Waiting for VM to shut down...
        [ INFO  ] Creating VM
        You can now connect to the VM with the following command:
            /usr/bin/remote-viewer vnc://localhost:5900
        Use temporary password &quot;3042QHpX&quot; to connect to vnc console.
        Please note that in order to use remote-viewer you need to be able to run graphical applications.
        This means that if you are using ssh you have to supply the -Y flag (enables trusted X11 forwarding).
        Otherwise you can run the command from a terminal in your preferred desktop environment.
        If you cannot run graphical applications you can connect to the graphic console from another host or connect to the console using the following command:
        virsh -c qemu+tls://Test/system console HostedEngine
        If you need to reboot the VM you will need to start it manually using the command:
        hosted-engine --vm-start
        You can then set a temporary password using the command:
        hosted-engine --add-console-password
        Please install and setup the engine in the VM.
        You may also be interested in subscribing to &quot;agent&quot; RHN/Satellite channel and installing rhevm-guest-agent-common package in the VM.
        To continue make a selection from the options below:
                  (1) Continue setup - engine installation is complete
                  (2) Power off and restart the VM
                  (3) Abort setup

10. **Installing oVirt**
    Connect to HostedEngine-VM, subscribe to the appropriate oVirt channels, ensure that the most up-to-date versions of all installed packages are in use, and install the rhevm packages.

        # yum upgrade

        # yum install rhevm

11. **Configuring oVirt**
    Configure the engine on HostedEngine-VM:

        # engine-setup

12. **Synchronizing the Host and oVirt**
    Return to Host-HE1 and continue the `hosted-engine` deployment script by selecting option 1:

        (1) Continue setup - engine installation is complete

        [ INFO  ] Engine replied: DB Up!Welcome to Health Status!
        [ INFO  ] Waiting for the host to become operational in the engine. This may take several minutes...
        [ INFO  ] Still waiting for VDSM host to become operational...
        [ INFO  ] The VDSM Host is now operational
                  Please shutdown the VM allowing the system to launch it as a monitored service.
                  The system will wait until the VM is down.

13. **Shutting Down HostedEngine-VM**
    Shutdown HostedEngine-VM.

        # shutdown now

14. **Setup Confirmation**
    Return to Host-HE1 to confirm it has detected that HostedEngine-VM is down.

        [ INFO  ] Enabling and starting HA services
                  Hosted Engine successfully set up
        [ INFO  ] Stage: Clean up
        [ INFO  ] Stage: Pre-termination
        [ INFO  ] Stage: Termination

**Result**

When the `hosted-engine` deployment script completes successfully, oVirt is configured and running on your server. In contrast to a bare-metal Manager installation, the hosted engine Manager has already configured the data center, cluster, host (Host-HE1), storage domain, and virtual machine of the hosted engine (HostedEngine-VM). You can log in as the **admin@internal** user to continue configuring oVirt and add further resources.

Link your oVirt to a directory server so you can add additional users to the environment. oVirt supports directory services from Red Hat Directory Services (RHDS), IdM, and Active Directory. Add a directory server to your environment using the `engine-manage-domains` command.

The `ovirt-host-engine-setup` script also saves the answers you gave during configuration to a file, to help with disaster recovery. If a destination is not specified using the `--generate-answer=&lt;file&gt;` argument, the answer file is generated at `/etc/ovirt-hosted-engine/answers.conf`.

### Migrating to a Self-Hosted Environment

**Summary**

Deploy a hosted-engine environment and migrate an existing instance of oVirt. The `hosted-engine` deployment script is provided to assist with this task. The script asks you a series of questions, and configures your environment based on your answers. When the required values have been provided, the updated configuration is applied and oVirt services are started.

The `hosted-engine` deployment script guides you through several distinct configuration stages. The script suggests possible configuration defaults in square brackets. Where these default values are acceptable, no additional input is required.

This procedure requires a new Red Hat Enterprise Linux 6.5 host with the ovirt-hosted-engine-setup package installed. This host is referred to as 'Host-HE1', with a fully qualified domain name (FQDN) of `Host-HE1.example.com` in this procedure.

Your original oVirt is referred to as 'BareMetal-Manager', with an FQDN of `Manager.example.com`, in this procedure. You are required to access and make changes on BareMetal-Manager during this procedure.

The hosted engine, the virtual machine created during configuration of Host-HE1 and used to manage the environment, is referred to as 'HostedEngine-VM' in this procedure. The `hosted-engine` deployment script prompts you to access this virtual machine multiple times to install an operating system and to configure the engine.

All steps in this procedure are to be conducted as the `root` user for the specified machine.

<div class="alert alert-info">
**Important:** The engine running on BareMetal-Manager must be the same version as will be installed on HostedEngine-VM. As the hosted engine feature is only available on oVirt version 3.3.0 and later, any previous version of oVirt running on BareMetal-Manager must be upgraded. Upgrade the engine version on BareMetal-Manager before creating the backup with the `engine-backup` command.

</div>
⁠

**Procedure 2.2. Migrating to a Self-Hosted Environment**

1.  **Initiating Hosted Engine Deployment**
    Begin configuration of the self-hosted environment by deploying the `hosted-engine` customization script on Host_HE1. To escape the script at any time, use the **CTRL**+**D** keyboard combination to abort deployment.

        # hosted-engine --deploy

2.  **Configuring Storage**
    Select the version of NFS and specify the full address, using either the FQDN or IP address, and path name of the shared storage domain. Choose the storage domain and storage data center names to be used in the environment.

        During customization use CTRL-D to abort.
        Please specify the storage you would like to use (nfs3, nfs4)[nfs3]: 
        Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine/nfs
        [ INFO  ] Installing on first host
        Please provide storage domain name. [hosted_storage]: 
        Local storage datacenter name is an internal name and currently will not be shown in engine's admin UI.Please enter local datacenter name [hosted_datacenter]: 

3.  **Configuring the Network**
    The script detects possible network interface controllers (NICs) to use as a management bridge for the environment. It then checks your firewall configuration and offers to modify it for console (SPICE or VNC) access HostedEngine-VM. Provide a pingable gateway IP address, to be used by the `ovirt-ha-agent` to help determine a host's suitability for running HostedEngine-VM.

        Please indicate a nic to set rhevm bridge on: (eth1, eth0) [eth1]:
        iptables was detected on your computer, do you wish setup to configure it? (Yes, No)[Yes]: 
        Please indicate a pingable gateway IP address [X.X.X.X]: 

4.  **Configuring the Virtual Machine**
    The script creates a virtual machine to be configured as oVirt, the hosted engine referred to in this procedure as HostedEngine-VM. Specify the boot device and, if applicable, the path name of the installation media, the CPU type, the number of virtual CPUs, and the disk size. Specify a MAC address for the HostedEngine-VM, or accept a randomly generated one. The MAC address can be used to update your DHCP server prior to installing the operating system on the virtual machine. Specify memory size and console connection type for the creation of HostedEngine-VM.

        Please specify the device to boot the VM from (cdrom, disk, pxe) [cdrom]: 
        The following CPU types are supported by this host:
                  - model_Penryn: Intel Penryn Family
                  - model_Conroe: Intel Conroe Family
        Please specify the CPU type to be used by the VM [model_Penryn]: 
        Please specify the number of virtual CPUs for the VM [Defaults to minimum requirement: 2]: 
        Please specify the disk size of the VM in GB [Defaults to minimum requirement: 25]: 
        You may specify a MAC address for the VM or accept a randomly generated default [00:16:3e:77:b2:a4]: 
        Please specify the memory size of the VM in MB [Defaults to minimum requirement: 4096]: 
        Please specify the console type you want to use to connect to the VM (vnc, spice) [vnc]: 

5.  **Configuring the Hosted Engine**
    Specify the name for Host-HE1 to be identified in the oVirt environment, and the password for the `admin@internal` user to access the Administrator Portal. Provide the FQDN for HostedEngine-VM; this procedure uses the FQDN *Manager.example.com*. Finally, provide the name and TCP port number of the SMTP server, the email address used to send email notifications, and a comma-separated list of email addresses to receive these notifications.

    **Important**

    The FQDN provided for the engine (*Manager.example.com*) must be the same FQDN provided when BareMetal-Manager was initially set up.

        Enter the name which will be used to identify this host inside the Administrator Portal [hosted_engine_1]: Host-HE1
        Enter 'admin@internal' user password that will be used for accessing the Administrator Portal: 
        Confirm 'admin@internal' user password: 
        Please provide the FQDN for the engine you want to use. This needs to match the FQDN that you will use for the engine installation within the VM: Manager.example.com
        Please provide the name of the SMTP server through which we will send notifications [localhost]: 
        Please provide the TCP port number of the SMTP server [25]: 
        Please provide the email address from which notifications will be sent [root@localhost]: 
        Please provide a comma-separated list of email addresses which will get notifications [root@localhost]: 

6.  **Configuration Preview**
    Before proceeding, the `hosted-engine` script displays the configuration values you have entered, and prompts for confirmation to proceed with these values.

        Bridge interface                   : eth1
        Engine FQDN                        : Manager.example.com
        Bridge name                        : rhevm
        SSH daemon port                    : 22
        Firewall manager                   : iptables
        Gateway address                    : X.X.X.X
        Host name for web application      : Host-HE1
        Host ID                            : 1
        Image size GB                      : 25
        Storage connection                 : storage.example.com:/hosted_engine/nfs
        Console type                       : vnc
        Memory size MB                     : 4096
        MAC address                        : 00:16:3e:77:b2:a4
        Boot type                          : pxe
        Number of CPUs                     : 2
        CPU Type                           : model_Penryn

        Please confirm installation settings (Yes, No)[No]: 

7.  **Creating HostedEngine-VM**
    The script creates the virtual machine to be configured as HostedEngine-VM and provides connection details. You must install an operating system on HostedEngine-VM before the `hosted-engine` script can proceed on Host-HE1.

        [ INFO  ] Generating answer file '/etc/ovirt-hosted-engine/answers.conf'
        [ INFO  ] Stage: Transaction setup
        [ INFO  ] Stage: Misc configuration
        [ INFO  ] Stage: Package installation
        [ INFO  ] Stage: Misc configuration
        [ INFO  ] Configuring libvirt
        [ INFO  ] Generating VDSM certificates
        [ INFO  ] Configuring VDSM
        [ INFO  ] Starting vdsmd
        [ INFO  ] Waiting for VDSM hardware info
        [ INFO  ] Creating Storage Domain
        [ INFO  ] Creating Storage Pool
        [ INFO  ] Connecting Storage Pool
        [ INFO  ] Verifying sanlock lockspace initialization
        [ INFO  ] Initializing sanlock lockspace
        [ INFO  ] Initializing sanlock metadata
        [ INFO  ] Creating VM Image
        [ INFO  ] Disconnecting Storage Pool
        [ INFO  ] Start monitoring domain
        [ INFO  ] Configuring VM
        [ INFO  ] Updating hosted-engine configuration
        [ INFO  ] Stage: Transaction commit
        [ INFO  ] Stage: Closing up
        [ INFO  ] Creating VM
        You can now connect to the VM with the following command:
            /usr/bin/remote-viewer vnc://localhost:5900
        Use temporary password &quot;5379skAb&quot; to connect to vnc console.
        Please note that in order to use remote-viewer you need to be able to run graphical applications.
        This means that if you are using ssh you have to supply the -Y flag (enables trusted X11 forwarding).
        Otherwise you can run the command from a terminal in your preferred desktop environment.
        If you cannot run graphical applications you can connect to the graphic console from another host or connect to the console using the following command:
        virsh -c qemu+tls://Test/system console HostedEngine
        If you need to reboot the VM you will need to start it manually using the command:
        hosted-engine --vm-start
        You can then set a temporary password using the command:
        hosted-engine --add-console-password
        The VM has been started.  Install the OS and shut down or reboot it.  To continue please make a selection:

                  (1) Continue setup - VM installation is complete
                  (2) Reboot the VM and restart installation
                  (3) Abort setup

                  (1, 2, 3)[1]:

    Using the naming convention of this procedure, connect to the virtual machine using VNC with the following command:

        /usr/bin/remote-viewer vnc://Host-HE1.example.com:5900

8.  **Installing the Virtual Machine Operating System**
    Connect to HostedEngine-VM, the virtual machine created by the hosted-engine script, and install a Red Hat Enterprise Linux 6.5 operating system.

9.  **Synchronizing the Host and the Virtual Machine**
    Return to Host-HE1 and continue the `hosted-engine` deployment script by selecting option 1:

        (1) Continue setup - VM installation is complete

         Waiting for VM to shut down...
        [ INFO  ] Creating VM
        You can now connect to the VM with the following command:
            /usr/bin/remote-viewer vnc://localhost:5900
        Use temporary password &quot;5379skAb&quot; to connect to vnc console.
        Please note that in order to use remote-viewer you need to be able to run graphical applications.
        This means that if you are using ssh you have to supply the -Y flag (enables trusted X11 forwarding).
        Otherwise you can run the command from a terminal in your preferred desktop environment.
        If you cannot run graphical applications you can connect to the graphic console from another host or connect to the console using the following command:
        virsh -c qemu+tls://Test/system console HostedEngine
        If you need to reboot the VM you will need to start it manually using the command:
        hosted-engine --vm-start
        You can then set a temporary password using the command:
        hosted-engine --add-console-password
        Please install and setup the engine in the VM.
        You may also be interested in subscribing to &quot;agent&quot; RHN/Satellite channel and installing rhevm-guest-agent-common package in the VM.
        To continue make a selection from the options below:
                  (1) Continue setup - engine installation is complete
                  (2) Power off and restart the VM
                  (3) Abort setup

10. **Installing oVirt**
    Connect to HostedEngine-VM, subscribe to the appropriate oVirt channels, ensure that the most up-to-date versions of all installed packages are in use, and install the rhevm packages.

        # yum upgrade

        # yum install rhevm

11. **Disabling BareMetal-Manager**
    Connect to BareMetal-Manager, the Manager of your established oVirt environment, and stop the engine and prevent it from running.

        # service ovirt-engine stop
        # service ovirt-engine disable
        # chkconfig ovirt-engine off

    **Note**

    Though stopping BareMetal-Manager from running is not obligatory, it is recommended as it ensures no changes will be made to the environment after the backup has been created. Additionally, it prevents BareMetal-Manager and HostedEngine-VM from simultaneously managing existing resources.

12. **Updating DNS**
    Update your DNS so that the FQDN of the oVirt environment correlates to the IP address of HostedEngine-VM and the FQDN previously provided when configuring the `hosted-engine` deployment script on Host-HE1. In this procedure, FQDN was set as *Manager.example.com* because in a migrated hosted-engine setup, the FQDN provided for the engine must be identical to that given in the engine setup of the original engine.

13. **Creating a Backup of BareMetal-Manager**
    Connect to BareMetal-Manager and run the `engine-backup` command with the *`--mode=backup`*, *`--file=[FILE]`*, and *`--log=[LogFILE]`* parameters to specify the backup mode, the name of the backup file created and used for the backup, and the name of the log file to be created to store the backup log.

        # engine-backup --mode=backup --file=[FILE] --log=[LogFILE]

14. **Copying the Backup File to HostedEngine-VM**
    On BareMetal-Manager, secure copy the backup file to HostedEngine-VM. In the following example, *[Manager.example.com]* is the FQDN for HostedEngine-VM, and */backup/* is any designated folder or path. If the designated folder or path does not exist, you must connect to HostedEngine-VM and create it before secure copying the backup from BareMetal-Manager.

        # scp -p backup1 [Manager.example.com:/backup/]

15. **Restoring the Backup File on HostedEngine-VM**
    The `engine-backup --mode=restore` command does not create a database; you are required to create one on HostedEngine-VM before restoring the backup you created on BareMetal-Manager. Connect to HostedEngine-VM and create the database, as detailed in [Section 1.3.4, “Preparing a PostgreSQL Database for Use with oVirt”](#Preparing_a_Postgres_Database_Server_for_use_with_Red_Hat_Enterprise_Virtualization_Manager).

    **Note**

    The procedure in [Section 1.3.4, “Preparing a PostgreSQL Database for Use with oVirt”](#Preparing_a_Postgres_Database_Server_for_use_with_Red_Hat_Enterprise_Virtualization_Manager) creates a database that is not empty, which will result in the following error when you attempt to restore the backup:

        FATAL: Database is not empty

    Create an empty database using the following command in psql:

        postgres=# create database [database name] owner [user name]

    After the empty database has been created, restore the BareMetal-Manager backup using the `engine-backup` command with the *`--mode=restore`* *`--file=[FILE]`* *`--log=[Restore.log]`* parameters to specify the restore mode, the name of the file to be used to restore the database, and the name of the logfile to store the restore log. This restores the files and the database but does not start the service.

    To specify a different database configuration, use the *`--change-db-credentials`* parameter to activate alternate credentials. Use the `engine-backup --help` command on oVirt for a list of credential parameters.

        # engine-backup --mode=restore --file=[FILE] --log=[Restore.log] --change-db-credentials --db-host=[X.X.X.X] --db-user=[engine] --db-password=[password] --db-name=[engine]

16. **Configuring HostedEngine-VM**
    Configure the engine on HostedEngine-VM. This identifies the existing files and database.

        # engine-setup

        [ INFO  ] Stage: Initializing
        [ INFO  ] Stage: Environment setup
        Configuration files: ['/etc/ovirt-engine-setup.conf.d/10-packaging.conf', '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf']
        Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20140304075238.log
        Version: otopi-1.1.2 (otopi-1.1.2-1.el6ev)
        [ INFO  ] Stage: Environment packages setup
        [ INFO  ] Yum Downloading: rhel-65-zstream/primary_db 2.8 M(70%)
        [ INFO  ] Stage: Programs detection
        [ INFO  ] Stage: Environment setup
        [ INFO  ] Stage: Environment customization

                  --== PACKAGES ==--

        [ INFO  ] Checking for product updates...
        [ INFO  ] No product updates found

                  --== NETWORK CONFIGURATION ==--

        Setup can automatically configure the firewall on this system.
        Note: automatic configuration of the firewall may overwrite current settings.
        Do you want Setup to configure the firewall? (Yes, No) [Yes]: 
        [ INFO  ] iptables will be configured as firewall manager.

                  --== DATABASE CONFIGURATION ==--

                  --== OVIRT ENGINE CONFIGURATION ==--

                  Skipping storing options as database already prepared

                  --== PKI CONFIGURATION ==--

                  PKI is already configured

                  --== APACHE CONFIGURATION ==--

                  --== SYSTEM CONFIGURATION ==--

                  --== END OF CONFIGURATION ==--

        [ INFO  ] Stage: Setup validation
        [WARNING] Less than 16384MB of memory is available
        [ INFO  ] Cleaning stale zombie tasks

                  --== CONFIGURATION PREVIEW ==--

                  Database name                      : engine
                  Database secured connection        : False
                  Database host                      : X.X.X.X
                  Database user name                 : engine
                  Database host name validation      : False
                  Database port                      : 5432
                  NFS setup                          : True
                  Firewall manager                   : iptables
                  Update Firewall                    : True
                  Configure WebSocket Proxy          : True
                  Host FQDN                          : Manager.example.com
                  NFS mount point                    : /var/lib/exports/iso
                  Set application as default page    : True
                  Configure Apache SSL               : True

                  Please confirm installation settings (OK, Cancel) [OK]: 

    Confirm the settings. Upon completion, the setup provides an SSH fingerprint and an internal Certificate Authority hash.

17. **Synchronizing the Host and oVirt**
    Return to Host-HE1 and continue the `hosted-engine` deployment script by selecting option 1:

        (1) Continue setup - engine installation is complete

        [ INFO  ] Engine replied: DB Up!Welcome to Health Status!
        [ INFO  ] Waiting for the host to become operational in the engine. This may take several minutes...
        [ INFO  ] Still waiting for VDSM host to become operational...
        [ INFO  ] The VDSM Host is now operational
                  Please shutdown the VM allowing the system to launch it as a monitored service.
                  The system will wait until the VM is down.

18. **Shutting Down HostedEngine-VM**
    Shutdown HostedEngine-VM.

        # shutdown now

19. **Setup Confirmation**
    Return to Host-HE1 to confirm it has detected that HostedEngine-VM is down.

        [ INFO  ] Enabling and starting HA services
                  Hosted Engine successfully set up
        [ INFO  ] Stage: Clean up
        [ INFO  ] Stage: Pre-termination
        [ INFO  ] Stage: Termination

**Result**

Your oVirt engine has been migrated to a hosted-engine setup. oVirt is now operating on a virtual machine on Host-HE1, called HostedEngine-VM in the environment. As HostedEngine-VM is highly available, it is migrated to other hosts in the environment when applicable.

### Installing Additional Hosts to a Self-Hosted Environment

**Summary**

Adding additional nodes to a self-hosted environment is very similar to deploying the original host, though heavily truncated as the script detects the environment.

As with the original host, additional hosts require Red Hat Enterprise Linux 6.5 with subscriptions to the appropriate oVirt channels.

All steps in this procedure are to be conducted as the `root` user.

⁠

**Procedure 2.3. Adding the host**

1.  Install the ovirt-hosted-engine-setup package.
        # yum install ovirt-hosted-engine-setup

2.  Configure the host with the deployment command.
        # hosted-engine --deploy

3.  **Configuring Storage**
    Specify the storage type and the full address, using either the Fully Qualified Domain Name (FQDN) or IP address, and path name of the shared storage domain used in the self-hosted environment.

        Please specify the storage you would like to use (nfs3, nfs4)[nfs3]:
        Please specify the full shared storage connection path to use (example: host:/path): storage.example.com:/hosted_engine/nfs

4.  **Detecting the Self-Hosted Engine**
    The `hosted-engine` script detects that the shared storage is being used and asks if this is an additional host setup. You are then prompted for the host ID, which must be an integer not already assigned to an additional host in the environment.

        The specified storage location already contains a data domain. Is this an additional host setup (Yes, No)[Yes]? 
        [ INFO  ] Installing on additional host
        Please specify the Host ID [Must be integer, default: 2]: 

5.  **Configuring the System**
    The `hosted-engine` script uses the answer file generated by the original hosted-engine setup. To achieve this, the script requires the FQDN or IP address and the password of the `root` user of that host so as to access and secure-copy the answer file to the additional host.

        [WARNING] A configuration file must be supplied to deploy Hosted Engine on an additional host.
        The answer file may be fetched from the first host using scp.
        If you do not want to download it automatically you can abort the setup answering no to the following question.
        Do you want to scp the answer file from the first host? (Yes, No)[Yes]:       
        Please provide the FQDN or IP of the first host:           
        Enter 'root' user password for host Host-HE1.example.com: 
        [ INFO  ] Answer file successfully downloaded

6.  **Configuring the Hosted Engine**
    Specify the name for the additional host to be identified in the oVirt environment, and the password for the `admin@internal` user.

        Enter the name which will be used to identify this host inside the Administrator Portal [hosted_engine_2]:           
        Enter 'admin@internal' user password that will be used for accessing the Administrator Portal: 
        Confirm 'admin@internal' user password: 

7.  **Configuration Preview**
    Before proceeding, the `hosted-engine` script displays the configuration values you have entered, and prompts for confirmation to proceed with these values.

        Bridge interface                   : eth1
        Engine FQDN                        : HostedEngine-VM.example.com
        Bridge name                        : rhevm
        SSH daemon port                    : 22
        Firewall manager                   : iptables
        Gateway address                    : X.X.X.X
        Host name for web application      : hosted_engine_2
        Host ID                            : 2
        Image size GB                      : 25
        Storage connection                 : storage.example.com:/hosted_engine/nfs
        Console type                       : vnc
        Memory size MB                     : 4096
        MAC address                        : 00:16:3e:05:95:50
        Boot type                          : disk
        Number of CPUs                     : 2
        CPU Type                           : model_Penryn

        Please confirm installation settings (Yes, No)[No]: 

**Result**

After confirmation, the script completes installation of the host and adds it to the environment.

### Maintaining the Self-Hosted Engine

Setting the engine to global maintenance enables you to start, stop, and modify the engine without interference from the high-availability agents. This must be applied to the engine for any setup or upgrade operations that require the engine to be stopped, for instance the installation of the rhevm-dwh and rhevm-reports packages necessary for the **Reports Portal**.

    # hosted-engine --set-maintenance --mode=global

To resume the high-availability function of the engine, turn off global maintenance:

    # hosted-engine --set-maintenance --mode=none

Both of these commands are to be conducted as the `root` user.

### Upgrading the Self-Hosted Engine

**Error**

Topic 30615 failed Injection processing and is not included in this build.

Please review the compiler error for [Topic ID 30615](#TagErrorXRef30615) for more detailed information.

### Upgrading Additional Hosts in a Self-Hosted Environment

**Summary**

It is recommended that all hosts in your self-hosted environment are upgraded at the same time. This prevents version 3.3 hosts from going into a **Non Operational** state. If this is not practical in your environment, follow this procedure to upgrade any additional hosts.

Ensure the host is not hosting oVirt virtual machine before beginning the procedure.

All commands in this procedure are as the `root` user.

⁠

**Procedure 2.4. Upgrading Additional Hosts**

1.  Log into the host and set the maintenance mode to `local`.
        # hosted-engine --set-maintenance --mode=local

2.  Access oVirt Administration Portal. Select the host and put it into maintenance mode by clicking the **Maintenance** button.
3.  Log into and update the host.
        # yum update

4.  Restart VDSM on the host.
        # service vdsmd restart

5.  Restart `ovirt-ha-broker` and `ovirt-ha-agent` on the host.
        # service ovirt-ha-broker restart

        # service ovirt-ha-agent restart

6.  Turn off the hosted-engine maintenance mode on the host.
        # hosted-engine --set-maintenance --mode=none

7.  Access oVirt Administration Portal. Select the host and activate it by clicking the **Activate** button.

**Result**

You have updated an additional host in your self-hosted environment to oVirt 3.4.

## ⁠Chapter 3. History and Reports

### Workflow Progress - Data Collection Setup and Reports Installation

![](images/1192.png "images/1192.png")

### Data Collection Setup and Reports Installation Overview

oVirt optionally includes a comprehensive management history database, which can be utilized by any application to extract a range of information at the data center, cluster, and host levels. As the database structure changes over time a number of database views are also included to provide a consistent structure to consuming applications. A view is a virtual table composed of the result set of a database query. The definition of a view is stored in the database as a `SELECT` statement. The result set of the `SELECT` statement populates the virtual table returned by the view. If the optional comprehensive management history database has been enabled, the history tables and their associated views are stored in the `ovirt_engine_history` database.

In addition to the history database oVirt Reports functionality is also available as an optional component. oVirt Reports provides a customized implementation of JasperServer and JasperReports. JasperServer is a component of JasperReports, an open source reporting tool capable of being embedded in Java-based applications. It produces reports which can be rendered to screen, printed, or exported to a variety of formats including PDF, Excel, CSV, Word, RTF, Flash, ODT and ODS. Reports built in oVirt Reports are accessed via a web interface. In addition to a range of pre-configured reports and dashboards for monitoring the system, you are also able to create your own ad hoc reports.

Before proceeding with Red Hat Virtualization Manager Reports installation you must first have installed oVirt.

oVirt Reports functionality depends on the presence of the history database, which is installed separately. Both the history database and oVirt Reports are optional components. They are not installed by default when you install oVirt.

<div class="alert alert-info">
**Note:** Detailed user, administration, and installation guides for JasperReports can be found in `/usr/share/jasperreports-server-pro/docs/`

</div>
### Installing and Configuring the History Database and oVirt Reports

**Summary**

Use of the history database and reports is optional. To use the reporting capabilities of oVirt, you must install and configure rhevm-dwh and rhevm-reports.

⁠

**Procedure 3.1. Installing and Configuring the History Database and oVirt Reports**

1.  Install the rhevm-dwh package. This package must be installed on the system on which oVirt is installed.
        # yum install rhevm-dwh

2.  Install the rhevm-reports package. This package must be installed on the system on which oVirt is installed.
        # yum install rhevm-reports

3.  Run the `engine-setup` command on the system hosting oVirt and follow the prompts to install Data Warehouse and Reports:
        --== PRODUCT OPTIONS ==--

        Install Data Warehouse on this host (Yes, No) [Yes]: 
        Install Reports on this host (Yes, No) [Yes]:

4.  The command will prompt you to answer the following questions about the DWH database:
        --== DATABASE CONFIGURATION ==--

        Where is the DWH database located? (Local, Remote) [Local]: 
        Setup can configure the local postgresql server automatically for the DWH to run. This may conflict with existing applications.
        Would you like Setup to automatically configure postgresql and create DWH database, or prefer to perform that manually? (Automatic, Manual) [Automatic]: 
        Where is the Reports database located? (Local, Remote) [Local]: 
        Setup can configure the local postgresql server automatically for the Reports to run. This may conflict with existing applications.
        Would you like Setup to automatically configure postgresql and create Reports database, or prefer to perform that manually? (Automatic, Manual) [Automatic]:

    Press **Enter** to choose the highlighted defaults, or type your alternative preference and then press **Enter**.

5.  The command will then prompt you to set the password for oVirt Reports administrative users (`admin` and `superuser`). Note that the reports system maintains its own set of credentials which are separate to those used for oVirt.
        Reports power users password:

    You will be prompted to enter the password a second time to confirm it.

6.  For oVirt Reports installation to take effect, the `ovirt-engine` service must be restarted. The `engine-setup` command prompts you:
        During execution engine service will be stopped (OK, Cancel) [OK]:

    Type **OK** and then press **Enter** to proceed. The `ovirt-engine` service will restart automatically later in the command.

**Result**

The `ovirt_engine_history` database has been created. oVirt is configured to log information to this database for reporting purposes. oVirt Reports has been installed successfully. Access oVirt Reports at `http://[demo.redhat.com]/ovirt-engine-reports`, replacing `[demo.redhat.com]` with the fully-qualified domain name of oVirt. If during oVirt installation you selected a non-default HTTP port then append `:`*[port]* to the URL, replacing *[port]* with the port that you chose.

Use the user name `admin` and the password you set during reports installation to log in for the first time. Note that the first time you log into oVirt Reports, a number of web pages are generated, and as a result your initial attempt to login may take some time to complete.

<div class="alert alert-info">
**Note:** Previously, the `admin` user name was `rhevm-admin`. If you are performing a clean installation, the user name is now `admin`. In you are performing an upgrade, the user name will remain `rhevm-admin`.

</div>
## ⁠Chapter 4. Introduction to Hosts

### Workflow Progress - Installing Virtualization Hosts

![](images/1193.png "images/1193.png")

### Introduction to Virtualization Hosts

oVirt supports both virtualization hosts which run the oVirt Node, and those which run Red Hat Enterprise Linux. Both types of virtualization host are able to coexist in the same oVirt environment.

Prior to installing virtualization hosts you should ensure that:

*   all virtualization hosts meet the hardware requirements, and
*   you have successfully completed installation of oVirt.

Additionally you may have chosen to install oVirt Reports. This is not mandatory and is not required to commence installing virtualization hosts. Once you have completed the above tasks you are ready to install virtualization hosts.

<div class="alert alert-info">
**Important:** It is recommended that you install at least two virtualization hosts and attach them to the oVirt environment. Where you attach only one virtualization host you will be unable to access features such as migration which require redundant hosts.

</div>
<div class="alert alert-info">
**Important:** oVirt Node is a closed system. Use a Red Hat Enterprise Linux host if additional rpms are required for your environment.

</div>
## ⁠Chapter 5. oVirt Node Hosts

### oVirt Node Installation Overview

Before commencing Hypervisor installation you must be aware that:

*   oVirt Node *must* be installed on a physical server. It must not be installed in a Virtual Machine.
*   The installation process will reconfigure the selected storage device and destroy all data. Therefore, ensure that any data to be retained is successfully backed up before proceeding.
*   All Hypervisors in an environment must have unique hostnames and IP addresses, in order to avoid network conflicts.
*   Instructions for using Network (PXE) Boot to install the Hypervisor are contained in the *Red Hat Enterprise Linux - Hypervisor Deployment Guide*, available at [<https://access.redhat.com/site/documentation/en-US/>](https://access.redhat.com/site/documentation/en-US/).
*   oVirt Nodes can use Storage Attached Networks (SANs) and other network storage for storing virtualized guest images. However, a local storage device is required for installing and booting the Hypervisor.

<div class="alert alert-info">
**Note:** oVirt Node installations can be automated or conducted without interaction. This type of installation is only recommended for advanced users. See the *Red Hat Enterprise Virtualization - Installation Guide* for more information.

</div>
### Installing oVirt Node Disk Image

**Summary**

Before you can set up a oVirt Node, you must download the packages containing oVirt Node disk image and tools for writing that disk image to USB storage devices or preparing that disk image for deployment via PXE.

⁠

**Procedure 5.1. Installing oVirt Node Disk Image**

1.  Enable the `oVirt Node (v.6 x86_64)` repository:
    -   With RHN Classic:
            # rhn-channel --add --channel=rhel-x86_64-server-6-rhevh

    -   With Subscription Manager, attach a `Red Hat Enterprise Virtualization` entitlement and run the following command:
            # subscription-manager repos --enable=rhel-6-server-rhevh-rpms

2.  Run the following command to install the rhev-hypervisor6 package:
        # yum install rhev-hypervisor6

3.  Run the following command to install the livecd-tools package:
        # yum install livecd-tools

**Result**

You have installed oVirt Node disk image and the **livecd-iso-to-disk** and **livecd-iso-to-pxeboot** utilities. By default, oVirt Node disk image is located in the `/usr/share/rhev-hypervisor/` directory.

<div class="alert alert-info">
**Note:** Red Hat Enterprise Linux 6.2 and later allows more than one version of the ISO image to be installed at one time. As such, `/usr/share/rhev-hypervisor/rhev-hypervisor.iso` is now a symbolic link to a uniquely-named version of the Hypervisor ISO image, such as `/usr/share/rhev-hypervisor/rhev-hypervisor-6.4-20130321.0.el6ev.iso`. Different versions of the image can now be installed alongside each other, allowing administrators to run and maintain a cluster on a previous version of the Hypervisor while upgrading another cluster for testing. Additionally, the symbolic link `/usr/share/rhev-hypervisor/rhevh-latest-6.iso`, is created. This links also targets the most recently installed version of the oVirt ISO image.

</div>
### Preparing Installation Media

####  Preparing a USB Storage Device

You can write oVirt Node disk image to a USB storage device such as a flash drive or external hard drive. You can then use that USB device to start the machine on which oVirt Node will be installed and install oVirt Node operating system.

<div class="alert alert-info">
**Note:** Not all systems support booting from a USB storage device. Ensure the BIOS on the system on which you will install oVirt Node supports this feature.

</div>
####  Preparing USB Installation Media Using livecd-iso-to-disk

**Summary**

You can use the **livecd-iso-to-disk** utility included in the livecd-tools package to write a hypervisor or other disk image to a USB storage device. You can then use that USB storage device to start systems that support booting via USB and install the oVirt Node.

The basic syntax for the **livecd-iso-to-disk** utility is as follows:

    # livecd-iso-to-disk [image] [device]

The *[device]* parameter is the path to the USB storage device on which to write the disk image. The *[image]* parameter is the path and file name of the disk image to write to the USB storage device. By default, oVirt Node disk image is located at `/usr/share/rhev-hypervisor/rhev-hypervisor.iso` on the machine on which oVirt is installed. The **livecd-iso-to-disk** utility requires devices to be formatted with the `FAT` or `EXT3` file system.

<div class="alert alert-info">
**Note:** USB storage devices are sometimes formatted without a partition table. In this case, use a generic identifier for the storage device such as `/dev/sdb`. When a USB storage device is formatted with a partition table, use the path name to the device, such as `/dev/sdb1`.

</div>
⁠

**Procedure 5.2. Preparing USB Installation Media Using livecd-iso-to-disk**

1.  Run the following command to ensure you have the latest version of oVirt Node disk image:
        # yum update rhev-hypervisor6

2.  Use the **livecd-iso-to-disk** utility to write the disk image to a USB storage device.
    ⁠

    **Example 5.1. Use of livecd-iso-to-disk**

    This example demonstrates the use of **livecd-iso-to-disk** to write a oVirt Node disk image to a USB storage device named `/dev/sdc` and make that USB storage device bootable.

        # livecd-iso-to-disk --format --reset-mbr /usr/share/rhev-hypervisor/rhev-hypervisor.iso /dev/sdc
        Verifying image...
        /usr/share/rhev-hypervisor/rhev-hypervisor.iso:   eccc12a0530b9f22e5ba62b848922309
        Fragment sums: 8688f5473e9c176a73f7a37499358557e6c397c9ce2dafb5eca5498fb586
        Fragment count: 20
        Press [Esc] to abort check.
        Checking: 100.0%

        The media check is complete, the result is: PASS.

        It is OK to use this media.

        WARNING: THIS WILL DESTROY ANY DATA ON /dev/sdc!!!
        Press Enter to continue or ctrl-c to abort

        /dev/sdc: 2 bytes were erased at offset 0x000001fe (dos): 55 aa
        Waiting for devices to settle...
        mke2fs 1.42.7 (21-Jan-2013)
        Filesystem label=LIVE
        OS type: Linux
        Block size=4096 (log=2)
        Fragment size=4096 (log=2)
        Stride=0 blocks, Stripe width=0 blocks
        488640 inodes, 1953280 blocks
        97664 blocks (5.00%) reserved for the super user
        First data block=0
        Maximum filesystem blocks=2000683008
        60 block groups
        32768 blocks per group, 32768 fragments per group
        8144 inodes per group
        Superblock backups stored on blocks: 
                32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

        Allocating group tables: done                            
        Writing inode tables: done                            
        Creating journal (32768 blocks): done
        Writing superblocks and filesystem accounting information: done 

        Copying live image to target device.
        squashfs.img
           163360768 100%  184.33MB/s    0:00:00 (xfer#1, to-check=0/1)

        sent 163380785 bytes  received 31 bytes  108920544.00 bytes/sec
        total size is 163360768  speedup is 1.00
        osmin.img
                4096 100%    0.00kB/s    0:00:00 (xfer#1, to-check=0/1)

        sent 4169 bytes  received 31 bytes  8400.00 bytes/sec
        total size is 4096  speedup is 0.98
        Updating boot config file
        Installing boot loader
        /media/tgttmp.q6aZdS/syslinux is device /dev/sdc
        Target device is now set up with a Live image!

**Result**

You have written a oVirt Node disk image to a USB storage device. You can now use that USB storage device to start a system and install oVirt Node operating system.

####  Preparing USB Installation Media Using dd

The **dd** utility can also be used to write a oVirt Node disk image to a USB storage device. The **dd** utility is available from the coreutils package, and versions of the **dd** utility are available on a wide variety of Linux and Unix operating systems. Windows users can obtain the **dd** utility by installing Red Hat Cygwin, a free Linux-like environment for Windows.

The basic syntax for the **dd** utility is as follows:

    # dd if=[image] of=[device]

The *[device]* parameter is the path to the USB storage device on which the disk image will be written. The *[image]* parameter is the path and file name of the disk image to write to the USB storage device. By default, oVirt Node disk image is located at `/usr/share/rhev-hypervisor/rhev-hypervisor.iso` on the machine on which the rhev-hypervisor6 package is installed. The **dd** command does not make assumptions as to the format of the device because it performs a low-level copy of the raw data in the selected image.

####  Preparing USB Installation Media Using dd on Linux Systems

**Summary**

You can use the **dd** utility to write a oVirt Node disk image to a USB storage device.

⁠

**Procedure 5.3. Preparing USB Installation Media using dd on Linux Systems**

1.  Run the following command to ensure you have the latest version of oVirt Node disk image:
        # yum update rhev-hypervisor6

2.  Use the **dd** utility to write the disk image to a USB storage device.
    ⁠

    **Example 5.2. Use of dd**

    This example uses a USB storage device named `/dev/sdc`.

        # dd if=/usr/share/rhev-hypervisor/rhev-hypervisor.iso of=/dev/sdc
        243712+0 records in
        243712+0 records out
        124780544 bytes (125 MB) copied, 56.3009 s, 2.2 MB/s

    **Warning**

    The **dd** utility will overwrite all data on the device specified by the *`of`* parameter. Ensure you have specified the correct device and that the device contains no valuable data before using the **dd** utility.

**Result**

You have written a oVirt Node disk image to a USB storage device.

####  Preparing Optical Hypervisor Installation Media

**Summary**

You can write a oVirt Node disk image to a CD-ROM or DVD with the **wodim** utility. The **wodim** utility is provided by the wodim package.

⁠

**Procedure 5.4. Preparing Optical Hypervisor Installation Media**

1.  Run the following command to install the wodim package and dependencies:
        # yum install wodim

2.  Insert a blank CD-ROM or DVD into your CD or DVD writer.
3.  Run the following command to write oVirt Node disk image to the disc:
        wodim dev=[device] [image]

    ⁠

    **Example 5.3. Use of the wodim Utility**

    This example uses the first CD-RW (`/dev/cdrw`) device available and the default hypervisor image location.

        # wodim dev=/dev/cdrw /usr/share/rhev-hypervisor/rhev-hypervisor.iso

<div class="alert alert-info">
**Important:** The Hypervisor uses a program (**isomd5sum**) to verify the integrity of the installation media every time the hypervisor is booted. If media errors are reported in the boot sequence you have a bad CD-ROM. Follow the procedure above to create a new CD-ROM or DVD.

</div>
**Result**

You have written a oVirt Node disk image to a CD-ROM or DVD.

### Installation

####  Booting the Hypervisor from USB Installation Media

**Summary**

Booting a hypervisor from a USB storage device is similar to booting other live USB operating systems. Follow this procedure to boot a machine using USB installation media.

⁠

**Procedure 5.5. Booting the Hypervisor from USB Installation Media**

1.  Enter the BIOS menu to enable USB storage device booting if not already enabled.
    1.  Enable USB booting if this feature is disabled.
    2.  Set booting USB storage devices to be first boot device.
    3.  Shut down the system.

2.  Insert the USB storage device that contains the hypervisor boot image.
3.  Restart the system.

**Result**

The hypervisor boot process commences automatically.

####  Booting the Hypervisor from Optical Installation Media

**Summary**

Booting the Hypervisor from optical installation media requires the system to have a correctly defined BIOS boot configuration.

⁠

**Procedure 5.6. Booting the Hypervisor from Optical Installation Media**

1.  Ensure that the system's BIOS is configured to boot from the CD-ROM or DVD-ROM drive first. For many systems this is the default.
    **Note**

    Refer to your manufacturer's manuals for further information on modifying the system's BIOS boot configuration.

2.  Insert the Hypervisor CD-ROM in the CD-ROM or DVD-ROM drive.
3.  Reboot the system.

**Result**

The Hypervisor boot screen will be displayed.

#### 3. Starting the Installation Program

**Summary**

When you start a system using the prepared boot media, the first screen that displays is the boot menu. From here, you can start the installation program for installing the hypervisor.

⁠

**Procedure 5.7. Starting the Installation Program**

1.  From the boot splash screen, press any key to open the boot menu.
    ⁠

    ![The boot splash screen counts down for 30 seconds before automatically booting the system.](images/5133.png "The boot splash screen counts down for 30 seconds before automatically booting the system.")

    **Figure 5.1. The boot splash screen**

2.  From the boot menu, use the directional keys to select **Install or Upgrade**, **Install (Basic Video)**, or **Install or Upgrade with Serial Console**.
    ⁠

    ![The boot menu screen displays all predefined boot options, as well as providing the option to edit them.](images/5134.png "The boot menu screen displays all predefined boot options, as well as providing the option to edit them.")

    **Figure 5.2. The boot menu**

    The full list of options in the boot menu is as follows:

    <dl>
    <dt>
    **Install or Upgrade**

    </dt>
    <dd>
    Install or upgrade the hypervisor.

    </dd>
    <dt>
    **Install (Basic Video)**

    </dt>
    <dd>
    Install or upgrade the Hypervisor in basic video mode.

    </dd>
    <dt>
    **Install or Upgrade with Serial Console**

    </dt>
    <dd>
    Install or upgrade the hypervisor while redirecting the console to a serial device attached to `/dev/ttyS0`.

    </dd>
    <dt>
    **Reinstall**

    </dt>
    <dd>
    Reinstall the hypervisor.

    </dd>
    <dt>
    **Reinstall (Basic Video)**

    </dt>
    <dd>
    Reinstall the hypervisor in basic video mode.

    </dd>
    <dt>
    **Reinstall with Serial Console**

    </dt>
    <dd>
    Reinstall the hypervisor while redirecting the console to a serial device attached to `/dev/ttyS0`.

    </dd>
    <dt>
    **Uninstall**

    </dt>
    <dd>
    Uninstall the hypervisor.

    </dd>
    <dt>
    **Boot from Local Drive**

    </dt>
    <dd>
    Boot the operating system installed on the first local drive.

    </dd>
    </dl>
3.  Press the **Enter** key.

<div class="alert alert-info">
**Note:** From the boot menu, you can also press the **Tab** key to edit the kernel parameters. Kernel parameters must be separated by a space, and once you have entered the preferred kernel parameters, you can boot the system using those kernel parameters by pressing the **Enter** key. To clear any changes you have made to the kernel parameters and return to the boot menu, press the **Esc** key. For a list of supported kernel parameters, see the *Red Hat Enterprise Linux - Hypervisor Deployment Guide*.

</div>
**Result**

You have started the hypervisor installation program.

####  Hypervisor Menu Actions

*   The directional keys (**Up**, **Down**, **Left**, **Right**) are used to select different controls on the screen. Alternatively the **Tab** key cycles through the controls on the screen which are enabled.
*   Text fields are represented by a series of underscores (**_**). To enter data in a text field select it and begin entering data.
*   Buttons are represented by labels which are enclosed within a pair of angle brackets (**<** and **>**). To activate a button ensure it is selected and press **Enter** or **Space**.
*   Boolean options are represented by an asterisk (**\***) or a space character enclosed within a pair of square brackets (**[** and **]**). When the value contained within the brackets is an asterisk then the option is set, otherwise it is not. To toggle a Boolean option on or off press **Space** while it is selected.

####  Installing the Hypervisor

**Summary**

There are two methods for installing oVirt Nodes:

*   Interactive installation.
*   Unattended installation.

This section outlines the procedure for installing a Hypervisor interactively. For information on unattended installation, see the *Red Hat Enterprise Linux - Hypervisor Deployment Guide*.

⁠

**Procedure 5.8. Installing the Hypervisor Interactively**

1.  Use the prepared boot media to boot the machine on which the Hypervisor is to be installed.
2.  Select **Install Hypervisor** and press **Enter** to begin the installation process.
3.  The first screen that appears allows you to configure the appropriate keyboard layout for your locale. Use the arrow keys to highlight the appropriate option and press **Enter** to save your selection.
    ⁠

    **Example 5.4. Keyboard Layout Configuration**

        Keyboard Layout Selection

        Available Keyboard Layouts
        Swiss German (latin1)
        Turkish
        U.S. English
        U.S. International
        ...

        (Hit enter to select a layout)

        &lt;Quit&gt;     &lt;Back&gt;     &lt;Continue&gt;

4.  The installation script automatically detects all disks attached to the system. This information is used to assist with selection of the boot and installation disks that the Hypervisor will use. Each entry displayed on these screens indicates the **Location**, **Device Name**, and **Size** of the disks.
    1.  **Boot Disk**
        The first disk selection screen is used to select the disk from which the Hypervisor will boot. The Hypervisor's boot loader will be installed to the Master Boot Record (MBR) of the disk that is selected on this screen. The Hypervisor attempts to automatically detect the disks attached to the system and presents the list from which to choose the boot device. Alternatively, you can manually select a device by specifying a block device name using the **Other Device** option.

        **Important**

        The selected disk must be identified as a boot device and appear in the boot order either in the system's BIOS or in a pre-existing boot loader.

        -   **Automatically Detected Device Selection**
            1.  Select the entry for the disk the Hypervisor is to boot from in the list and press **Enter**.
            2.  Select the disk and press **Enter**. This action saves the boot device selection and starts the next step of installation.
        -   **Manual Device Selection**
            1.  Select **Other device** and press **Enter**.
            2.  When prompted to **Please select the disk to use for booting RHEV-H**, enter the name of the block device from which the Hypervisor should boot.
                ⁠

                **Example 5.5. Other Device Selection**

                    Please select the disk to use for booting RHEV-H
                    /dev/sda

            3.  Press **Enter**. This action saves the boot device selection and starts the next step of installation.

    2.  The disk or disks selected for installation will be those to which the Hypervisor itself is installed. The Hypervisor attempts to automatically detect the disks attached to the system and presents the list from which installation devices are chosen.
        **Warning**

        All data on the selected storage devices will be destroyed.

        1.  Select each disk on which the Hypervisor is to be installed and press **Space** to toggle it to enabled. Where other devices are to be used for installation, either solely or in addition to those which are listed automatically, use **Other Device**.
        2.  Select the **Continue** button and press **Enter** to continue.
        3.  Where the **Other Device** option was specified, a further prompt will appear. Enter the name of each additional block device to use for Hypervisor installation, separated by a comma. Once all required disks have been selected, select the **<Continue>** button and press **Enter**.
            ⁠

            **Example 5.6. Other Device Selection**

                Please enter one or more disks to use for installing RHEV-H. Multiple devices can be separated by comma.
                Device path:   /dev/mmcblk0,/dev/mmcblk1______________

        Once the installation disks have been selected, the next stage of the installation starts.

5.  The next screen allows you to configure storage for the Hypervisor.
    1.  Select or clear the **Fill disk with Data partition** check box. Clearing this text box displays a field showing the remaining space on the drive and allows you to specify the amount of space to be allocated to data storage.
    2.  Enter the preferred values for **Swap**, **Config**, and **Logging**.
    3.  If you selected the **Fill disk with Data partition** check box, the **Data** field is automatically set to `0`. If the check box was cleared, you can enter a whole number up to the value of the **Remaining Space** field. Entering a value of `-1` fills all remaining space.

6.  The Hypervisor requires a password be set to protect local console access to the `admin` user. The installation script prompts you to enter the preferred password in both the **Password** and **Confirm Password** fields. Use a strong password. Strong passwords comprise a mix of uppercase, lowercase, numeric, and punctuation characters. They are six or more characters long and do not contain dictionary words. Once a strong password has been entered, select **<Install>** and press **Enter** to install the Hypervisor on the selected disks.

**Result**

Once installation is complete, the message `RHEV Hypervisor Installation Finished Successfully` will be displayed. Select the **<Reboot>** button and press **Enter** to reboot the system.

<div class="alert alert-info">
**Note:** Remove the boot media and change the boot device order to prevent the installation sequence restarting after the system reboots.

</div>
<div class="alert alert-info">
**Note:** oVirt Nodes are able to use Storage Area Networks (SANs) and other network storage for storing virtualized guest images. Hypervisors can be installed on SANs, provided that the Host Bus Adapter (HBA) permits configuration as a boot device in BIOS.

</div>
<div class="alert alert-info">
**Note:** Hypervisors are able to use multipath devices for installation. Multipath is often used for SANs or other networked storage. Multipath is enabled by default at install time. Any block device which responds to `scsi_id` functions with multipath. Devices where this is not the case include USB storage and some older ATA disks.

</div>
### Configuration

####  Logging Into the Hypervisor

**Summary**

You can log into the hypervisor console locally to configure the hypervisor.

⁠

**Procedure 5.9. Logging Into the Hypervisor**

1.  Start the machine on which oVirt Node operating system is installed.
2.  Enter the user name `admin` and press **Enter**.
3.  Enter the password you set during installation and press **Enter**.

**Result**

You have successfully logged into the hypervisor console as the `admin` user.

####  The Status Screen

The **Status** screen provides an overview of the state of the Hypervisor such as the current status of networking, the location in which logs and reports are stored, and the number of virtual machines that are active on that hypervisor. The **Status** screen also provides the following buttons for viewing further details regarding the Hypervisor and for changing the state of the Hypervisor:

*   **<View Host Key>**: Displays the RSA host key fingerprint and host key of the Hypervisor.
*   **<View CPU Details>**: Displays details on the CPU used by the Hypervisor such as the CPU name and type.
*   **<Lock>**: Locks the Hypervisor. The user name and password must be entered to unlock the Hypervisor.
*   **<Log Off>**: Logs off the current user.
*   **<Restart>**: Restarts the Hypervisor.
*   **<Power Off>**: Turns the Hypervisor off.

#### The Network Screen

##### The Network Screen

The **Network** screen is used to configure the host name of the hypervisor and the DNS servers, NTP servers and network interfaces that the hypervisor will use. The **Network** screen also provides a number of buttons for testing and configuring network interfaces:

*   **<Ping>**: Allows you to ping a given IP address by specifying the address to ping and the number of times to ping that address.
*   **<Create Bond>**: Allows you to create bonds between network interfaces.

##### Configuring the Host Name

**Summary**

You can change the host name used to identify the hypervisor.

⁠

**Procedure 5.10. Configuring the Host Name**

1.  Select the **Hostname** field on the **Network** screen and enter the new host name.
2.  Select **<Save>** and press **Enter** to save the changes.

**Result**

You have changed the host name used to identify the hypervisor.

##### Configuring Domain Name Servers

**Summary**

You can specify up to two domain name servers that the hypervisor will use to resolve network addresses.

⁠

**Procedure 5.11. Configuring Domain Name Servers**

1.  To set or change the primary DNS server, select the **DNS Server 1** field and enter the IP address of the new primary DNS server.
2.  To set or change the secondary DNS server, select the **DNS Server 2** field and enter the IP address of the new secondary DNS server.
3.  Select **<Save>** and press **Enter** to save the changes.

**Result**

You have specified the primary and secondary domain name servers that the hypervisor will use to resolve network addresses.

##### Configuring Network Time Protocol Servers

**Summary**

You can specify up to two network time protocol servers that the hypervisor will use to synchronize its system clock.

<div class="alert alert-info">
**Important:** You must specify the same time servers as oVirt to ensure all system clocks throughout the oVirt environment are synchronized.

</div>
⁠

**Procedure 5.12. Configuring Network Time Protocol Servers**

1.  To set or change the primary NTP server, select the **NTP Server 1** field and enter the IP address or host name of the new primary NTP server.
2.  To set or change the secondary NTP server, select the **NTP Server 2** field and enter the IP address or host name of the new secondary NTP server.
3.  Select **<Save>** and press **Enter** to save changes to the NTP configuration.

**Result**

You have specified the primary and secondary NTP servers that the hypervisor will use to synchronize its system clock.

##### Configuring Network Interfaces

**Summary**

After you have installed oVirt Node operating system, all network interface cards attached to the hypervisor are initially in an unconfigured state. You must configure at least one network interface to connect the hypervisor with oVirt.

⁠

**Procedure 5.13. Configuring Network Interfaces**

1.  Select a network interfaces from the list beneath **Available System NICs** and press **Enter** to configure that network interface.
    **Note**

    To identify the physical network interface card associated with the selected network interface, select **<Flash Lights to Identify>** and press **Enter**.

2.  Configure a dynamic or static IP address:
    -   **Configuring a Dynamic IP Address**
        Select **DHCP** under **IPv4 Settings** and press the space bar to enable this option.

    -   **Configuring a Static IP Address**
        -   Select **Static** under **IPv4 Settings** and press the space bar to enable this option.
        -   Specify the **IP Address**, **Netmask**, and **Gateway** that the hypervisor will use.

        ⁠

        **Example 5.7. Static IPv4 Networking Configuration**

            IPv4 Settings
            ( ) Disabled     ( ) DHCP     (*) Static
            IP Address: 192.168.122.100_  Netmask: 255.255.255.0___
            Gateway     192.168.1.1_____

    **Note**

    oVirt does not currently support IPv6 networking. IPv6 networking must remain set to **Disabled**.

3.  Enter a VLAN identifer in the **VLAN ID** field to configure a VLAN for the device.
4.  Select the **Use Bridge** option and press the space bar to enable this option.
5.  Select the **<Save>** button and press **Enter** to save the network configuration.

**Result**

The progress of configuration is displayed on screen. When configuration is complete, press the **Enter** key to close the progress window and return to the **Network** screen. The network interface is now listed as **Configured**.

#### 4. The Security Screen

**Summary**

You can configure security-related options for the hypervisor such as SSH password authentication, AES-NI encryption, and the password of the `admin` user.

⁠

**Procedure 5.14. Configuring Security**

1.  Select the **Enable SSH password authentication** option and press the space bar to enable SSH authentication.
2.  Select the **Disable AES-NI** option and press the space bar to disable the use of AES-NI for encryption.
3.  Optionally, enter the number of bytes by which to pad blocks in AES-NI encryption if AES-NI encryption is enabled.
4.  Enter a new password for the `admin` user in the **Password** field and **Confirm Password** to change the password used to log into the hypervisor console.
5.  Select **<Save>** and press **Enter**.

**Result**

You have updated the security-related options for the hypervisor.

####  The Keyboard Screen

**Summary**

The **Keyboard** screen allows you to configure the keyboard layout used inside the hypervisor console.

⁠

**Procedure 5.15. Configuring the Hypervisor Keyboard Layout**

1.  Select a keyboard layout from the list provided.
        Keyboard Layout Selection

        Choose the Keyboard Layout you would like to apply to this system.

        Current Active Keyboard Layout: U.S. English
        Available Keyboard Layouts
        Swiss German (latin1)
        Turkish
        U.S. English
        U.S. International
        Ukranian
        ...

        &lt;Save&gt;

2.  Select **Save** and press **Enter** to save the selection.

**Result**

You have successfully configured the keyboard layout.

####  The SNMP Screen

**Summary**

The **SNMP** screen allows you to enable and configure a password for simple network management protocol.

    Enable SNMP       [ ]

    SNMP Password
    Password:          _______________
    Confirm Password:  _______________

    &lt;Save&gt;     &lt;Reset&gt;

⁠

**Procedure 5.16. Configuring Simple Network Management Protocol**

1.  Select the **Enable SNMP** option and press the space bar to enable SNMP.
2.  Enter a password in the **Password** and **Confirm Password** fields.
3.  Select **<Save>** and press **Enter**.

**Result**

You have enabled SNMP and configured a password that the hypervisor will use in SNMP communication.

####  The CIM Screen

**Summary**

The **CIM** screen allows you to configure a common information model for attaching the hypervisor to a pre-existing CIM management infrastructure and monitor virtual machines that are running on the hypervisor.

⁠

**Procedure 5.17. Configuring Hypervisor Common Information Model**

1.  Select the **Enable CIM** option and press the space bar to enable CIM.
        Enable CIM     [ ]

2.  Enter a password in the **Password** field and **Confirm Password** field.
3.  Select **Save** and press **Enter**.

**Result**

You have configured the Hypervisor to accept CIM connections authenticated using a password. Use this password when adding the Hypervisor to your common information model object manager.

####  The Logging Screen

**Summary**

The **Logging** screen allows you to configure logging-related options such as a daemon for automatically exporting log files generated by the hypervisor to a remote server.

⁠

**Procedure 5.18. Configuring Logging**

1.  In the **Logrotate Max Log Size** field, enter the maximum size in kilobytes that log files can reach before they are rotated by **logrotate**. The default value is `1024`.
2.  Optionally, configure **rsyslog** to transmit log files to a remote `syslog` daemon:
    1.  Enter the remote **rsyslog** server address in the **Server Address** field.
    2.  Enter the remote **rsyslog** server port in the **Server Port** field. The default port is `514`.

3.  Optionally, configure **netconsole** to transmit kernel messages to a remote destination:
    1.  Enter the **Server Address**.
    2.  Enter the **Server Port**. The default port is `6666`.

4.  Select **<Save>** and press **Enter**.

**Result**

You have configured logging for the hypervisor.

####  The Kdump Screen

**Summary**

The **Kdump** screen allows you to specify a location in which kernel dumps will be stored in the event of a system failure. There are four options - **Disable**, which disables kernel dumping, **Local**, which stores kernel dumps on the local system, and **SSH** and **NFS**, which allow you to export kernel dumps to a remote location.

⁠

**Procedure 5.19. Configuring Kernel Dumps**

1.  Select an option for storing kernel dumps:
    -   **Local**
        1.  Select the **Local** option and press the space bar to store kernel dumps on the local system.
    -   **SSH**
        1.  Select the **SSH** option and press the space bar to export kernel dumps via SSH.
        2.  Enter the location in which kernel dumps will be stored in the **SSH Location (root@example.com)** field.
    -   **NFS**
        1.  Select the **NFS** option and press the space bar to export kernel dumps to an NFS share.
        2.  Enter the location in which kernel dumps will be stored in the **NFS Location (example.com:/var/crash)** field.

2.  Select **<Save>** and press **Enter**.

**Result**

You have configured a location in which kernel dumps will be stored in the event of a system failure.

#### 10. The Remote Storage Screen

**Summary**

You can use the **Remote Storage** screen to specify a remote iSCSI initiator or NFS share to use as storage.

⁠

**Procedure 5.20. Configuring Remote Storage**

1.  Enter an initiator name in the **iSCSI Initiator Name** field or the path to the NFS share in the **NFSv4 Domain (example.redhat.com)** field.
    ⁠

    **Example 5.8. iSCSI Initiator Name**

        iSCSI Initiator Name:
        iqn.1994-05.com.redhat:5189835eeb40_____

    ⁠

    **Example 5.9. NFS Path**

        NFSv4 Domain (example.redhat.com):
        example.redhat.com_____________________

2.  Select **<Save>** and press **Enter**.

**Result**

You have configured remote storage.

#### 11. Configuring Hypervisor Management Server

**Summary**

You can attach the Hypervisor to oVirt immediately if the address of oVirt is available. If oVirt has not yet been installed, you must instead set a password. This allows the Hypervisor to be added from the Administration Portal once oVirt has been installed. Both modes of configuration are supported from the **oVirt Engine** screen in the Hypervisor user interface.

<div class="alert alert-info">
**Important:** Setting a password on the **oVirt Engine** configuration screen sets the `root` password on the Hypervisor and enables SSH password authentication. Once the Hypervisor has successfully been added to oVirt, disabling SSH password authentication is recommended.

</div>
⁠

**Procedure 5.21. Configuring a Hypervisor Management Server**

1.  -   **Configuration Using a Management Server Address**
        1.  Enter the IP address or fully qualified domain name of oVirt in the **Management Server** field.
        2.  Enter the management server port in the **Management Server Port** field. The default value is `443`. If a different port was selected during oVirt installation, specify it here, replacing the default value.
        3.  Select the **Retrieve Certificate** option to verify that the fingerprint of the certificate retrieved from the specified management server is correct. The value that the certificate fingerprint is compared against is returned at the end of oVirt installation.
        4.  Leave the **Password** and **Confirm Password** fields blank. These fields are not required if the address of the management server is known.
    -   **Configuration Using a Password**
        1.  Enter a password in the **Password** field. It is recommended that you use a strong password. Strong passwords contain a mix of uppercase, lowercase, numeric and punctuation characters. They are six or more characters long and do not contain dictionary words.
        2.  Re-enter the password in the **Confirm Password** field.
        3.  Leave the **Management Server** and **Management Server Port** fields blank. As long as a password is set, allowing the Hypervisor to be added to oVirt later, these fields are not required.

2.  **Save Configuration**
    To save the configuration select **<Save>** and press **Enter**.

**Result**

The **oVirt Engine** configuration has been updated.

### Adding Hypervisors to oVirt

####  Using the Hypervisor

If the Hypervisor was configured with the address of oVirt, the Hypervisor reboots and is automatically registered with oVirt. oVirt interface displays the Hypervisor under the **Hosts** tab. To prepare the Hypervisor for use, it must be approved using oVirt.

If the Hypervisor was configured without the address of oVirt, it must be added manually. To add the Hypervisor manually, you must have both the IP address of the machine upon which it was installed and the password that was set on the **oVirt Engine** screen during configuration.

####  Approving a Hypervisor

**Summary**

It is not possible to run virtual machines on a Hypervisor until the addition of it to the environment has been approved in oVirt.

⁠

**Procedure 5.22. Approving a Hypervisor**

1.  Log in to oVirt Administration Portal.
2.  From the **Hosts** tab, click on the host to be approved. The host should currently be listed with the status of **Pending Approval**.
3.  Click the **Approve** button. The **Edit and Approve Hosts** dialog displays. You can use the dialog to set a name for the host, fetch its SSH fingerprint before approving it, and configure power management, where the host has a supported power management card. For information on power management configuration, refer to [Section 7.6.2, “Host Power Management Settings Explained”](#Host_Power_Management_settings_explained).
4.  Click **OK**. If you have not configured power management you will be prompted to confirm that you wish to proceed without doing so, click **OK**.

**Result**

The status in the **Hosts** tab changes to **Installing**, after a brief delay the host status changes to **Up**.

## ⁠Chapter 6. Red Hat Enterprise Linux Hosts

### Red Hat Enterprise Linux Hosts

You can use a standard Red Hat Enterprise Linux 6 installation on capable hardware as a host. oVirt supports hosts running Red Hat Enterprise Linux 6 Server AMD64/Intel 64 version.

Adding a host can take some time, as the following steps are completed by the platform: virtualization checks, installation of packages, creation of bridge and a reboot of the host. Use the Details pane to monitor the hand-shake process as the host and management system establish a connection.

## ⁠Chapter 7. Configuring Hosts

### Installing Red Hat Enterprise Linux

**Summary**

You must install Red Hat Enterprise Linux 6.5 Server on a system to use it as a virtualization host in a oVirt 3.4 environment.

⁠

**Procedure 7.1. Installing Red Hat Enterprise Linux**

1.  **Download and Install Red Hat Enterprise Linux 6.5 Server**
    Download and Install Red Hat Enterprise Linux 6.5 Server on the target virtualization host, referring to the *Red Hat Enterprise Linux 6 Installation Guide* for detailed instructions. Only the Base package group is required to use the virtualization host in a oVirt environment.

    **Important**

    If you intend to use directory services for authentication on the Red Hat Enterprise Linux host then you must ensure that the authentication files required by the `useradd` command are locally accessible. The vdsm package, which provides software that is required for successful connection to oVirt, will not install correctly if these files are not locally accessible.

2.  **Ensure Network Connectivity**
    Following successful installation of Red Hat Enterprise Linux 6.5 Server, ensure that there is network connectivity between your new Red Hat Enterprise Linux host and the system on which your oVirt is installed.

    1.  Attempt to ping oVirt:
            # ping address of manager

    2.  -   If oVirt can successfully be contacted, this displays:
                ping manager.example.redhat.com
                PING manager.example.redhat.com (192.168.0.1) 56(84) bytes of data.
                64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=0.415 ms
                64 bytes from 192.168.0.1: icmp_seq=2 ttl=64 time=0.419 ms
                64 bytes from 192.168.0.1: icmp_seq=3 ttl=64 time=1.41 ms
                64 bytes from 192.168.0.1: icmp_seq=4 ttl=64 time=0.487 ms
                64 bytes from 192.168.0.1: icmp_seq=5 ttl=64 time=0.409 ms
                64 bytes from 192.168.0.1: icmp_seq=6 ttl=64 time=0.372 ms
                64 bytes from 192.168.0.1: icmp_seq=7 ttl=64 time=0.464 ms

                --- manager.example.redhat.com ping statistics ---
                7 packets transmitted, 7 received, 0% packet loss, time 6267ms

        -   If oVirt cannot be contacted, this displays:
                ping: unknown host manager.usersys.redhat.com

            You must configure the network so that the host can contact oVirt. First, disable **NetworkManager**. Then configure the networking scripts so that the host will acquire an ip address on boot.

            1.  Disable **NetworkManager**.
                    # service NetworkManager stop
                    # chkconfig NetworkManager disable

            2.  Edit `/etc/sysconfig/network-scripts/ifcfg-eth0`. Find this line:
                    ONBOOT=no

                Change that line to this:

                    ONBOOT=yes

            3.  Reboot the host machine.
            4.  Ping oVirt again:
                    # ping address of manager

                If the host still cannot contact oVirt, it is possible that your host machine is not acquiring an IP address from DHCP. Confirm that DHCP is properly configured and that your host machine is properly configured to acquire an IP address from DHCP.

                If oVirt can successfully be contacted, this displays:

                    ping manager.example.redhat.com
                    PING manager.example.redhat.com (192.168.0.1) 56(84) bytes of data.
                    64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=0.415 ms
                    64 bytes from 192.168.0.1: icmp_seq=2 ttl=64 time=0.419 ms
                    64 bytes from 192.168.0.1: icmp_seq=3 ttl=64 time=1.41 ms
                    64 bytes from 192.168.0.1: icmp_seq=4 ttl=64 time=0.487 ms
                    64 bytes from 192.168.0.1: icmp_seq=5 ttl=64 time=0.409 ms
                    64 bytes from 192.168.0.1: icmp_seq=6 ttl=64 time=0.372 ms
                    64 bytes from 192.168.0.1: icmp_seq=7 ttl=64 time=0.464 ms

                    --- manager.example.redhat.com ping statistics ---
                    7 packets transmitted, 7 received, 0% packet loss, time 6267ms

**Result**

You have installed Red Hat Enterprise Linux 6.5 Server. You must complete additional configuration tasks before adding the virtualization host to your oVirt environment.

### Configuring the Virtualization Host Firewall

**Summary**

oVirt requires a number of network ports to be open to support virtual machines and remote management of the virtualization host from oVirt. You must follow this procedure to open the required network ports before attempting to add the virtualization host to oVirt.

The steps in the following procedure configure the default firewall in Red Hat Enterprise Linux, `iptables`, to allow traffic on the required network ports. This procedure replaces the host's existing firewall configuration with one that contains only the ports required by oVirt. If you have existing firewall rules with which this configuration must be merged, then you must do so by manually editing the rules defined in the `iptables` configuration file, `/etc/sysconfig/iptables`.

All commands in this procedure must be run as the `root` user.

⁠

**Procedure 7.2. Configuring the Virtualization Host Firewall**

1.  **Remove existing rules from the firewall configuration**
    Remove any existing firewall rules using the *`--flush`* parameter to the `iptables` command.

        # iptables --flush

2.  **Add new firewall rules to configuration**
    Add the firewall rules required by oVirt using the *`--append`* parameter to the `iptables` command. The prompt character (**#**) has been intentionally omitted from this list of commands to allow easy copying of the content to a script file or command prompt.

        iptables --append INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
        iptables --append INPUT -p icmp -j ACCEPT
        iptables --append INPUT -i lo -j ACCEPT
        iptables --append INPUT -p tcp --dport 22 -j ACCEPT
        iptables --append INPUT -p tcp --dport 16514 -j ACCEPT
        iptables --append INPUT -p tcp --dport 54321 -j ACCEPT
        iptables --append INPUT -p tcp -m multiport --dports 5900:6923 -j ACCEPT
        iptables --append INPUT -p tcp -m multiport --dports 49152:49216 -j ACCEPT
        iptables --append INPUT -j REJECT --reject-with icmp-host-prohibited
        iptables --append FORWARD -m physdev ! --physdev-is-bridged -j REJECT \
        --reject-with icmp-host-prohibited

    **Note**

    The provided `iptables` commands add firewall rules to accept network traffic on a number of ports. These include:

    -   Port `22` for **SSH**.
    -   Ports `5900` to `6923` for guest console connections.
    -   Port `16514` for **libvirt** virtual machine migration traffic.
    -   Ports `49152` to `49216` for VDSM virtual machine migration traffic.
    -   Port `54321` for oVirt.

3.  **Save the updated firewall configuration**
    Run the following command to save the updated firewall configuration:

        # service iptables save

4.  **Enable iptables service**
    Ensure the `iptables` service is configured to start on boot and has been restarted, or is started for the first time if it was not already running.

        # chkconfig iptables on
        # service iptables restart

**Result**

You have configured the virtualization host's firewall to allow the network traffic required by oVirt.

### Configuring Virtualization Host sudo

**Summary**

oVirt uses **sudo** to perform operations as the `root` on the host. The default Red Hat Enterprise Linux configuration, stored in `/etc/sudoers`, contains values that allow this. If this file has been modified since Red Hat Enterprise Linux installation, then these values may have been removed. This procedure verifies that the required entry still exists in the configuration, and adds the required entry if it is not present.

⁠

**Procedure 7.3. Configuring Virtualization Host sudo**

1.  **Log in**
    Log in to the virtualization host as the `root` user.

2.  **Run visudo**
    Run the `visudo` command to open the `/etc/sudoers` file.

        # visudo

3.  **Edit sudoers file**
    Read the configuration file, and verify that it contains these lines:

        # Allow root to run any commands anywhere 
        root    ALL=(ALL)   ALL

    If the file does not contain these lines, add them and save the file using the VIM `:w` command.

4.  **Exit editor**
    Exit `visudo` using the VIM `:q` command.

**Result**

You have configured **sudo** to allow use by the `root` user.

### Configuring Virtualization Host SSH

**Summary**

oVirt accesses virtualization hosts via SSH. To do this it logs in as the `root` user using an encrypted key for authentication. You must follow this procedure to ensure that SSH is configured to allow this.

**Warning**

The first time oVirt is connected to the host it will install an authentication key. In the process it will overwrite any existing keys contained in the `/root/.ssh/authorized_keys` file.

⁠

**Procedure 7.4. Configuring virtualization host SSH**

All commands in this procedure must be run as the `root` user.

1.  **Install the SSH server (openssh-server)**
    Install the openssh-server package using `yum`.

        # yum install openssh-server

2.  **Edit SSH server configuration**
    Open the SSH server configuration, `/etc/ssh/sshd_config`, in a text editor. Search for the *`PermitRootLogin`*.

    -   If *`PermitRootLogin`* is set to `yes`, or is not set at all, no further action is required.
    -   If *`PermitRootLogin`* is set to `no`, then you must change it to `yes`.

    Save any changes that you have made to the file, and exit the text editor.

3.  **Enable the SSH server**
    Configure the SSH server to start at system boot using the `chkconfig` command.

        # chkconfig --level 345 sshd on

4.  **Start the SSH server**
    Start the SSH, or restart it if it is already running, using the `service` command.

        # service sshd restart

**Result**

You have configured the virtualization host to allow `root` access over SSH.

### Adding a Red Hat Enterprise Linux Host

**Summary**

A Red Hat Enterprise Linux host is based on a standard "basic" installation of Red Hat Enterprise Linux. The physical host must be set up before you can add it to the oVirt environment.

oVirt logs into the host to perform virtualization capability checks, install packages, create a network bridge, and reboot the host. The process of adding a new host can take up to 10 minutes.

⁠

**Procedure 7.5. Adding a Red Hat Enterprise Linux Host**

1.  Click the **Hosts** resource tab to list the hosts in the results list.
2.  Click **New** to open the **New Host** window.
3.  Use the drop-down menus to select the **Data Center** and **Host Cluster** for the new host.
4.  Enter the **Name**, **Address**, and **SSH Port** of the new host.
5.  Select an authentication method to use with the host.
    -   Enter the root user's password to use password authentication.
    -   Copy the key displayed in the **SSH PublicKey** field to `/root/.ssh/authorized_keys` on the host to use public key authentication.

6.  You have now completed the mandatory steps to add a Red Hat Enterprise Linux host. Click the **Advanced Parameters** button to expand the advanced host settings.
    1.  Optionally disable automatic firewall configuration.
    2.  Optionally add a host SSH fingerprint to increase security. You can add it manually, or fetch it automatically.

7.  You can configure the **Power Management** and **SPM** using the applicable tabs now; however, as these are not fundamental to adding a Red Hat Enterprise Linux host, they are not covered in this procedure.
8.  Click **OK** to add the host and close the window.

**Result**

The new host displays in the list of hosts with a status of `Installing`. When installation is complete, the status updates to `Reboot`. The host must be activated for the status to change to `Up`.

<div class="alert alert-info">
**Note:** You can view the progress of the installation in the details pane.

</div>
### Explanation of Settings and Controls in the New Host and Edit Host Windows

####  Host General Settings Explained

These settings apply when editing the details of a host or adding new Red Hat Enterprise Linux hosts and Foreman host provider hosts.

The **General** settings table contains the information required on the **General** tab of the **New Host** or **Edit Host** window.

⁠

**Table 7.1. General settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Data Center</strong></p></td>
<td align="left"><p>The data center to which the host belongs. oVirt Node hosts cannot be added to Gluster-enabled clusters.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Host Cluster</strong></p></td>
<td align="left"><p>The cluster to which the host belongs.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Use External Providers</strong></p></td>
<td align="left"><p>Select or clear this check box to view or hide options for adding hosts provided by external providers. Upon selection, a drop-down list of external providers that have been added to oVirt displays. The following options are also available:</p>
<ul>
<li><strong>Provider search filter</strong> - A text field that allows you to search for hosts provided by the selected external provider. This option is provider-specific; see provider documentation for details on forming search queries for specific providers. Leave this field blank to view all available hosts.</li>
<li><strong>External Hosts</strong> - A drop-down list that is populated with the name of hosts provided by the selected external provider. The entries in this list are filtered in accordance with any search queries that have been input in the <strong>Provider search filter</strong>.</li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Name</strong></p></td>
<td align="left"><p>The name of the cluster. This text field has a 40-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Comment</strong></p></td>
<td align="left"><p>A field for adding plain text, human-readable comments regarding the host.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Address</strong></p></td>
<td align="left"><p>The IP address, or resolvable hostname of the host.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Password</strong></p></td>
<td align="left"><p>The password of the host's root user. This can only be given when you add the host; it cannot be edited afterwards.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>SSH PublicKey</strong></p></td>
<td align="left"><p>Copy the contents in the text box to the <code>/root/.known_hosts</code> file on the host to use oVirt's ssh key instead of using a password to authenticate with the host.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Automatically configure host firewall</strong></p></td>
<td align="left"><p>When adding a new host, oVirt can open the required ports on the host's firewall. This is enabled by default. This is an <strong>Advanced Parameter</strong>.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>SSH Fingerprint</strong></p></td>
<td align="left"><p>You can <strong>fetch</strong> the host's SSH fingerprint, and compare it with the fingerprint you expect the host to return, ensuring that they match. This is an <strong>Advanced Parameter</strong>.</p></td>
</tr>
</tbody>
</table>

####  Host Power Management Settings Explained

The **Power Management** settings table contains the information required on the **Power Management** tab of the **New Host** or **Edit Host** windows.

⁠

**Table 7.2. Power Management Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Primary/ Secondary</strong></p></td>
<td align="left"><p>Prior to oVirt 3.2, a host with power management configured only recognized one fencing agent. Fencing agents configured on version 3.1 and earlier, and single agents, are treated as primary agents. The secondary option is valid when a second agent is defined.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Concurrent</strong></p></td>
<td align="left"><p>Valid when there are two fencing agents, for example for dual power hosts in which each power switch has two agents connected to the same power switch.</p>
<ul>
<li>If this check box is selected, both fencing agents are used concurrently when a host is fenced. This means that both fencing agents have to respond to the Stop command for the host to be stopped; if one agent responds to the Start command, the host will go up.</li>
<li>If this check box is not selected, the fencing agents are used sequentially. This means that to stop or start a host, the primary agent is used first, and if it fails, the secondary agent is used.</li>
</ul></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Address</strong></p></td>
<td align="left"><p>The address to access your host's power management device. Either a resolvable hostname or an IP address.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>User Name</strong></p></td>
<td align="left"><p>User account with which to access the power management device. You can set up a user on the device, or use the default user.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Password</strong></p></td>
<td align="left"><p>Password for the user accessing the power management device.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Type</strong></p></td>
<td align="left"><p>The type of power management device in your host. Choose one of the following:</p>
<ul>
<li><strong>apc</strong> - APC MasterSwitch network power switch. Not for use with APC 5.x power switch devices.</li>
<li><strong>apc_snmp</strong> - Use with APC 5.x power switch devices.</li>
<li><strong>bladecenter</strong> - IBM Bladecentre Remote Supervisor Adapter.</li>
<li><strong>cisco_ucs</strong> - Cisco Unified Computing System.</li>
<li><strong>drac5</strong> - Dell Remote Access Controller for Dell computers.</li>
<li><strong>drac7</strong> - Dell Remote Access Controller for Dell computers.</li>
<li><strong>eps</strong> - ePowerSwitch 8M+ network power switch.</li>
<li><strong>hpblade</strong> - HP BladeSystem.</li>
<li><strong>ilo</strong>, <strong>ilo2</strong>, <strong>ilo3</strong>, <strong>ilo4</strong> - HP Integrated Lights-Out.</li>
<li><strong>ipmilan</strong> - Intelligent Platform Management Interface and Sun Integrated Lights Out Management devices.</li>
<li><strong>rsa</strong> - IBM Remote Supervisor Adaptor.</li>
<li><strong>rsb</strong> - Fujitsu-Siemens RSB management interface.</li>
<li><strong>wti</strong> - WTI Network PowerSwitch.</li>
</ul></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Port</strong></p></td>
<td align="left"><p>The port number used by the power management device to communicate with the host.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Options</strong></p></td>
<td align="left"><p>Power management device specific options. Enter these as 'key=value' or 'key'. See the documentation of your host's power management device for the options available.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Secure</strong></p></td>
<td align="left"><p>Tick this check box to allow the power management device to connect securely to the host. This can be done via ssh, ssl, or other authentication protocols depending on and supported by the power management agent.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Source</strong></p></td>
<td align="left"><p>Specifies whether the host will search within its <strong>cluster</strong> or <strong>data center</strong> for a fencing proxy. Use the <strong>Up</strong> and <strong>Down</strong> buttons to change the sequence in which the resources are used.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Disable policy control of power management</strong></p></td>
<td align="left"><p>Power management is controlled by the <strong>Cluster Policy</strong> of the host's <strong>cluster</strong>. If power management is enabled and the defined low utilization value is reached, oVirt will power down the host machine, and restart it again when load balancing requires or there are not enough free hosts in the cluster. Tick this check box to disable policy control.</p></td>
</tr>
</tbody>
</table>

#### 3. SPM Priority Settings Explained

The **SPM** settings table details the information required on the **SPM** tab of the **New Host** or **Edit Host** window.

⁠

**Table 7.3. SPM settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>SPM Priority</strong></p></td>
<td align="left"><p>Defines the likelihood that the host will be given the role of Storage Pool Manager(SPM). The options are <strong>Low</strong>, <strong>Normal</strong>, and <strong>High</strong> priority. Low priority means that there is a reduced likelihood of the host being assigned the role of SPM, and High priority means there is an increased likelihood. The default setting is Normal.</p></td>
</tr>
</tbody>
</table>

#### 4. Host Console Settings Explained

The **Console** settings table details the information required on the **Console** tab of the **New Host** or **Edit Host** window.

⁠

**Table 7.4. Console settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Override display address</strong></p></td>
<td align="left"><p>Select this check box to override the display addresses of the host. This feature is useful in a case where the hosts are defined by internal IP and are behind a NAT firewall. When a user connects to a virtual machine from outside of the internal network, instead of returning the private address of the host on which the virtual machine is running, the machine returns a public IP or FQDN (which is resolved in the external network to the public IP).</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Display address</strong></p></td>
<td align="left"><p>The display address specified here will be used for all virtual machines running on this host. The address must be in the format of a fully qualified domain name or IP.</p></td>
</tr>
</tbody>
</table>

## ⁠Chapter 8. Configuring Data Centers

### Workflow Progress - Planning Your Data Center

![](images/1194.png "images/1194.png")

### Planning Your Data Center

Successful planning is essential for a highly available, scalable oVirt environment.

Although it is assumed that your solution architect has defined the environment before installation, the following considerations must be made when designing the system.

CPU

Virtual Machines must be distributed across hosts so that enough capacity is available to handle higher than average loads during peak processing. Average target utilization will be 50% of available CPU.

Memory

The oVirt page sharing process overcommits up to 150% of physical memory for virtual machines. Therefore, allow for an approximately 30% overcommit.

Networking

When designing the network, it is important to ensure that the volume of traffic produced by storage, remote connections and virtual machines is taken into account. As a general rule, allow approximately 50 MBps per virtual machine.

It is best practice to separate disk I/O traffic from end-user traffic, as this reduces the load on the Ethernet connection and reduces security vulnerabilities by isolating data from the visual stream. For Ethernet networks, it is suggested that bonds (802.3ad) are utilized to aggregate server traffic types.

<div class="alert alert-info">
**Note:** It is possible to connect both the storage and Hypervisors via a single high performance switch. For this configuration to be effective, the switch must be able to provide 30 GBps on the backplane.

</div>
High Availability

The system requires at least two hosts to achieve high availability. This redundancy is useful when performing maintenance or repairs.

### Data Centers in oVirt

The data center is the highest level container for all physical and logical resources within a managed virtual environment. The data center is a collection of clusters of hosts. It owns the logical network (that is, the defined subnets for management, guest network traffic, and storage network traffic) and the storage pool.

oVirt contains a `Default` data center at installation. You can create new data centers that will also be managed from the single Administration Portal. For example, you may choose to have different data centers for different physical locations, business units, or for reasons of security. It is recommended that you do not remove the `Default` data center; instead, set up new appropriately named data centers.

The system administrator, as the superuser, can manage all aspects of the platform, that is, data centers, storage domains, users, roles, and permissions, by default; however, more specific administrative roles and permissions can be assigned to other users. For example, the enterprise may need a Data Center administrator for a specific data center, or a particular cluster may need an administrator. All system administration roles for physical resources have a hierarchical permission system. For example, a data center administrator will automatically have permission to manage all the objects in that data center - including storage domains, clusters, and hosts.

### Creating a New Data Center

**Summary**

This procedure creates a data center in your virtualization environment. The data center requires a functioning cluster, host, and storage domain to operate.

<div class="alert alert-info">
**Note:** The storage **Type** can be edited until the first storage domain is added to the data center. Once a storage domain has been added, the storage **Type** cannot be changed.

If you set the **Compatibility Version** as **3.1**, it cannot be changed to **3.0** at a later time; version regression is not allowed.

</div>
⁠

**Procedure 8.1. Creating a New Data Center**

1.  Select the **Data Centers** resource tab to list all data centers in the results list.
2.  Click **New** to open the **New Data Center** window.
3.  Enter the **Name** and **Description** of the data center.
4.  Select the storage **Type**, **Compatibility Version**, and **Quota Mode** of the data center from the drop-down menus.
5.  Click **OK** to create the data center and open the **New Data Center - Guide Me** window.
6.  The **Guide Me** window lists the entities that need to be configured for the data center. Configure these entities or postpone configuration by clicking the **Configure Later** button; configuration can be resumed by selecting the data center and clicking the **Guide Me** button.

**Result**

The new data center is added to the virtualization environment. It will remain **Uninitialized** until a cluster, host, and storage domain are configured for it; use **Guide Me** to configure these entities.

### Changing the Data Center Compatibility Version

**Summary**

oVirt data centers have a compatibility version. The compatibility version indicates the version of oVirt that the data center is intended to be compatible with. All clusters in the data center must support the desired compatibility level.

<div class="alert alert-info">
**Note:** To change the data center compatibility version, you must have first updated all the clusters in your data center to a level that supports your desired compatibility level.

</div>
⁠

**Procedure 8.2. Changing the Data Center Compatibility Version**

1.  Log in to the Administration Portal as the administrative user. By default this is the `admin` user.
2.  Click the **Data Centers** tab.
3.  Select the data center to change from the list displayed. If the list of data centers is too long to filter visually then perform a search to locate the desired data center.
4.  Click the **Edit** button.
5.  Change the **Compatibility Version** to the desired value.
6.  Click **OK**.

**Result**

You have updated the compatibility version of the data center.

**Warning**

Upgrading the compatibility will also upgrade all of the storage domains belonging to the data center. If you are upgrading the compatibility version from below 3.1 to a higher version, these storage domains will become unusable with versions older than 3.1.

## ⁠Chapter 9. Configuring Clusters

### Clusters in oVirt

A cluster is a collection of physical hosts that share similar characteristics and work together to provide computing resources in a highly available manner. In oVirt the cluster must contain physical hosts that share the same storage domains and have the same type of CPU. Because virtual machines can be migrated across hosts in the same cluster, the cluster is the highest level at which power and load-sharing policies can be defined. The oVirt platform contains a `Default` cluster in the `Default` data center at installation time.

Every cluster in the system must belong to a data center, and every host in the system must belong to a cluster. This enables the system to dynamically allocate a virtual machine to any host in the cluster, according to policies defined on the **Cluster** tab, thus maximizing memory and disk space, as well as virtual machine uptime.

At any given time, after a virtual machine runs on a specific host in the cluster, the virtual machine can be migrated to another host in the cluster using **Migrate**. This can be very useful when a host must be shut down for maintenance. The migration to another host in the cluster is transparent to the user, and the user continues working as usual. Note that a virtual machine cannot be migrated to a host outside the cluster.

<div class="alert alert-info">
**Note:** oVirt 3.1 supports the use of clusters to manage Gluster storage bricks, in addition to virtualization hosts. To begin managing Gluster storage bricks, create a cluster with the **Enable Gluster Service** option selected. For further information on Gluster storage bricks, see the *Red Hat Storage Administration Guide*, available at [<https://access.redhat.com/site/documentation/en-US/Red_Hat_Storage/>](https://access.redhat.com/site/documentation/en-US/Red_Hat_Storage/).

</div>
<div class="alert alert-info">
**Note:** oVirt supports **Memory Optimization** by enabling and tuning Kernel Same-page Merging (KSM) on the virtualization hosts in the cluster. For more information on KSM, see the *Red Hat Enterprise Linux 6 Virtualization Administration Guide*.

</div>
### Creating a New Cluster

**Summary**

A data center can contain multiple clusters, and a cluster can contain multiple hosts. All hosts in a cluster must be of the same CPU type (Intel or AMD). It is recommended that you create your hosts before you create your cluster to ensure CPU type optimization. However, you can configure the hosts at a later time using the **Guide Me** button.

⁠

**Procedure 9.1. Creating a New Cluster**

1.  Select the **Clusters** resource tab.
2.  Click **New** to open the **New Cluster** window.
3.  Select the **Data Center** the cluster will belong to from the drop-down list.
4.  Enter the **Name** and **Description** of the cluster.
5.  Select the **CPU Name** and **Compatibility Version** from the drop-down lists. It is important to match the CPU processor family with the minimum CPU processor type of the hosts you intend to attach to the cluster, otherwise the host will be non-operational.
6.  Select either the **Enable Virt Service** or **Enable Gluster Service** radio button to define whether the cluster will be populated with virtual machine hosts or with Gluster-enabled nodes. Note that you cannot add oVirt Node hosts to a Gluster-enabled cluster.
7.  Click the **Optimization** tab to select the memory page sharing threshold for the cluster, and optionally enable CPU thread handling and memory ballooning on the hosts in the cluster.
8.  Click the **Cluster Policy** tab to optionally configure a cluster policy, scheduler optimization settings, enable trusted service for hosts in the cluster, and enable HA Reservation.
9.  Click the **Resilience Policy** tab to select the virtual machine migration policy.
10. Click the **Console** tab to optionally override the global SPICE proxy, if any, and specify the address of a SPICE proxy for hosts in the cluster.
11. Click **OK** to create the cluster and open the **New Cluster - Guide Me** window.
12. The **Guide Me** window lists the entities that need to be configured for the cluster. Configure these entities or postpone configuration by clicking the **Configure Later** button; configuration can be resumed by selecting the cluster and clicking the **Guide Me** button.

**Result**

The new cluster is added to the virtualization environment.

### Changing the Cluster Compatibility Version

**Summary**

oVirt clusters have a compatibility version. The cluster compatibility version indicates the features of oVirt supported by all of the hosts in the cluster. The cluster compatibility is set according to the version of the least capable host operating system in the cluster.

<div class="alert alert-info">
**Note:** To change the cluster compatibility version, you must have first updated all the hosts in your cluster to a level that supports your desired compatibility level.

</div>
⁠

**Procedure 9.2. Changing the Cluster Compatibility Version**

1.  Log in to the Administration Portal as the administrative user. By default this is the `admin` user.
2.  Click the **Clusters** tab.
3.  Select the cluster to change from the list displayed. If the list of clusters is too long to filter visually then perform a search to locate the desired cluster.
4.  Click the **Edit** button.
5.  Change the **Compatibility Version** to the desired value.
6.  Click **OK** to open the **Change Cluster Compatibility Version** confirmation window.
7.  Click **OK** to confirm.

**Result**

You have updated the compatibility version of the cluster. Once you have updated the compatibility version of all clusters in a data center, then you are also able to change the compatibility version of the data center itself.

**Warning**

Upgrading the compatibility will also upgrade all of the storage domains belonging to the data center. If you are upgrading the compatibility version from below 3.1 to a higher version, these storage domains will become unusable with versions older than 3.1.

## ⁠Chapter 10. Configuring Networking

### ⁠10.1. Workflow Progress - Network Setup

![](images/1195.png "images/1195.png")

### ⁠10.2. Networking in oVirt

oVirt uses networking to support almost every aspect of operations. Storage, host management, user connections, and virtual machine connectivity, for example, all rely on a well planned and configured network to deliver optimal performance. Setting up networking is a vital prerequisite for a oVirt environment because it is much simpler to plan for your projected networking requirements and implement your network accordingly than it is to discover your networking requirements through use and attempt to alter your network configuration retroactively.

It is however possible to deploy a oVirt environment with no consideration given to networking at all. Simply ensuring that each physical machine in the environment has at least one *Network Interface Controller* (NIC) is enough to begin using oVirt. While it is true that this approach to networking will provide a functional environment, it will not provide an optimal environment. As network usage varies by task or action, grouping related tasks or functions into specialized networks can improve performance while simplifying the troubleshooting of network issues.

oVirt separates network traffic by defining logical networks. Logical networks define the path that a selected network traffic type must take through the network. They are created to isolate network traffic by functionality or virtualize a physical topology.

The `rhevm` logical network is created by default and labeled as the **Management**. The `rhevm` logical network is intended for management traffic between oVirt and virtualization hosts. You are able to define additional logical networks to segregate:

*   Display related network traffic.
*   General virtual machine network traffic.
*   Storage related network traffic.

For optimal performance it is recommended that these traffic types be separated using logical networks. Logical networks may be supported using physical devices such as NICs or logical devices, such as network bonds. It is not necessary to have one device for each logical network as multiple logical networks are able to share a single device. This is accomplished using Virtual LAN (VLAN) tagging to isolate network traffic. To make use of this facility VLAN tagging must also be supported at the switch level.

The limits that apply to the number of logical networks that you may define in a oVirt environment are:

*   The number of logical networks attached to a host is limited to the number of available network devices combined with the maximum number of Virtual LANs (VLANs) which is 4096.
*   The number of logical networks in a cluster is limited to the number of logical networks that can be attached to a host as networking must be the same for all hosts in a cluster.
*   The number of logical networks in a data center is limited only by the number of clusters it contains in combination with the number of logical networks permitted per cluster.

<div class="alert alert-info">
**Note:** From oVirt 3.3, network traffic for migrating virtual machines has been separated from network traffic for communication between oVirt and hosts. This prevents hosts from becoming non-responsive when importing or migrating virtual machines.

</div>
<div class="alert alert-info">
**Note:** A familiarity with the network concepts and their use is highly recommended when planning and setting up networking in a oVirt environment. This document does not describe the concepts, protocols, requirements or general usage of networking. It is recommended that you read your network hardware vendor's guides for more information on managing networking.

</div>
<div class="alert alert-info">
**Important:** Additional care must be taken when modifying the properties of the `rhevm` network. Incorrect changes to the properties of the `rhevm` network may cause hosts to become temporarily unreachable.

</div>
<div class="alert alert-info">
**Important:** If you plan to use oVirt nodes to provide any services, remember that the services will stop if the oVirt environment stops operating.

</div>
This applies to all services, but you should be fully aware of the hazards of running the following on oVirt:

*   Directory Services
*   DNS
*   Storage

### ⁠10.3. Creating Logical Networks

#### ⁠10.3.1. Creating a New Logical Network in a Data Center or Cluster

**Summary**

Create a logical network and define its use in a data center, or in clusters in a data center.

⁠

**Procedure 10.1. Creating a New Logical Network in a Data Center or Cluster**

1.  Use the **Data Centers** or **Clusters** resource tabs, tree mode, or the search function to find and select a data center or cluster in the results list.
2.  Click the **Logical Networks** tab of the details pane to list the existing logical networks.
3.  From the **Data Centers** details pane, click **New** to open the **New Logical Network** window. From the **Clusters** details pane, click **Add Network** to open the **New Logical Network** window.
4.  Enter a **Name**, **Description** and **Comment** for the logical network.
5.  In the **Export** section, select the **Create on external provider** check box to create the logical network on an external provider. Select the external provider from the **External Provider** drop-down menu.
6.  In the **Network Parameters** section, select the **Enable VLAN tagging**, **VM network** and **Override MTU** to enable these options.
7.  Enter a new label or select an existing label for the logical network in the **Network Label** text field.
8.  From the **Cluster** tab, select the clusters to which the network will be assigned. You can also specify whether the logical network will be a required network.
9.  If the **Create on external provider** check box is selected, the **Subnet** tab will be visible. From the **Subnet** tab enter a **Name**, **CIDR** and select an **IP Version** for the subnet that the logical network will provide.
10. From the **Profiles** tab, add vNIC profiles to the logical network as required.
11. Click **OK**.

**Result**

You have defined a logical network as a resource required by a cluster or clusters in the data center. If you entered a label for the logical network, it will be automatically added to all host network interfaces with that label.

<div class="alert alert-info">
**Note:** When creating a new logical network or making changes to an existing logical network that is used as a display network, any running virtual machines that use that network must be rebooted before the network becomes available or the changes are applied.

</div>
### ⁠10.4. Editing Logical Networks

#### ⁠10.4.1. Editing Host Network Interfaces and Assigning Logical Networks to Hosts

**Summary**

You can change the settings of physical host network interfaces, move the management network from one physical host network interface to another, and assign logical networks to physical host network interfaces.

<div class="alert alert-info">
**Important:** You cannot assign logical networks offered by external providers to physical host network interfaces; such networks are dynamically assigned to hosts as they are required by virtual machines.

</div>
⁠

**Procedure 10.2. Editing Host Network Interfaces and Assigning Logical Networks to Hosts**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results.
2.  Click the **Network Interfaces** tab in the details pane.
3.  Click the **Setup Host Networks** button to open the **Setup Host Networks** window.
    ⁠

    ![The Setup Host Networks window](images/4768.png "The Setup Host Networks window")

    **Figure 10.1. The Setup Host Networks window**

4.  Attach a logical network to a physical host network interface by selecting and dragging the logical network into the **Assigned Logical Networks** area next to the physical host network interface. Alternatively, right-click the logical network and select a network interface from the drop-down menu.
5.  Configure the logical network:
    1.  Hover your cursor over an assigned logical network and click the pencil icon to open the **Edit Management Network** window.
    2.  Select a **Boot Protocol** from:
        -   **None**,
        -   **DHCP**, or
        -   **Static**. If you selected **Static**, enter the **IP**, **Subnet Mask**, and the **Gateway**.

    3.  Click **OK**.
    4.  If your logical network definition is not synchronized with the network configuration on the host, select the **Sync network** check box.

6.  Select the **Verify connectivity between Host and Engine** check box to check network connectivity; this action will only work if the host is in maintenance mode.
7.  Select the **Save network configuration** check box to make the changes persistent when the environment is rebooted.
8.  Click **OK**.

**Result**

You have assigned logical networks to and configured a physical host network interface.

<div class="alert alert-info">
**Note:** If not all network interface cards for the host are displayed, click the **Refresh Capabilities** button to update the list of network interface cards available for that host.

</div>
#### ⁠10.4.2. Logical Network General Settings Explained

The table below describes the settings for the **General** tab of the **New Logical Network** and **Edit Logical Network** window.

⁠

**Table 10.1. New Logical Network and Edit Logical Network Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field Name</p></th>
<th align="left"><p>Description</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Name</strong></p></td>
<td align="left"><p>The name of the logical network. This text field has a 15-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Description</strong></p></td>
<td align="left"><p>The description of the logical network. This text field has a 40-character limit.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Comment</strong></p></td>
<td align="left"><p>A field for adding plain text, human-readable comments regarding the logical network.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Create on external provider</strong></p></td>
<td align="left"><p>Allows you to create the logical network to an OpenStack Networking instance that has been added to oVirt as an external provider. <strong>External Provider</strong> - Allows you to select the external provider on which the logical network will be created.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Enable VLAN tagging</strong></p></td>
<td align="left"><p>VLAN tagging is a security feature that gives all network traffic carried on the logical network a special characteristic. VLAN-tagged traffic cannot be read by interfaces that do not also have that characteristic. Use of VLANs on logical networks also allows a single network interface to be associated with multiple, differently VLAN-tagged logical networks. Enter a numeric value in the text entry field if VLAN tagging is enabled.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>VM Network</strong></p></td>
<td align="left"><p>Select this option if only virtual machines use this network. If the network is used for traffic that does not involve virtual machines, such as storage communications, do not select this check box.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Override MTU</strong></p></td>
<td align="left"><p>Set a custom maximum transmission unit for the logical network. You can use this to match the maximum transmission unit supported by your new logical network to the maximum transmission unit supported by the hardware it interfaces with. Enter a numeric value in the text entry field if <strong>Override MTU</strong> is selected.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Network Label</strong></p></td>
<td align="left"><p>Allows you to specify a new label for the network or select from a existing labels already attached to host network interfaces. If you select an existing label, the logical network will be automatically assigned to all host network interfaces with that label.</p></td>
</tr>
</tbody>
</table>

#### ⁠10.4.3. Editing a Logical Network

**Summary**

Edit the settings of a logical network.

⁠

**Procedure 10.3. Editing a Logical Network**

1.  Use the **Data Centers** resource tab, tree mode, or the search function to find and select the data center of the logical network in the results list.
2.  Click the **Logical Networks** tab in the details pane to list the logical networks in the data center.
3.  Select a logical network and click **Edit** to open the **Edit Logical Network** window.
4.  Edit the necessary settings.
5.  Click **OK** to save the changes.

**Result**

You have updated the settings of your logical network.

<div class="alert alert-info">
**Note:** Multi-host network configuration is available on data centers with 3.1-or-higher compatibility, and automatically applies updated network settings to all of the hosts within the data center to which the network is assigned. Changes can only be applied when virtual machines using the network are down. You cannot rename a logical network that is already configured on a host. You cannot disable the **VM Network** option while virtual machines or templates using that network are running.

</div>
#### ⁠10.4.4. Explanation of Settings in the Manage Networks Window

The table below describes the settings for the **Manage Networks** window.

⁠

**Table 10.2. Manage Networks Settings**

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"><p>Field</p></th>
<th align="left"><p>Description/Action</p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p><strong>Assign</strong></p></td>
<td align="left"><p>Assigns the logical network to all hosts in the cluster.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Required</strong></p></td>
<td align="left"><p>A Network marked &quot;required&quot; must remain operational in order for the hosts associated with it to function properly. If a required network ceases to function, any hosts associated with it become non-operational.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>VM Network</strong></p></td>
<td align="left"><p>A logical network marked &quot;VM Network&quot; carries network traffic relevant to the virtual machine network.</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong>Display Network</strong></p></td>
<td align="left"><p>A logical network marked &quot;Display Network&quot; carries network traffic relevant to SPICE and to the virtual network controller.</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong>Migration Network</strong></p></td>
<td align="left"><p>A logical network marked &quot;Migration Network&quot; carries virtual machine and storage migration traffic.</p></td>
</tr>
</tbody>
</table>

#### ⁠10.4.5. Using the Networks Tab

The **Networks** resource tab provides a central location for users to perform network-related operations and search for networks based on each network's property or association with other resources.

All networks in the oVirt environment display in the results list of the **Networks** tab. The **New**, **Edit** and **Remove** buttons allow you to create, change the properties of, and delete logical networks within data centers.

Click on each network name and use the **Clusters**, **Hosts**, **Virtual Machines**, **Templates**, and **Permissions** tabs in the details pane to perform functions including:

*   Attaching or detaching the networks to clusters and hosts
*   Removing network interfaces from virtual machines and templates
*   Adding and removing permissions for users to access and manage networks

These functions are also accessible through each individual resource tab.

### ⁠10.5. Removing Logical Networks

#### ⁠10.5.1. Removing a Logical Network

**Summary**

Remove a logical network from oVirt.

⁠

**Procedure 10.4. Removing Logical Networks**

1.  Use the **Data Centers** resource tab, tree mode, or the search function to find and select the data center of the logical network in the results list.
2.  Click the **Logical Networks** tab in the details pane to list the logical networks in the data center.
3.  Select a logical network and click **Remove** to open the **Remove Logical Network(s)** window.
4.  Optionally, select the **Remove external network(s) from the provider(s) as well** check box to remove the logical network both from oVirt and from the external provider if the network is provided by an external provider.
5.  Click **OK**.

**Result**

The logical network is removed from oVirt and is no longer available. If the logical network was provided by an external provider and you elected to remove the logical network from that external provider, it is removed from the external provider and is no longer available on that external provider as well.

## ⁠Chapter 11. Configuring Storage

### ⁠11.1. Workflow Progress - Storage Setup

![](images/1197.png "images/1197.png")

### ⁠11.2. Introduction to Storage in oVirt

oVirt uses a centralized storage system for virtual machine disk images, ISO files and snapshots. Storage networking can be implemented using:

*   Network File System (NFS)
*   GlusterFS exports
*   Other POSIX compliant file systems
*   Internet Small Computer System Interface (iSCSI)
*   Local storage attached directly to the virtualization hosts
*   Fibre Channel Protocol (FCP)
*   Parallel NFS (pNFS)

Setting up storage is a prerequisite for a new data center because a data center cannot be initialized unless storage domains are attached and activated.

As a oVirt system administrator, you need to create, configure, attach and maintain storage for the virtualized enterprise. You should be familiar with the storage types and their use. Read your storage array vendor's guides, and refer to the *Red Hat Enterprise Linux Storage Administration Guide* for more information on the concepts, protocols, requirements or general usage of storage.

The oVirt platform enables you to assign and manage storage using the Administration Portal's **Storage** tab. The **Storage** results list displays all the storage domains, and the details pane shows general information about the domain.

oVirt platform has three types of storage domains:

*   **Data Domain:** A data domain holds the virtual hard disks and OVF files of all the virtual machines and templates in a data center. In addition, snapshots of the virtual machines are also stored in the data domain. The data domain cannot be shared across data centers. Storage domains of multiple types (iSCSI, NFS, FC, POSIX, and Gluster) can be added to the same data center, provided they are all shared, rather than local, domains. You must attach a data domain to a data center before you can attach domains of other types to it.
*   **ISO Domain:** ISO domains store ISO files (or logical CDs) used to install and boot operating systems and applications for the virtual machines. An ISO domain removes the data center's need for physical media. An ISO domain can be shared across different data centers.
*   **Export Domain:** Export domains are temporary storage repositories that are used to copy and move images between data centers and oVirt environments. Export domains can be used to backup virtual machines. An export domain can be moved between data centers, however, it can only be active in one data center at a time.
    **Important**

    Support for export storage domains backed by storage on anything other than NFS is being deprecated. While existing export storage domains imported from oVirt 2.2 environments remain supported new export storage domains must be created on NFS storage.

Only commence configuring and attaching storage for your oVirt environment once you have determined the storage needs of your data center(s).

<div class="alert alert-info">
**Important:** To add storage domains you must be able to successfully access the Administration Portal, and there must be at least one host connected with a status of **Up**.

</div>
### ⁠11.3. Preparing NFS Storage

**Summary**

These steps must be taken to prepare an NFS file share on a server running Red Hat Enterprise Linux 6 for use with oVirt.

⁠

**Procedure 11.1. Preparing NFS Storage**

1.  **Install nfs-utils**
    NFS functionality is provided by the nfs-utils package. Before file shares can be created, check that the package is installed by querying the RPM database for the system:

        $ rpm -qi nfs-utils

    If the nfs-utils package is installed then the package information will be displayed. If no output is displayed then the package is not currently installed. Install it using `yum` while logged in as the `root` user:

        # yum install nfs-utils

2.  **Configure Boot Scripts**
    To ensure that NFS shares are always available when the system is operational both the `nfs` and `rpcbind` services must start at boot time. Use the `chkconfig` command while logged in as `root` to modify the boot scripts.

        # chkconfig --add rpcbind
        # chkconfig --add nfs
        # chkconfig rpcbind on
        # chkconfig nfs on

    Once the boot script configuration has been done, start the services for the first time.

        # service rpcbind start
        # service nfs start

3.  **Create Directory**
    Create the directory you wish to share using NFS.

        # mkdir /exports/iso

    Replace */exports/iso* with the name, and path of the directory you wish to use.

4.  **Export Directory**
    To be accessible over the network using NFS the directory must be exported. NFS exports are controlled using the `/etc/exports` configuration file. Each export path appears on a separate line followed by a tab character and any additional NFS options. Exports to be attached to oVirt must have the read, and write, options set.

    To grant read, and write access to `/exports/iso` using NFS for example you add the following line to the `/etc/exports` file.

        /exports/iso       *(rw)

    Again, replace */exports/iso* with the name, and path of the directory you wish to use.

5.  **Reload NFS Configuration**
    For the changes to the `/etc/exports` file to take effect the service must be told to reload the configuration. To force the service to reload the configuration run the following command as `root`:

        # service nfs reload

6.  **Set Permissions**
    The NFS export directory must be configured for read write access and must be owned by vdsm:kvm. If these users do not exist on your external NFS server use the following command, assuming that `/exports/iso` is the directory to be used as an NFS share.

        # chown -R 36:36 /exports/iso

    The permissions on the directory must be set to allow read and write access to the owner, and read and execute access to the group and other users. The owner will also have execute access to the directory. The permissions are set using the `chmod` command. The following command arguments set the required permissions on the `/exports/iso` directory.

        # chmod 0755 /exports/iso

**Result**

The NFS file share has been created, and is ready to be attached by oVirt.

### ⁠11.4. Attaching NFS Storage

**Summary**

An NFS type **Storage Domain** is a mounted NFS share that is attached to a data center. It is used to provide storage for virtualized guest images and ISO boot media. Once NFS storage has been exported it must be attached to oVirt using the Administration Portal.

NFS data domains can be added to NFS data centers. You can add NFS, ISO, and export storage domains to data centers of any type.

⁠

**Procedure 11.2. Attaching NFS Storage**

1.  Click the **Storage** resource tab to list the existing storage domains.
2.  Click **New Domain** to open the **New Domain** window.
    ⁠

    ![NFS Storage](images/1097.png "NFS Storage")

    **Figure 11.1. NFS Storage**

3.  Enter the **Name** of the storage domain.
4.  Select the **Data Center**, **Domain Function / Storage Type**, and **Use Host** from the drop-down menus. If applicable, select the **Format** from the drop-down menu.
5.  Enter the **Export Path** to be used for the storage domain. The export path should be in the format of `192.168.0.10:/data or domain.example.com:/data`
6.  Click **Advanced Parameters** to enable further configurable settings. It is recommended that the values of these parameters not be modified.
    **Important**

    All communication to the storage domain is from the selected host and not directly from oVirt. At least one active host must be attached to the chosen Data Center before the storage is configured.

7.  Click **OK** to create the storage domain and close the window.

**Result**

The new NFS data domain is displayed on the **Storage** tab with a status of `Locked` while the disk prepares. It is automatically attached to the data center upon completion.

### ⁠11.5. Adding iSCSI Storage

**Summary**

oVirt platform supports iSCSI storage by creating a storage domain from a volume group made of pre-existing LUNs. Neither volume groups nor LUNs can be attached to more than one storage domain at a time.

For information regarding the setup and configuration of iSCSI on Red Hat Enterprise Linux, see the *Red Hat Enterprise Linux Storage Administration Guide*.

<div class="alert alert-info">
**Note:** You can only add an iSCSI storage domain to a data center that is set up for iSCSI storage type.

</div>
⁠

**Procedure 11.3. Adding iSCSI Storage**

1.  Click the **Storage** resource tab to list the existing storage domains in the results list.
2.  Click the **New Domain** button to open the **New Domain** window.
3.  Enter the **Name** of the new storage domain.
    ⁠

    ![New iSCSI Domain](images/5590.png "New iSCSI Domain")

    **Figure 11.2. New iSCSI Domain**

4.  Use the **Data Center** drop-down menu to select an iSCSI data center. If you do not yet have an appropriate iSCSI data center, select `(none)`.
5.  Use the drop-down menus to select the **Domain Function / Storage Type** and the **Format**. The storage domain types that are not compatible with the chosen data center are not available.
6.  Select an active host in the **Use Host** field. If this is not the first data domain in a data center, you must select the data center's SPM host.
    **Important**

    All communication to the storage domain is via the selected host and not directly from oVirt. At least one active host must exist in the system, and be attached to the chosen data center, before the storage is configured.

7.  oVirt is able to map either iSCSI targets to LUNs, or LUNs to iSCSI targets. The **New Domain** window automatically displays known targets with unused LUNs when iSCSI is selected as the storage type. If the target that you are adding storage from is not listed then you can use target discovery to find it, otherwise proceed to the next step.
    **iSCSI Target Discovery**

    1.  Click **Discover Targets** to enable target discovery options. When targets have been discovered and logged in to, the **New Domain** window automatically displays targets with LUNs unused by the environment.
        **Note**

        LUNs used externally to the environment are also displayed.

        You can use the **Discover Targets** options to add LUNs on many targets, or multiple paths to the same LUNs.

    2.  Enter the fully qualified domain name or IP address of the iSCSI host in the **Address** field.
    3.  Enter the port to connect to the host on when browsing for targets in the **Port** field. The default is `3260`.
    4.  If the Challenge Handshake Authentication Protocol (CHAP) is being used to secure the storage, select the **User Authentication** check box. Enter the **CHAP user name** and **CHAP password**.
    5.  Click the **Discover** button.
    6.  Select the target to use from the discovery results and click the **Login** button. Alternatively, click the **Login All** to log in to all of the discovered targets.

8.  Click the **+** button next to the desired target. This will expand the entry and display all unused LUNs attached to the target.
9.  Select the check box for each LUN that you are using to create the storage domain.
10. Click **OK** to create the storage domain and close the window.

**Result**

The new iSCSI storage domain displays on the storage tab. This can take up to 5 minutes.

### ⁠11.6. Adding FCP Storage

**Summary**

oVirt platform supports SAN storage by creating a storage domain from a volume group made of pre-existing LUNs. Neither volume groups nor LUNs can be attached to more than one storage domain at a time.

oVirt system administrators need a working knowledge of Storage Area Networks (SAN) concepts. SAN usually uses Fibre Channel Protocol (FCP) for traffic between hosts and shared external storage. For this reason, SAN may occasionally be referred to as FCP storage.

For information regarding the setup and configuration of FCP or multipathing on Red Hat Enterprise Linux, please refer to the *Storage Administration Guide* and *DM Multipath Guide*.

<div class="alert alert-info">
**Note:** You can only add an FCP storage domain to a data center that is set up for FCP storage type.

</div>
⁠

**Procedure 11.4. Adding FCP Storage**

1.  Click the **Storage** resource tab to list all storage domains in the virtualized environment.
2.  Click **New Domain** to open the **New Domain** window.
3.  Enter the **Name** of the storage domain
    ⁠

    ![Adding FCP Storage](images/5591.png "Adding FCP Storage")

    **Figure 11.3. Adding FCP Storage**

4.  Use the **Data Center** drop-down menu to select an FCP data center. If you do not yet have an appropriate FCP data center, select `(none)`.
5.  Use the drop-down menus to select the **Domain Function / Storage Type** and the **Format**. The storage domain types that are not compatible with the chosen data center are not available.
6.  Select an active host in the **Use Host** field. If this is not the first data domain in a data center, you must select the data center's SPM host.
    **Important**

    All communication to the storage domain is via the selected host and not directly from oVirt. At least one active host must exist in the system, and be attached to the chosen data center, before the storage is configured.

7.  The **New Domain** window automatically displays known targets with unused LUNs when **Data / Fibre Channel** is selected as the storage type. Select the **LUN ID** check box to select all of the available LUNs.
8.  Click **OK** to create the storage domain and close the window.

**Result**

The new FCP data domain displays on the **Storage** tab. It will remain with a `Locked` status while it is being prepared for use. When ready, it is automatically attached to the data center.

### ⁠11.7. Preparing Local Storage

**Summary**

A local storage domain can be set up on a host. When you set up host to use local storage, the host automatically gets added to a new data center and cluster that no other hosts can be added to. Multiple host clusters require that all hosts have access to all storage domains, which is not possible with local storage. Virtual machines created in a single host cluster cannot be migrated, fenced or scheduled.

<div class="alert alert-info">
**Important:** On oVirt Nodes the only path permitted for use as local storage is `/data/images`. This directory already exists with the correct permissions on Hypervisor installations. The steps in this procedure are only required when preparing local storage on Red Hat Enterprise Linux virtualization hosts.

</div>
⁠

**Procedure 11.5. Preparing Local Storage**

1.  On the virtualization host, create the directory to be used for the local storage.
        # mkdir -p /data/images

2.  Ensure that the directory has permissions allowing read/write access to the `vdsm` user (UID 36) and `kvm` group (GID 36).
        # chown 36:36 /data /data/images

        # chmod 0755 /data /data/images

**Result**

Your local storage is ready to be added to the oVirt environment.

### ⁠11.8. Adding Local Storage

**Summary**

Storage local to your host has been prepared. Now use oVirt to add it to the host.

Adding local storage to a host in this manner causes the host to be put in a new data center and cluster. The local storage configuration window combines the creation of a data center, a cluster, and storage into a single process.

⁠

**Procedure 11.6. Adding Local Storage**

1.  Use the **Hosts** resource tab, tree mode, or the search function to find and select the host in the results list.
2.  Click **Maintenance** to open the **Maintenance Host(s)** confirmation window.
3.  Click **OK** to initiate maintenance mode.
4.  Click **Configure Local Storage** to open the **Configure Local Storage** window.
    ⁠

    ![Configure Local Storage Window](images/5592.png "Configure Local Storage Window")

    **Figure 11.4. Configure Local Storage Window**

5.  Click the **Edit** buttons next to the **Data Center**, **Cluster**, and **Storage** fields to configure and name the local storage domain.
6.  Set the path to your local storage in the text entry field.
7.  If applicable, select the **Optimization** tab to configure the memory optimization policy for the new local storage cluster.
8.  Click **OK** to save the settings and close the window.

**Result**

Your host comes online in a data center of its own.

### ⁠11.9. POSIX Compliant File System Storage in oVirt

oVirt 3.1 and higher supports the use of POSIX (native) file systems for storage. POSIX file system support allows you to mount file systems using the same mount options that you would normally use when mounting them manually from the command line. This functionality is intended to allow access to storage not exposed using NFS, iSCSI, or FCP.

Any POSIX compliant filesystem used as a storage domain in oVirt **MUST** support sparse files and direct I/O. The Common Internet File System (CIFS), for example, does not support direct I/O, making it incompatible with oVirt.

<div class="alert alert-info">
**Important:** Do *not* mount NFS storage by creating a POSIX compliant file system Storage Domain. Always create an NFS Storage Domain instead.

</div>
### ⁠11.10. Attaching POSIX Compliant File System Storage

**Summary**

You want to use a POSIX compliant file system that is not exposed using NFS, iSCSI, or FCP as a storage domain.

⁠

**Procedure 11.7. Attaching POSIX Compliant File System Storage**

1.  Click the **Storage** resource tab to list the existing storage domains in the results list.
2.  Click **New Domain** to open the **New Domain** window.
    ⁠

    ![POSIX Storage](images/5597.png "POSIX Storage")

    **Figure 11.5. POSIX Storage**

3.  Enter the **Name** for the storage domain.
4.  Select the **Data Center** to be associated with the storage domain. The Data Center selected must be of type **POSIX (POSIX compliant FS)**. Alternatively, select `(none)`.
5.  Select `Data / POSIX compliant FS` from the **Domain Function / Storage Type** drop-down menu. If applicable, select the **Format** from the drop-down menu.
6.  Select a host from the **Use Host** drop-down menu. Only hosts within the selected data center will be listed. The host that you select will be used to connect the storage domain.
7.  Enter the **Path** to the POSIX file system, as you would normally provide it to the `mount` command.
8.  Enter the **VFS Type**, as you would normally provide it to the `mount` command using the *`-t`* argument. See `man mount` for a list of valid VFS types.
9.  Enter additional **Mount Options**, as you would normally provide them to the `mount` command using the *`-o`* argument. The mount options should be provided in a comma-separated list. See `man mount` for a list of valid mount options.
10. Click **OK** to attach the new Storage Domain and close the window.

**Result**

You have used a supported mechanism to attach an unsupported file system as a storage domain.

### ⁠11.11. Enabling Gluster Processes on Red Hat Storage Nodes

**Summary**

This procedure explains how to allow Gluster processes on Red Hat Storage Nodes.

1.  In the Navigation Pane, select the **Clusters** tab.
2.  Select **New**.
3.  Select the "Enable Gluster Service" radio button. Provide the address, SSH fingerprint, and password as necessary. The address and password fields can be filled in only when the **Import existing Gluster configuration** check box is selected.
    ⁠

    ![Description](images/4539.png "Description")

    **Figure 11.6. Selecting the "Enable Gluster Service" Radio Button**

4.  Click **OK**.

**Result**

It is now possible to add Red Hat Storage nodes to the Gluster cluster, and to mount Gluster volumes as storage domains. **iptables** rules no longer block storage domains from being added to the cluster.

### ⁠11.12. Populating the ISO Storage Domain

**Summary**

An ISO storage domain is attached to a data center, ISO images must be uploaded to it. oVirt provides an ISO uploader tool that ensures that the images are uploaded into the correct directory path, with the correct user permissions.

The creation of ISO images from physical media is not described in this document. It is assumed that you have access to the images required for your environment.

⁠

**Procedure 11.8. Populating the ISO Storage Domain**

1.  Copy the required ISO image to a temporary directory on the system running oVirt.
2.  Log in to the system running oVirt as the `root` user.
3.  Use the `engine-iso-uploader` command to upload the ISO image. This action will take some time, the amount of time varies depending on the size of the image being uploaded and available network bandwidth.
    ⁠

    **Example 11.1. ISO Uploader Usage**

    In this example the ISO image `RHEL6.iso` is uploaded to the ISO domain called `ISODomain` using NFS. The command will prompt for an administrative user name and password. The user name must be provided in the form *user name*@*domain*.

        # engine-iso-uploader --iso-domain=ISODomain upload RHEL6.iso

**Result**

The ISO image is uploaded and appears in the ISO storage domain specified. It is also available in the list of available boot media when creating virtual machines in the data center which the storage domain is attached to.

### ⁠11.13. VirtIO and Guest Tool Image Files

The virtio-win ISO and Virtual Floppy Drive (VFD) images, which contain the VirtIO drivers for Windows virtual machines, and the rhev-tools-setup ISO, which contains the oVirt Guest Tools for Windows virtual machines, are copied to an ISO storage domain upon installation and configuration of the domain.

These image files provide software that can be installed on virtual machines to improve performance and usability. The most recent virtio-win and rhev-tools-setup files can be accessed via the following symbolic links on the file system of oVirt:

*   `/usr/share/virtio-win/virtio-win.iso`
*   `/usr/share/virtio-win/virtio-win_x86.vfd`
*   `/usr/share/virtio-win/virtio-win_amd64.vfd`
*   `/usr/share/rhev-guest-tools-iso/rhev-tools-setup.iso`

These image files must be manually uploaded to ISO storage domains that were not created locally by the installation process. Use the `engine-iso-uploader` command to upload these images to your ISO storage domain. Once uploaded, the image files can be attached to and used by virtual machines.

### ⁠11.14. Uploading the VirtIO and Guest Tool Image Files to an ISO Storage Domain

The example below demonstrates the command to upload the `virtio-win.iso`, `virtio-win_x86.vfd`, `virtio-win_amd64.vfd`, and `rhev-tools-setup.iso` image files to the `ISODomain`.

⁠

**Example 11.2. Uploading the VirtIO and Guest Tool Image Files**

    # engine-iso-uploader --iso-domain=[ISODomain] upload /usr/share/virtio-win/virtio-win.iso /usr/share/virtio-win/virtio-win_x86.vfd /usr/share/virtio-win/virtio-win_amd64.vfd /usr/share/rhev-guest-tools-iso/rhev-tools-setup.iso

[Compiler Glossary](#idm268262237872)

⁠

**Topic ID 30615**

*   INFO: Upgrading the Self-Hosted Engine
*   INFO: [Topic URL](http://skynet.usersys.redhat.com:8080/pressgang-ccms-ui/#SearchResultsAndTopicView;query;topicIds=30615)
*   ERROR: This topic has invalid Injection Points. The processed XML is
        &lt;section id=&quot;Upgrading_the_Self-Hosted_Engine&quot; remap=&quot;TID_30615&quot;&gt;
            &lt;title&gt;Upgrading the Self-Hosted Engine&lt;/title&gt;
            &lt;formalpara&gt;
                &lt;title&gt;Summary&lt;/title&gt;
                &lt;para&gt;
                    Upgrade your oVirt hosted-engine environment from version 3.3 to 3.4.
                &lt;/para&gt;
            &lt;/formalpara&gt;
            &lt;para&gt;
                This procedure upgrades two hosts, referred to in this procedure as Host A and Host B, and a Manager virtual machine. For the purposes of this procedure, Host B is hosting oVirt virtual machine.
            &lt;/para&gt;
            &lt;para&gt;
                It is recommended that all hosts in the environment be upgraded at the same time, before oVirt virtual machine is upgraded and the &lt;guilabel&gt;Compatibility Version&lt;/guilabel&gt; of the cluster is updated to &lt;guilabel&gt;3.4&lt;/guilabel&gt;. This avoids any version 3.3 hosts from going into a &lt;guilabel&gt;Non Operational&lt;/guilabel&gt; state.
            &lt;/para&gt;
            &lt;para&gt;
                All commands in this procedure are as the &lt;literal&gt;root&lt;/literal&gt; user.
            &lt;/para&gt;
            &lt;procedure&gt;
                &lt;title&gt;Upgrading the Self-Hosted Engine&lt;/title&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Log into either host and set the maintenance mode to &lt;literal&gt;global&lt;/literal&gt; to disable the high-availability agents.
                    &lt;/para&gt;
                    &lt;screen&gt;# hosted-engine --set-maintenance --mode=global&lt;/screen&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Access oVirt Administration Portal. Select Host A and put it into maintenance mode by clicking the &lt;guibutton&gt;Maintenance&lt;/guibutton&gt; button.
                    &lt;/para&gt;
                    &lt;important&gt;
                        &lt;para&gt;
                            The host that you put into maintenance mode and upgrade must not be the host currently hosting oVirt virtual machine.
                        &lt;/para&gt;
                    &lt;/important&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Log into and update Host A.
                    &lt;/para&gt;
                    &lt;screen&gt;# yum update&lt;/screen&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Restart VDSM on Host A.
                    &lt;/para&gt;
                    &lt;screen&gt;# service vdsmd restart&lt;/screen&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Restart &lt;literal&gt;ovirt-ha-broker&lt;/literal&gt; and &lt;literal&gt;ovirt-ha-agent&lt;/literal&gt; on Host A.
                    &lt;/para&gt;
                    &lt;screen&gt;# service ovirt-ha-broker restart&lt;/screen&gt;
                    &lt;screen&gt;# service ovirt-ha-agent restart&lt;/screen&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Log into either host and turn off the hosted-engine maintenance mode so that oVirt virtual machine can migrate to the other host.
                    &lt;/para&gt;
                    &lt;screen&gt;# hosted-engine --set-maintenance --mode=none&lt;/screen&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Access oVirt Administration Portal. Select Host A and activate it by clicking the &lt;guibutton&gt;Activate&lt;/guibutton&gt; button.
                    &lt;/para&gt;
                &lt;/step&gt; 
                &lt;!--     &lt;step&gt;
                    &lt;para&gt;
                        Use the &lt;guilabel&gt;Hosts&lt;/guilabel&gt; resource tab to select Host B and put it into maintenance mode by clicking the &lt;guibutton&gt;Maintenance&lt;/guibutton&gt; button. oVirt virtual machine will migrate to Host A.
                    &lt;/para&gt;
                &lt;/step&gt; --&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Log into Host B and set the maintenance mode to &lt;literal&gt;global&lt;/literal&gt; to disable the high-availability agents. 
                        &lt;screen&gt;# hosted-engine --set-maintenance --mode=global&lt;/screen&gt;
                    &lt;/para&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Update Host B.
                    &lt;/para&gt;
                    &lt;screen&gt;# yum update&lt;/screen&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Restart VDSM on Host B.
                    &lt;/para&gt;
                    &lt;screen&gt;# service vdsmd restart&lt;/screen&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Restart &lt;literal&gt;ovirt-ha-broker&lt;/literal&gt; and &lt;literal&gt;ovirt-ha-agent&lt;/literal&gt; on Host B.
                    &lt;/para&gt;
                    &lt;screen&gt;# service ovirt-ha-broker restart&lt;/screen&gt;
                    &lt;screen&gt;# service ovirt-ha-agent restart&lt;/screen&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Turn off the hosted-engine maintenance mode on Host B.
                    &lt;/para&gt;
                    &lt;screen&gt;# hosted-engine --set-maintenance --mode=none&lt;/screen&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Access oVirt Administration Portal. Select Host B and activate it by clicking the &lt;guibutton&gt;Activate&lt;/guibutton&gt; button.
                    &lt;/para&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Log into oVirt virtual machine and update the engine as per the instructions in &lt;!-- Inject: 30126 --&gt;.
                    &lt;/para&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Access oVirt Administration Portal.
                    &lt;/para&gt;
                    &lt;stepalternatives&gt;
                        &lt;step&gt;
                            &lt;para&gt;
                                Select the &lt;guilabel&gt;Default&lt;/guilabel&gt; cluster and click &lt;guibutton&gt;Edit&lt;/guibutton&gt; to open the &lt;guilabel&gt;Edit Cluster&lt;/guilabel&gt; window.
                            &lt;/para&gt;
                        &lt;/step&gt;
                        &lt;step&gt;
                            &lt;para&gt;
                                Use the &lt;guilabel&gt;Compatibility Version&lt;/guilabel&gt; drop-down menu to select &lt;guilabel&gt;3.4&lt;/guilabel&gt;. Click &lt;guibutton&gt;OK&lt;/guibutton&gt; to save the change and close the window.
                            &lt;/para&gt;
                        &lt;/step&gt;
                    &lt;/stepalternatives&gt;
                &lt;/step&gt;
            &lt;/procedure&gt;
            &lt;formalpara&gt;
                &lt;title&gt;Result&lt;/title&gt;
                &lt;para&gt;
                    You have upgraded both the hosts and oVirt in your hosted-engine setup to oVirt 3.4.
                &lt;/para&gt;
            &lt;/formalpara&gt;
        &lt;/section&gt;

*   ERROR: Topic has referenced Topic/Level(s) 30126 in a custom injection point that was not included this book.

⁠

**Topic ID 25551**

*   INFO: Installing the Self-Hosted Engine
*   INFO: Assigned Writer: aburden Book: RHEV Administration Guide Book: RHEV Installation Guide
*   INFO: [Topic URL](http://skynet.usersys.redhat.com:8080/pressgang-ccms-ui/#SearchResultsAndTopicView;query;topicIds=25551)
*   ERROR: Topic has referenced Topic/Level(s) 10008,10007 in a custom injection point that was not included this book.
*   ERROR: This topic has invalid Injection Points. The processed XML is
        &lt;section id=&quot;Installing_the_Self-Hosted_Engine&quot; remap=&quot;TID_25551&quot;&gt;
            &lt;title&gt;Installing the Self-Hosted Engine&lt;/title&gt;
            &lt;formalpara&gt;
                &lt;title&gt;Summary&lt;/title&gt;
                &lt;para&gt;
                    Install a oVirt environment that takes advantage of the self-hosted engine feature, in which the engine is installed on a virtual machine within the environment itself.
                &lt;/para&gt;
            &lt;/formalpara&gt;
            &lt;para&gt;
                You must be subscribed to the appropriate Red Hat Network channels to install the packages. For Subscription Manager, these channels are: 
                &lt;itemizedlist&gt;
                    &lt;listitem&gt;
                        &lt;para&gt; 
                            &lt;literal&gt;rhel-6-server-rpms&lt;/literal&gt;
                        &lt;/para&gt;
                    &lt;/listitem&gt;
                    &lt;listitem&gt;
                        &lt;para&gt; 
                            &lt;literal&gt;rhel-6-server-supplementary-rpms&lt;/literal&gt;
                        &lt;/para&gt;
                    &lt;/listitem&gt;
                    &lt;listitem&gt;
                        &lt;para&gt; 
                            &lt;literal&gt;rhel-6-server-rhevm-3.4-rpms&lt;/literal&gt;
                        &lt;/para&gt;
                    &lt;/listitem&gt;
                    &lt;listitem&gt;
                        &lt;para&gt; 
                            &lt;literal&gt;jb-eap-6-for-rhel-6-server-rpms&lt;/literal&gt;
                        &lt;/para&gt;
                    &lt;/listitem&gt;
                    &lt;listitem&gt;
                        &lt;para&gt; 
                            &lt;literal&gt;rhel-6-server-rhev-mgmt-agent-rpms&lt;/literal&gt;
                        &lt;/para&gt;
                    &lt;/listitem&gt;
                &lt;/itemizedlist&gt; For more information on subscribing to these channels using Subscription Manager, refer to &lt;!-- Inject: 10008 --&gt;.
            &lt;/para&gt;
            &lt;para&gt;
                For RHN Classic, these channels are: 
                &lt;itemizedlist&gt;
                    &lt;listitem&gt;
                        &lt;para&gt; 
                            &lt;literal&gt;rhel-x86_64-server-6&lt;/literal&gt;
                        &lt;/para&gt;
                    &lt;/listitem&gt;
                    &lt;listitem&gt;
                        &lt;para&gt; 
                            &lt;literal&gt;rhel-x86_64-server-supplementary-6&lt;/literal&gt;
                        &lt;/para&gt;
                    &lt;/listitem&gt;
                    &lt;listitem&gt;
                        &lt;para&gt; 
                            &lt;literal&gt;rhel-x86_64-server-6-rhevm-3.4&lt;/literal&gt;
                        &lt;/para&gt;
                    &lt;/listitem&gt;
                    &lt;listitem&gt;
                        &lt;para&gt; 
                            &lt;literal&gt;jbappplatform-6-x86_64-server-6-rpm&lt;/literal&gt;
                        &lt;/para&gt;
                    &lt;/listitem&gt;
                    &lt;listitem&gt;
                        &lt;para&gt; 
                            &lt;literal&gt;rhel-x86_64-rhev-mgmt-agent-6&lt;/literal&gt;
                        &lt;/para&gt;
                    &lt;/listitem&gt;
                &lt;/itemizedlist&gt; For more information on subscribing to these channels using RHN Classic, refer to &lt;!-- Inject: 10007 --&gt;.
            &lt;/para&gt;
            &lt;important&gt;
                &lt;para&gt;
                    While the &lt;package&gt;ovirt-hosted-engine-setup&lt;/package&gt; package is provided by oVirt channel and can be installed using the standard channels for oVirt, the &lt;package&gt;vdsm&lt;/package&gt; package is a dependency of the &lt;package&gt;ovirt-hosted-engine-setup&lt;/package&gt; package and is provided by the Red Hat Enterprise Virt Management Agent channel, which must be enabled. This channel is &lt;literal&gt;rhel-6-server-rhev-mgmt-agent-rpms&lt;/literal&gt; in Subscription Manager and &lt;literal&gt;rhel-x86_64-rhev-mgmt-agent-6&lt;/literal&gt; in &lt;acronym&gt;RHN&lt;/acronym&gt; Classic.
                &lt;/para&gt;
            &lt;/important&gt;
            &lt;para&gt;
                All steps in this procedure are to be conducted as the &lt;systemitem class=&quot;username&quot;&gt;root&lt;/systemitem&gt; user.
            &lt;/para&gt;
            &lt;procedure&gt;
                &lt;title&gt;Installing the Self-Hosted Engine&lt;/title&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Run the following command to ensure that the most up-to-date versions of all installed packages are in use:
                    &lt;/para&gt;
                    &lt;screen&gt;# yum upgrade&lt;/screen&gt;
                &lt;/step&gt;
                &lt;step&gt;
                    &lt;para&gt;
                        Run the following command to install the &lt;package&gt;ovirt-hosted-engine-setup&lt;/package&gt; package and dependencies:
                    &lt;/para&gt;
                    &lt;screen&gt;# yum install ovirt-hosted-engine-setup&lt;/screen&gt;
                &lt;/step&gt;
            &lt;/procedure&gt;
            &lt;formalpara&gt;
                &lt;title&gt;Result&lt;/title&gt;
                &lt;para&gt;
                    You have installed the &lt;package&gt;ovirt-hosted-engine-setup&lt;/package&gt; package and are ready to configure the self-hosted engine.
                &lt;/para&gt;
            &lt;/formalpara&gt;
        &lt;/section&gt;

### ⁠Compiler Glossary

"... is possibly an invalid custom Injection Point."  
\* The XML comment mentioned has been identified as a possible custom Injection Point, that is incorrectly referenced.  

\* To fix this error please ensure that the type is valid, a colon is used to separate the IDs from the type and only topic IDs are used in the ID list.
"This topic contains an invalid element that can't be converted into a DOM Element."  
\* The topic XML contains invalid elements that cannot be successfully converted in DOM elements.  

\* To fix this error please remove or correct any invalid XML elements or entities.
"This topic doesn't have well-formed xml."  
\* The topic XML is not well-formed XML and maybe missing opening or closing element statements.  

\* To fix this error please ensure that all XML elements having an opening and closing statement and all XML reserved characters are represented as XML entities.
"This topic has invalid DocBook XML."  
\* The topic XML is not valid against the DocBook specification.  

\* To fix this error please ensure that all XML elements are valid DocBook elements . Also check to ensure all XML sub elements are valid for the root XML element.
"This topic has invalid Injection Points."  
\* The topic XML contains Injection Points that cannot be resolved into links.  

\* To fix this error please ensure that all the topics referred to by Injection Points are included in the build and/or have adequate relationships.
"This topic has no XML data"  
\* The topic doesn't have any XML Content to display.  

\* To fix this warning, open the topic URL and add some content.  

**Revision History**

Revision 1.0-1

Wed 25 Jun 2014

Lucy Bopf

**Andrew Burden**

      aburden@redhat.com

**Steve Gordon**

      sgordon@redhat.com

**Tim Hildred**

      thildred@redhat.com

**Cheryn Tan**

      chetan@redhat.com

## Legal Notice

Copyright © 2014 Red Hat, Inc.

This document is licensed by Red Hat under the [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/). If you distribute this document, or a modified version of it, you must provide attribution to Red Hat, Inc. and provide a link to the original. If the document is modified, all Red Hat trademarks must be removed.

Red Hat, as the licensor of this document, waives the right to enforce, and agrees not to assert, Section 4d of CC-BY-SA to the fullest extent permitted by applicable law.

Red Hat, Red Hat Enterprise Linux, the Shadowman logo, JBoss, MetaMatrix, Fedora, the Infinity Logo, and RHCE are trademarks of Red Hat, Inc., registered in the United States and other countries.

Linux® is the registered trademark of Linus Torvalds in the United States and other countries.

Java® is a registered trademark of Oracle and/or its affiliates.

XFS® is a trademark of Silicon Graphics International Corp. or its subsidiaries in the United States and/or other countries.

MySQL® is a registered trademark of MySQL AB in the United States, the European Union and other countries.

Node.js® is an official trademark of Joyent. Red Hat Software Collections is not formally related to or endorsed by the official Joyent Node.js open source or commercial project.

The OpenStack® Word Mark and OpenStack Logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.

All other trademarks are the property of their respective owners.

|------------------------------------------------------------------|
| Initial creation for oVirt Engine test build for Brian Proffitt. |

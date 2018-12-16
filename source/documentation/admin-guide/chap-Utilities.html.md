---
title: Utilities
---

# Chapter 18: Utilities

## The oVirt Engine Rename Tool

When the `engine-setup` command is run in a clean environment, the command generates a number of certificates and keys that use the fully qualified domain name of the Engine supplied during the setup process. If the fully qualified domain name of the Engine must be changed later on (for example, due to migration of the machine hosting the Engine to a different domain), the records of the fully qualified domain name must be updated to reflect the new name. The `ovirt-engine-rename` command automates this task.

The `ovirt-engine-rename` command updates records of the fully qualified domain name of the Engine in the following locations:

* /etc/ovirt-engine/engine.conf.d/10-setup-protocols.conf

* /etc/ovirt-engine/isouploader.conf.d/10-engine-setup.conf

* /etc/ovirt-engine/logcollector.conf.d/10-engine-setup.conf

* /etc/pki/ovirt-engine/cert.conf

* /etc/pki/ovirt-engine/cert.template

* /etc/pki/ovirt-engine/certs/apache.cer

* /etc/pki/ovirt-engine/keys/apache.key.nopass

* /etc/pki/ovirt-engine/keys/apache.p12

    **Warning:** While the `ovirt-engine-rename` command creates a new certificate for the web server on which the Engine runs, it does not affect the certificate for the engine or the certificate authority. Due to this, there is some risk involved in using the `ovirt-engine-rename` command, particularly in environments that have been upgraded from oVirt 3.2 and earlier. Therefore, changing the fully qualified domain name of the Engine by running `engine-cleanup` and `engine-setup` is recommended where possible.

### Syntax for the oVirt Engine Rename Command

The basic syntax for the `ovirt-engine-rename` command is:

    # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename

The command also accepts the following options:

`--newname=[new name]`
: Allows you to specify the new fully qualified domain name for the Engine without user interaction.

`--log=[file]`
: Allows you to specify the path and name of a file into which logs of the rename operation are to be written.

`--config=[file]`
: Allows you to specify the path and file name of a configuration file to load into the rename operation.

`--config-append=[file]`
: Allows you to specify the path and file name of a configuration file to append to the rename operation. This option can be used to specify the path and file name of an answer file.

`--generate-answer=[file]`
: Allows you to specify the path and file name of a file into which your answers to and the values changed by the `ovirt-engine-rename` command are recorded.

### Renaming the Engine with the oVirt Engine Rename Tool

You can use the `ovirt-engine-rename` command to update records of the fully qualified domain name of the Engine.

    **Important:** The `ovirt-engine-rename` command does not update SSL certificates, such as `imageio-proxy` or `websocket-proxy`. These must be updated manually, after running `ovirt-engine-rename`. See "Updating SSL Certificates" below.

The tool checks whether the Engine provides a local ISO or Data storage domain. If it does, the tool prompts the user to eject, shut down, or place into maintenance mode any virtual machine or storage domain connected to the storage before continuing with the operation. This ensures that virtual machines do not lose connectivity with their virtual disks, and prevents ISO storage domains from losing connectivity during the renaming process.

**Using the oVirt Engine Rename Tool**

1. Prepare all DNS and other relevant records for the new fully qualified domain name.

2. Update the DHCP server configuration if DHCP is used.

3. Update the host name on the Engine.

4. Run the following command:

        # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename

5. When prompted, press **Enter** to stop the engine service:

        During execution engine service will be stopped (OK, Cancel) [OK]:

6. When prompted, enter the new fully qualified domain name for the Engine:

        New fully qualified server name:[new name]

The `ovirt-engine-rename` command updates records of the fully qualified domain name of the Engine.

**Updating SSL Certificates**

Run the following commands after the `ovirt-engine-rename` command to update the SSL certificates:

    1. # names="websocket-proxy imageio-proxy"

    2. # subject="$(\
        openssl x509 \
        -in /etc/pki/ovirt-engine/certs/apache.cer \
        -noout \
        -subject | \
            sed \
                's;subject= \(.\*\);\1;'
      )"

    3. # . /usr/share/ovirt-engine/bin/engine-prolog.sh

    4. # for name in $names; do
        /usr/share/ovirt-engine/bin/pki-enroll-pkcs12.sh \
            --name="${name}" \
            --password=mypass \
            --subject="${subject}" \
            --keep-key \
            --san=DNS:"${ENGINE_FQDN}"
      done

## The Engine Configuration Tool

### The Engine Configuration Tool

The engine configuration tool is a command-line utility for configuring global settings for your oVirt environment. The tool interacts with a list of key-value mappings that are stored in the engine database, and allows you to retrieve and set the value of individual keys, and retrieve a list of all available configuration keys and values. Furthermore, different values can be stored for each configuration level in your oVirt environment.

    **Note:** Neither the oVirt Engine nor Wildfly/JBoss Application Platform need to be running to retrieve or set the value of a configuration key. Because the configuration key value-key mappings are stored in the engine database, they can be updated while the `postgresql` service is running. Changes are then applied when the `ovirt-engine` service is restarted.

### Syntax for the engine-config Command

You can run the engine configuration tool from the machine on which the oVirt Engine is installed. For detailed information on usage, print the help output for the command:

    # engine-config --help

**Common tasks**

* List available configuration keys

        # engine-config --list

* List available configuration values

        # engine-config --all

* Retrieve value of configuration key

        # engine-config --get [KEY_NAME]

  Replace `[KEY_NAME]` with the name of the preferred key to retrieve the value for the given version of the key. Use the `--cver` parameter to specify the configuration version of the value to be retrieved. If no version is provided, values for all existing versions are returned.

* Set value of configuration key

        # engine-config --set [KEY_NAME]=[KEY_VALUE] --cver=[VERSION]

  Replace `[KEY_NAME]` with the name of the specific key to set, and replace `[KEY_VALUE]` with the value to be set. You must specify the `[VERSION]` in environments with more than one configuration version.

* Restart the ovirt-engine service to load changes

  The `ovirt-engine` service needs to be restarted for your changes to take effect.

        # service ovirt-engine restart

## The USB Filter Editor

### Installing the USB Filter Editor

The USB Filter Editor is a Windows tool used to configure the **usbfilter.txt** policy file. The policy rules defined in this file allow or deny automatic pass-through of specific USB devices from client machines to virtual machines managed using the oVirt Engine. The policy file resides on the oVirt Engine in the following location: **/etc/ovirt-engine/usbfilter.txt** Changes to USB filter policies do not take effect unless the **ovirt-engine** service on the Red Hat Virtualization Manager server is restarted.

**Installing the USB Filter Editor**

1. On a Windows machine, launch the **USBFilterEditor.msi** installer.

2. Follow the steps of the installation wizard. Unless otherwise specified, the USB Filter Editor will be installed by default in either **C:\Program Files\RedHat\USB Filter Editor** or **C:\Program Files(x86)\RedHat\USB Filter Editor** depending on your version of Windows.

3. A USB Filter Editor shortcut icon is created on your desktop.

    **Important:** Use a Secure Copy (SCP) client to import and export filter policies from the oVirt Engine. A Secure Copy tool for Windows machines is WinSCP ([http://winscp.net](http://winscp.net)).

The default USB device policy provides virtual machines with basic access to USB devices; update the policy to allow the use of additional USB devices.

### The USB Filter Editor Interface

Double-click the USB Filter Editor shortcut icon on your desktop.

The **Red Hat USB Filter Editor** interface displays the **Class**, **Vendor**, **Product**, **Revision**, and **Action** for each USB device. Permitted USB devices are set to **Allow** in the **Action** column; prohibited devices are set to **Block**.

**USB Editor Fields**

| Name | Description |
|-
| **Class** | Type of USB device; for example, printers, mass storage controllers. |
| **Vendor** | The manufacturer of the selected type of device. |
| **Product** | The specific USB device model. |
| **Revision** | The revision of the product. |
| **Action** | Allow or block the specified device. |

The USB device policy rules are processed in their listed order. Use the **Up** and **Down** buttons to move rules higher or lower in the list. The universal **Block** rule needs to remain as the lowest entry to ensure all USB devices are denied unless explicitly allowed in the USB Filter Editor.

### Adding a USB Policy

Double-click the USB Filter Editor shortcut icon on your desktop to open the editor.

**Adding a USB Policy**

1. Click **Add**.

2. Use the **USB Class**, **Vendor ID**, **Product ID**, and **Revision** check boxes and lists to specify the device.

   Click the **Allow** button to permit virtual machines use of the USB device; click the **Block** button to prohibit the USB device from virtual machines.

   Click **OK** to add the selected filter rule to the list and close the window.

   **Adding a Device**

   The following is an example of how to add USB Class `Smartcard`, device `EP-1427X-2 Ethernet Adapter`, from manufacturer `Acer Communications & Multimedia` to the list of allowed devices.

    ![](/images/admin-guide/306.png)

3. Click **File** &rarr; **Save** to save the changes.

You have added a USB policy to the USB Filter Editor. USB filter policies need to be exported to the oVirt Engine to take effect.

### Removing a USB Policy

Double-click the USB Filter Editor shortcut icon on your desktop to open the editor.

**Removing a USB Policy**

1. Select the policy to be removed.

2. Click **Remove**. A message displays prompting you to confirm that you want to remove the policy.

3. Click **Yes** to confirm that you want to remove the policy.

4. Click **File** &rarr; **Save** to save the changes.

You have removed a USB policy from the USB Filter Editor. USB filter policies need to be exported to the oVirt Engine to take effect.

### Searching for USB Device Policies

Search for attached USB devices to either allow or block them in the USB Filter Editor.

Double-click the USB Filter Editor shortcut icon on your desktop to open the editor.

**Searching for USB Device Policies**

1. Click **Search**. The **Attached USB Devices** window displays a list of all the attached devices.

2. Select the device and click **Allow** or **Block** as appropriate. Double-click the selected device to close the window. A policy rule for the device is added to the list.

3. Use the **Up** and **Down** buttons to change the position of the new policy rule in the list.

4. Click **File** &rarr; **Save** to save the changes.

You have searched the attached USB devices. USB filter policies need to be exported to the oVirt Engine to take effect.

### Exporting a USB Policy

USB device policy changes need to be exported and uploaded to the oVirt Engine for the updated policy to take effect. Upload the policy and restart the **ovirt-engine** service.

Double-click the USB Filter Editor shortcut icon on your desktop to open the editor.

**Exporting a USB Policy**

1. Click **Export**; the **Save As** window opens.

2. Save the file with a file name of **usbfilter.txt**.

3. Using a Secure Copy client, such as WinSCP, upload the **usbfilter.txt** file to the server running oVirt Engine. The file must be placed in the following directory on the server:

        /etc/ovirt-engine/

4. As the **root** user on the server running oVirt Engine, restart the **ovirt-engine** service.

        # systemctl restart ovirt-engine.service

### Importing a USB Policy

An existing USB device policy must be downloaded and imported into the USB Filter Editor before you can edit it.

**Importing a USB Policy**

1. Using a Secure Copy client, such as WinSCP, upload the **usbfilter.txt** file to the server running oVirt Engine. The file must be placed in the following directory on the server:

        /etc/ovirt-engine/

2. Double-click the USB Filter Editor shortcut icon on your desktop to open the editor.

3. Click **Import** to open the **Open** window.

4. Open the **usbfilter.txt** file that was downloaded from the server.

## The Log Collector Tool

A log collection tool is included in the oVirt Engine. This allows you to easily collect relevant logs from across the oVirt environment when requesting support.

The log collection command is `ovirt-log-collector`. You are required to log in as the `root` user and provide the administration credentials for the oVirt environment. The `ovirt-log-collector -h` command displays usage information, including a list of all valid options for the `ovirt-log-collector` command.

### Syntax for the ovirt-log-collector Command

The basic syntax for the log collector command is:

    # ovirt-log-collector options  list all|clusters|datacenters
    # ovirt-log-collector options collect

The two supported modes of operation are `list` and `collect`.

* The `list` parameter lists either the hosts, clusters, or data centers attached to the oVirt Engine. You are able to filter the log collection based on the listed objects.

* The `collect` parameter performs log collection from the oVirt Engine. The collected logs are placed in an archive file under the **/tmp/logcollector** directory. The `ovirt-log-collector` command assigns each log a specific file name.

Unless another parameter is specified, the default action is to list the available hosts together with the data center and cluster to which they belong. You will be prompted to enter user names and passwords to retrieve certain logs.

There are numerous parameters to further refine the `ovirt-log-collector` command.

**General options**

`--version`
: Displays the version number of the command in use and returns to prompt.

`-h`, `--help`
: Displays command usage information and returns to prompt.

`--conf-file=PATH`
: Sets `PATH` as the configuration file the tool is to use.

`--local-tmp=PATH`
: Sets `PATH` as the directory in which logs are saved. The default directory is `/tmp/logcollector`.

`--ticket-number=TICKET`
: Sets `TICKET` as the ticket, or case number, to associate with the SOS report.

`--upload=FTP_SERVER`
: Sets `FTP_SERVER` as the destination for retrieved logs to be sent using FTP.

`--log-file=PATH`
: Sets `PATH` as the specific file name the command should use for the log output.

`--quiet`
: Sets quiet mode, reducing console output to a minimum. Quiet mode is off by default.

`-v`, `--verbose`
: Sets verbose mode, providing more console output. Verbose mode is off by default.

`--time-only`
: Displays only information about time differences between hosts, without generating a full SOS report.

**oVirt Engine Options**

These options filter the log collection and specify authentication details for the oVirt Engine.

These parameters can be combined for specific commands. For example, `ovirt-log-collector --user=admin@internal --cluster ClusterA,ClusterB --hosts "SalesHost"*` specifies the user as `admin@internal` and limits the log collection to only `SalesHost` hosts in clusters `A` and `B`.

`--no-hypervisors`
: Omits virtualization hosts from the log collection.

`--one-hypervisor-per-cluster`
: Collects the logs of one host (the SPM, if there is one) from each cluster.

`-u USER`, `--user=USER`
: Sets the user name for login. The `USER` is specified in the format `user@domain`, where `user` is the user name and `domain` is the directory services domain in use. The user must exist in directory services and be known to the oVirt Engine.

`-r FQDN`, `--rhevm=FQDN`
: Sets the fully qualified domain name of the oVirt Engine server from which to collect logs, where `FQDN` is replaced by the fully qualified domain name of the Engine. It is assumed that the log collector is being run on the same local host as the oVirt Engine; the default value is `localhost`.

`-c CLUSTER`, `--cluster=CLUSTER`
: Collects logs from the virtualization hosts in the nominated `CLUSTER` in addition to logs from the oVirt Engine. The cluster(s) for inclusion must be specified in a comma-separated list of cluster names or match patterns.

`-d DATACENTER`, `--data-center=DATACENTER`
: Collects logs from the virtualization hosts in the nominated `DATACENTER` in addition to logs from the oVirt Engine. The data center(s) for inclusion must be specified in a comma-separated list of data center names or match patterns.

`-H HOSTS_LIST`, `--hosts=HOSTS_LIST`
: Collects logs from the virtualization hosts in the nominated `HOSTS_LIST` in addition to logs from the oVirt Engine. The hosts for inclusion must be specified in a comma-separated list of host names, fully qualified domain names, or IP addresses. Match patterns are also valid.

**SSH Configuration**

`--ssh-port=PORT`
: Sets `PORT` as the port to use for SSH connections with virtualization hosts.

`-k KEYFILE`, `--key-file=KEYFILE`
: Sets `KEYFILE` as the public SSH key to be used for accessing the virtualization hosts.

`--max-connections=MAX_CONNECTIONS`
: Sets `MAX_CONNECTIONS` as the maximum concurrent SSH connections for logs from virtualization hosts. The default is `10`.

**PostgreSQL Database Options**

The database user name and database name must be specified, using the `pg-user` and `dbname` parameters, if they have been changed from the default values.

Use the `pg-dbhost` parameter if the database is not on the local host. Use the optional `pg-host-key` parameter to collect remote logs. The PostgreSQL SOS plugin must be installed on the database server for remote log collection to be successful.

`--no-postgresql`
: Disables collection of database. The log collector will connect to the oVirt Engine PostgreSQL database and include the data in the log report unless the `--no-postgresql` parameter is specified.

`--pg-user=USER`
: Sets `USER` as the user name to use for connections with the database server. The default is `postgres`.

`--pg-dbname=DBNAME`
: Sets `DBNAME` as the database name to use for connections with the database server. The default is `rhevm`.

`--pg-dbhost=DBHOST`
: Sets `DBHOST` as the host name for the database server. The default is `localhost`.

`--pg-host-key=KEYFILE`
: Sets `KEYFILE` as the public identity file (private key) for the database server. This value is not set by default; it is required only where the database does not exist on the local host.

### Basic Log Collector Usage

When the `ovirt-log-collector` command is run without specifying any additional parameters, its default behavior is to collect all logs from the oVirt Engine and its attached hosts. It will also collect database logs unless the `--no-postgresql` parameter is added. In the following example, log collector is run to collect all logs from the oVirt Engine and three attached hosts.

**Log Collector Usage**

    # ovirt-log-collector
    INFO: Gathering oVirt Engine information...
    INFO: Gathering PostgreSQL the oVirt Engine database and log files from localhost...
    Please provide REST API password for the admin@internal oVirt Engine user (CTRL+D to abort):
    About to collect information from 3 hypervisors. Continue? (Y/n):
    INFO: Gathering information from selected hypervisors...
    INFO: collecting information from 192.168.122.250
    INFO: collecting information from 192.168.122.251
    INFO: collecting information from 192.168.122.252
    INFO: finished collecting information from 192.168.122.250
    INFO: finished collecting information from 192.168.122.251
    INFO: finished collecting information from 192.168.122.252
    Creating compressed archive...
    INFO Log files have been collected and placed in /tmp/logcollector/sosreport-rhn-account-20110804121320-ce2a.tar.xz.
    The MD5 for this file is 6d741b78925998caff29020df2b2ce2a and its size is 26.7M

## The ISO Uploader Tool

    **Note:** The ISO Uploader tool has been deprecated. The oVirt Project recommends uploading ISO images to the data domain with the Administration Portal or with the REST API.

The ISO uploader is a tool for uploading ISO images to the ISO storage domain. It is installed as part of the oVirt Engine.

The ISO uploader command is `engine-iso-uploader`. You must log in as the `root` user and provide the administration credentials for the oVirt environment to use this command. The `engine-iso-uploader -h` command displays usage information, including a list of all valid options for the `engine-iso-uploader` command.

### Syntax for the engine-iso-uploader Command

The basic syntax for the ISO uploader command is:

    # engine-iso-uploader options list
    # engine-iso-uploader options upload file file file

The ISO uploader command supports two actions - `list` and `upload`.

* The `list` action lists the ISO storage domains to which ISO files can be uploaded. The oVirt Engine creates this list on the machine on which the Engine is installed during the installation process.

* The `upload` action uploads a single ISO file or multiple ISO files separated by spaces to the specified ISO storage domain. NFS is used by default, but SSH is also available.

You must specify one of the above actions when you use the ISO uploader command. Moreover, you must specify at least one local file to use the `upload` action.

There are several parameters to further refine the `engine-iso-uploader` command.

**General Options**

`--version`
: Displays the version of the ISO uploader command.

`-h`, `--help`
: Displays information on how to use the ISO uploader command.

`--conf-file=[PATH]`
: Sets `[PATH]` as the configuration file the command will to use. The default is `/etc/ovirt-engine/isouploader.conf`.

`--log-file=[PATH]`
: Sets `[PATH]` as the specific file name the command will use to write log output. The default is `/var/log/ovirt-engine/ovirt-iso-uploader/ovirt-iso-uploader[date].log`.

`--cert-file=[PATH]`
: Sets `[PATH]` as the certificate for validating the engine. The default is `/etc/pki/ovirt-engine/ca.pem`.

`--insecure`
: Specifies that no attempt will be made to verify the engine.

`--nossl`
: Specifies that SSL will not be used to connect to the engine.

`--quiet`
: Sets quiet mode, reducing console output to a minimum.

`-v`, `--verbose`
: Sets verbose mode, providing more console output.

`-f`, `--force`
: Force mode is necessary when the source file being uploaded has the same file name as an existing file in the destination ISO domain. This option forces the existing file to be overwritten.

**oVirt Engine Options**

`-u [USER]`, `--user=[USER]`
: Specifies the user whose credentials will be used to execute the command. The `[USER]` is specified in the format `[username]`@`[domain]`. The user must exist in the specified domain and be known to the oVirt Engine.

`-r [FQDN]`, `--engine=[FQDN]`
: Specifies the IP address or fully qualified domain name of the oVirt Engine from which the images will be uploaded. It is assumed that the image uploader is being run from the same machine on which the oVirt Engine is installed. The default value is `localhost:443`.

**ISO Storage Domain Options**

The following options specify the ISO domain to which the images will be uploaded. These options cannot be used together; you must used either the `-i` option or the `-n` option.

`-i`, `--iso-domain=[ISODOMAIN]`
: Sets the storage domain `[ISODOMAIN]` as the destination for uploads.

`-n`, `--nfs-server=[NFSSERVER]`
: Sets the NFS path `[NFSSERVER]` as the destination for uploads.

**Connection Options**

The ISO uploader uses NFS as default to upload files. These options specify SSH file transfer instead.

`--ssh-user=[USER]`
: Sets `[USER]` as the SSH user name to use for the upload. The default is `root`.

`--ssh-port=[PORT]`
: Sets `[PORT]` as the port to use when connecting to SSH.

`-k [KEYFILE]`, `--key-file=[KEYFILE]`
: Sets `[KEYFILE]` as the public key to use for SSH authentication. You will be prompted to enter the password of the user specified with `--ssh-user=[USER]` if no key is set.

### Specifying an NFS Server

**Uploading to an NFS Server**

    # engine-iso-uploader --nfs-server=storage.demo.redhat.com:/iso/path upload RHEL6.0.iso

### Basic ISO Uploader Usage

The example below demonstrates the ISO uploader and the list parameter. The first command lists the available ISO storage domains; the `admin@internal` user is used because no user was specified in the command. The second command uploads an ISO file over NFS to the specified ISO domain.

**List Domains and Upload Image**

    # engine-iso-uploader list
    Please provide the REST API password for the admin@internal oVirt Engine user (CTRL+D to abort):
    ISO Storage Domain Name   | Datacenter          | ISO Domain Status
    ISODomain                 | Default             | active

    # engine-iso-uploader --iso-domain=[ISODomain] upload [RHEL6.iso]
    Please provide the REST API password for the admin@internal oVirt Engine user (CTRL+D to abort):

### Uploading the VirtIO and Guest Tool Image Files to an ISO Storage Domain

The `virtio-win` ISO and Virtual Floppy Drive (VFD) images, which contain the VirtIO drivers for Windows virtual machines, and the `rhev-tools-setup` ISO, which contains the oVirt Guest Tools for Windows virtual machines, are copied to an ISO storage domain upon installation and configuration of the domain.

These image files provide software that can be installed on virtual machines to improve performance and usability. The most recent `virtio-win` and `rhev-tools-setup` files can be accessed via the following symbolic links on the file system of the oVirt Engine:

* `/usr/share/virtio-win/virtio-win.iso`

* `/usr/share/virtio-win/virtio-win_x86.vfd`

* `/usr/share/virtio-win/virtio-win_amd64.vfd`

* `/usr/share/rhev-guest-tools-iso/rhev-tools-setup.iso`

These image files must be manually uploaded to ISO storage domains that were not created locally by the installation process. Use the `engine-iso-uploader` command to upload these images to your ISO storage domain. Once uploaded, the image files can be attached to and used by virtual machines.

The example below demonstrates the command to upload the `virtio-win.iso`, `virtio-win_x86.vfd`, `virtio-win_amd64.vfd`, and `rhev-tools-setup.iso` image files to the `ISODomain`.

**Uploading the VirtIO and Guest Tool Image Files**

    # engine-iso-uploader --iso-domain=[ISODomain] upload /usr/share/virtio-win/virtio-win.iso /usr/share/virtio-win/virtio-win_x86.vfd /usr/share/virtio-win/virtio-win_amd64.vfd /usr/share/rhev-guest-tools-iso/rhev-tools-setup.iso

## The Engine Vacuum Tools

###  The Engine Vacuum Tool

The Engine Vacuum tool maintains PostgreSQL databases by updating tables and removing dead rows, allowing disk space to be reused. See the [PostgreSQL documentation](https://www.postgresql.org/docs/9.5/static/sql-vacuum.html) for information about the VACUUM command and its parameters.

The Engine Vacuum command is `engine-vacuum`. You must log in as the **root** user and provide the administration credentials for the oVirt environment.

Alternatively, the Engine Vacuum tool can be run while using the `engine-setup` command to customize an existing installation:

    $ engine-setup
    ...
    [ INFO  ] Stage: Environment customization
    ...
    Perform full vacuum on the engine database engine@localhost?
    This operation may take a while depending on this setup health and the
    configuration of the db vacuum process.
    See https://www.postgresql.org/docs/9.5/static/sql-vacuum.html
    (Yes, No) [No]:

The **Yes** option runs the Engine Vacuum tool in full vacuum verbose mode.

### Engine Vacuum Modes

Engine Vacuum has two modes:

**Standard Vacuum**
: Frequent standard vacuuming is recommended.

  Standard vacuum removes dead row versions in tables and indexes and marks the space as available for future reuse. Frequently updated tables should be vacuumed on a regular basis. However, standard vacuum does not return the space to the operating system.

  Standard vacuum, with no parameters, processes every table in the current database.

**Full Vacuum**
: Full vacuum is not recommended for routine use, but should only be run when a significant amount of space needs to be reclaimed from within the table.

  Full vacuum compacts the tables by writing a new copy of the table file with no dead space, thereby enabling the operating system to reclaim the space. Full vacuum can take a long time.

  Full vacuum requires extra disk space for the new copy of the table, until the operation completes and the old copy is deleted. Because full vacuum requires an exclusive lock on the table, it cannot be run in parallel with other uses of the table.

### Syntax for the engine-vacuum Command

The basic syntax for the engine-vacuum command is:

    # engine-vacuum

    # engine-vacuum option

Running the engine-vacuum command with no options performs a standard vacuum.

There are several parameters to further refine the engine-vacuum command.

**General Options**

`-h --help`
: Displays information on how to use the engine-vacuum command.

`-a`
: Runs a standard vacuum, analyzes the database, and updates the optimizer statistics.

`-A`
: Analyzes the database and updates the optimizer statistics, without vacuuming.

`-f`
: Runs a full vacuum.

`-v`
: Runs in verbose mode, providing more console output.

`-t table_name`
: Vacuums a specific table or tables.

    # engine-vacuum -f -v -t vm_dynamic -t vds_dynamic

**Prev:** [Chapter 17: Event Notifications](chap-Event_Notifications)<br>
**Next:** [Chapter 19: Log Files](chap-Log_Files)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-utilities)

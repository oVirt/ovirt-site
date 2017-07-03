---
title: Utilities
---

# Chapter 18: Utilities

## The oVirt Engine Rename Tool

When the `engine-setup` command is run in a clean environment, the command generates a number of certificates and keys that use the fully qualified domain name of the Manager supplied during the setup process. If the fully qualified domain name of the Manager must be changed later on (for example, due to migration of the machine hosting the Manager to a different domain), the records of the fully qualified domain name must be updated to reflect the new name. The `ovirt-engine-rename` command automates this task.

The `ovirt-engine-rename` command updates records of the fully qualified domain name of the Manager in the following locations:

* /etc/ovirt-engine/engine.conf.d/10-setup-protocols.conf

* /etc/ovirt-engine/imageuploader.conf.d/10-engine-setup.conf

* /etc/ovirt-engine/isouploader.conf.d/10-engine-setup.conf

* /etc/ovirt-engine/logcollector.conf.d/10-engine-setup.conf

* /etc/pki/ovirt-engine/cert.conf

* /etc/pki/ovirt-engine/cert.template

* /etc/pki/ovirt-engine/certs/apache.cer

* /etc/pki/ovirt-engine/keys/apache.key.nopass

* /etc/pki/ovirt-engine/keys/apache.p12

**Warning:** While the `ovirt-engine-rename` command creates a new certificate for the web server on which the Manager runs, it does not affect the certificate for the engine or the certificate authority. Due to this, there is some risk involved in using the `ovirt-engine-rename` command, particularly in environments that have been upgraded from oVirt 3.2 and earlier. Therefore, changing the fully qualified domain name of the Manager by running `engine-cleanup` and `engine-setup` is recommended where possible.

### Syntax for the oVirt Engine Rename Command

The basic syntax for the `ovirt-engine-rename` command is:

    # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename

The command also accepts the following options:

`--newname=[new name]`
: Allows you to specify the new fully qualified domain name for the Manager without user interaction.

`--log=[file]`
: Allows you to specify the path and name of a file into which logs of the rename operation are to be written.

`--config=[file]`
: Allows you to specify the path and file name of a configuration file to load into the rename operation.

`--config-append=[file]`
: Allows you to specify the path and file name of a configuration file to append to the rename operation. This option can be used to specify the path and file name of an answer file.

`--generate-answer=[file]`
: Allows you to specify the path and file name of a file into which your answers to and the values changed by the `ovirt-engine-rename` command are recorded.

### Using the oVirt Engine Rename Tool

**Summary**

You can use the `ovirt-engine-rename` command to update records of the fully qualified domain name of the Manager.

The tool checks whether the Manager provides a local ISO or Data storage domain. If it does, the tool prompts the user to eject, shut down, or place into maintenance mode any virtual machine or storage domain connected to the storage before continuing with the operation. This ensures that virtual machines do not lose connectivity with their virtual disks, and prevents ISO storage domains from losing connectivity during the renaming process.

**Renaming the oVirt Engine**

1. Prepare all DNS and other relevant records for the new fully qualified domain name.

2. Update the DHCP server configuration if DHCP is used.

3. Update the host name on the Manager.

4. Run the following command:

        # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename

5. When prompted, press **Enter** to stop the engine service:

        During execution engine service will be stopped (OK, Cancel) [OK]:

6. When prompted, enter the new fully qualified domain name for the Manager:

        New fully qualified server name:[new name]

**Result**

The `ovirt-engine-rename` command updates records of the fully qualified domain name of the Manager.

## The Engine Configuration Tool

### The Engine Configuration Tool

The engine configuration tool is a command-line utility for configuring global settings for your oVirt environment. The tool interacts with a list of key-value mappings that are stored in the engine database, and allows you to retrieve and set the value of individual keys, and retrieve a list of all available configuration keys and values. Furthermore, different values can be stored for each configuration level in your oVirt environment.

**Note:** Neither the oVirt Engine nor a JBoss Application Platform need to be running to retrieve or set the value of a configuration key. Because the configuration key value-key mappings are stored in the engine database, they can be updated while the `postgresql` service is running. Changes are then applied when the `ovirt-engine` service is restarted.

### Syntax for the engine-config Command

You can run the engine configuration tool from the machine on which the oVirt Engine is installed. For detailed information on usage, print the help output for the command:

    # engine-config --help

**Common tasks**

List available configuration keys
:
        # engine-config --list

List available configuration values
:
        # engine-config --all

Retrieve value of configuration key
:
        # engine-config --get [KEY_NAME]

    Replace `[KEY_NAME]` with the name of the preferred key to retrieve the value for the given version of the key. Use the `--cver` parameter to specify the configuration version of the value to be retrieved. If no version is provided, values for all existing versions are returned.

Set value of configuration key
:
        # engine-config --set [KEY_NAME]=[KEY_VALUE] --cver=[VERSION]

    Replace `[KEY_NAME]` with the name of the specific key to set, and replace `[KEY_VALUE]` with the value to be set. You must specify the `[VERSION]` in environments with more than one configuration version.

Restart the ovirt-engine service to load changes
: The `ovirt-engine` service needs to be restarted for your changes to take effect.

        # service ovirt-engine restart

## The Image Uploader Tool

**Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See [Importing Existing Storage Domains](sect-Importing_Existing_Storage_Domains) for information on importing storage domains.

The `engine-image-uploader` command allows you to list export storage domains and upload virtual machine images in OVF or OVA format to an export storage domain and have them automatically recognized in the oVirt Engine.

An OVA is a `tar` archive of the OVF files.


**Note:** The image uploader only supports gzip-compressed OVF files, or OVA files, created by oVirt.

The OVF contains images and master directories in the following format:

    |-- images
    |   |-- [Image Group UUID]
    |        |--- [Image UUID (this is the disk image)]
    |        |--- [Image UUID (this is the disk image)].meta
    |-- master
    |   |---vms
    |       |--- [UUID]
    |             |--- [UUID].ovf

### Syntax for the engine-image-uploader Command

The basic syntax for the image uploader command is:

    engine-image-uploader [options] list
    engine-image-uploader [options] upload [file].[file]...[file]

The image uploader command supports two actions - `list`, and `upload`.

* The `list` action lists the export storage domains to which images can be uploaded.

* The `upload` action uploads images to the specified export storage domain.

You must specify one of the above actions when you use the image uploader command. Moreover, you must specify at least one local file to use the `upload` action.

There are several parameters to further refine the `engine-image-uploader` command. You can set defaults for any of these parameters in the `/etc/ovirt-engine/imageuploader.conf` file.

**General Options**

`-h`, `--help`
: Displays information on how to use the image uploader command.

`--conf-file=[PATH]`
: Sets `[PATH]` as the configuration file the command will use. The default is `etc/ovirt-engine/imageuploader.conf`.

`--log-file=[PATH]`
: Sets `[PATH]` as the specific file name the command will use to write log output. The default is `/var/log/ovirt-engine/ovirt-image-uploader/ovirt-image-uploader-[date].log`.

`--cert-file=[PATH]`
: Sets `[PATH]` as the certificate for validating the engine. The default is `/etc/pki/ovirt-engine/ca.pem`.

`--insecure`
: Specifies that no attempt will be made to verify the engine.

`--quiet`
: Sets quiet mode, reducing console output to a minimum.

`-v`, `--verbose`
: Sets verbose mode, providing more console output.

`-f`, `--force`
: Force mode is necessary when the source file being uploaded has the same file name as an existing file in the destination export domain. This option forces the existing file to be overwritten.

**oVirt Engine Options**

`-u [USER]`, `--user=[USER]`
: Specifies the user whose credentials will be used to execute the command. The `[USER]` is specified in the format `[username]@[domain]`. The user must exist in the specified domain and be known to the oVirt Engine.

`-r [FQDN]`, `--engine=[FQDN]`
: Specifies the IP address or fully qualified domain name of the oVirt Engine from which the images will be uploaded. It is assumed that the image uploader is being run from the same machine on which the oVirt Engine is installed. The default value is `localhost:443`.

**Export Storage Domain Options**

The following options specify the export domain to which the images will be uploaded. These options cannot be used together; you must used either the `-e` option or the `-n` option.

`-e [EXPORT_DOMAIN]`, `--export-domain=[EXPORT_DOMAIN]`
: Sets the storage domain `EXPORT_DOMAIN` as the destination for uploads.

`-n [NFSSERVER]`, `--nfs-server=[NFSSERVER]`
: Sets the NFS path `[NFSSERVER]` as the destination for uploads.

**Import Options**

The following options allow you to customize which attributes of the images being uploaded are included when the image is uploaded to the export domain.

`-i`, `--ovf-id`
: Specifies that the UUID of the image will not be updated. By default, the command generates a new UUID for images that are uploaded. This ensures there is no conflict between the id of the image being uploaded and the images already in the environment.

`-d`, `--disk-instance-id`
: Specifies that the instance ID for each disk in the image will not be renamed. By default, the command generates new UUIDs for disks in images that are uploaded. This ensures there are no conflicts between the disks on the image being uploaded and the disks already in the environment.

`-m`, `--mac-address`
: Specifies that network components in the image will not be removed from the image. By default, the command removes network interface cards from image being uploaded to prevent conflicts with network cards on other virtual machines already in the environment. If you do not use this option, you can use the Administration Portal to add network interface cards to newly imported images and the Manager will ensure there are no MAC address conflicts.

`-N [NEW_IMAGE_NAME]`, `--name=[NEW_IMAGE_NAME]`
: Specifies a new name for the image being uploaded.

### Creating an OVF Archive That is Compatible With the Image Uploader

**Summary**

You can create files that can be uploaded using the `engine-image-uploader` tool.

**Creating an OVF Archive That is Compatible With the Image Uploader**

1. Use the Manager to create an empty export domain. An empty export domain makes it easy to see which directory contains your virtual machine.

2. Export your virtual machine to the empty export domain you just created.

3. Log in to the storage server that serves as the export domain, find the root of the NFS share and change to the subdirectory under that mount point. You started with a new export domain, there is only one directory under the exported directory. It contains the `images/` and `master/` directories.

4. Run the `tar -zcvf my.ovf images/ master/` command to create the tar/gzip OVF archive.

5. Anyone you give the resulting OVF file to (in this example, called `my.ovf`) can import it to oVirt Engine using the `engine-image-uploader` command.

**Result**

You have created a compressed OVF image file that can be distributed. Anyone you give it to can use the `engine-image-uploader` command to upload your image into their oVirt environment.

### Basic engine-image-uploader Usage Examples

The following is an example of how to use the engine uploader command to list export storage domains:

**Listing export storage domains using the image uploader**

    # engine-image-uploader list
    Please provide the REST API password for the admin@internal oVirt Engine user (CTRL+D to abort):
    Export Storage Domain Name | Datacenter  | Export Domain Status
    myexportdom               | Myowndc 　  | active

The following is an example of how to upload an Open Virtualization Format (OVF) file:

**Uploading a file using the image uploader**

    # engine-image-uploader -e myexportdom upload myrhel6.ovf
    Please provide the REST API password for the admin@internal oVirt Engine user (CTRL+D to abort):

## The USB Filter Editor

### Installing the USB Filter Editor

The USB Filter Editor is a Windows tool used to configure the `usbfilter.txt` policy file. The policy rules defined in this file allow or deny automatic pass-through of specific USB devices from client machines to virtual machines managed using the oVirt Engine. The policy file resides on the oVirt Engine in the following location:

`/etc/ovirt-engine/usbfilter.txt`

Changes to USB filter policies do not take effect unless the `ovirt-engine` service on the oVirt Engine server is restarted.

Download the `USBFilterEditor.msi` file.

**Installing the USB Filter Editor**

1. On a Windows machine, launch the `USBFilterEditor.msi` installer obtained from the Content Delivery Network.

2. Follow the steps of the installation wizard. Unless otherwise specified, the USB Filter Editor will be installed by default in either `C:\Program Files\RedHat\USB Filter Editor` or `C:\Program Files(x86)\RedHat\USB Filter Editor` depending on your version of Windows.

3. A USB Filter Editor shortcut icon is created on your desktop.

**Important:** Use a Secure Copy (SCP) client to import and export filter policies from the oVirt Engine. A Secure Copy tool for Windows machines is WinSCP ([http://winscp.net](http://winscp.net)).

The default USB device policy provides virtual machines with basic access to USB devices; update the policy to allow the use of additional USB devices.

### The USB Filter Editor Interface

* Double-click the USB Filter Editor shortcut icon on your desktop.

    **USB Filter Editor**

    ![](/images/admin-guide/587.png)

The **USB Filter Editor** interface displays the **Class**, **Vendor**, **Product**, **Revision**, and **Action** for each USB device. Permitted USB devices are set to **Allow** in the **Action** column; prohibited devices are set to **Block**.

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

**Summary**

Add a USB policy to the USB Filter Editor.

Double-click the USB Filter Editor shortcut icon on your desktop to open the editor.

**Adding a USB Policy**

1. Click the **Add** button. The **Edit USB Criteria** window opens:

    **Edit USB Criteria**

    ![](/images/admin-guide/305.png)

2. Use the **USB Class**, **Vendor ID**, **Product ID**, and **Revision** check boxes and lists to specify the device.

    Click the **Allow** button to permit virtual machines use of the USB device; click the **Block** button to prohibit the USB device from virtual machines.

    Click **OK** to add the selected filter rule to the list and close the window.

    **Adding a Device**

    The following is an example of how to add USB Class `Smartcard`, device `EP-1427X-2 Ethernet Adapter`, from manufacturer `Acer Communications & Multimedia` to the list of allowed devices.

    ![](/images/admin-guide/306.png)

3. Click **File** > **Save** to save the changes.

**Result**

You have added a USB policy to the USB Filter Editor. USB filter policies need to be exported to the oVirt Engine to take effect.

### Removing a USB Policy

**Summary**

Remove a USB policy from the USB Filter Editor.

Double-click the USB Filter Editor shortcut icon on your desktop to open the editor.

**Removing a USB Policy**

1. Select the policy to be removed.

    **Select USB Policy**

    ![](/images/admin-guide/481.png)

2. Click **Remove**. A message displays prompting you to confirm that you want to remove the policy.

    **Edit USB Criteria**

   ![](/images/admin-guide/482.png)

3. Click **Yes** to confirm that you want to remove the policy.

4. Click **File** > **Save** to save the changes.

**Result**

You have removed a USB policy from the USB Filter Editor. USB filter policies need to be exported to the oVirt Engine to take effect.

### Searching for USB Device Policies

**Summary**

Search for attached USB devices to either allow or block them in the USB Filter Editor.

Double-click the USB Filter Editor shortcut icon on your desktop to open the editor.

**Searching for USB Device Policies**

1. Click **Search**. The **Attached USB Devices** window displays a list of all the attached devices.

    **Attached USB Devices**

    ![](/images/admin-guide/590.png)

2. Select the device and click **Allow** or **Block** as appropriate. Double-click the selected device to close the window. A policy rule for the device is added to the list.

3. Use the **Up** and **Down** buttons to change the position of the new policy rule in the list.

3. Click **File** > **Save** to save the changes.

**Result**

You have searched the attached USB devices. USB filter policies need to be exported to the oVirt Engine to take effect.

### Exporting a USB Policy

**Summary**

USB device policy changes need to be exported and uploaded to the oVirt Engine for the updated policy to take effect. Upload the policy and restart the `ovirt-engine` service.

Double-click the USB Filter Editor shortcut icon on your desktop to open the editor.

**Exporting a USB Policy**

1. Click **Export**; the **Save As** window opens.

2. Save the file with a file name of `usbfilter.txt`.

3. Using a Secure Copy client, such as WinSCP, upload the `usbfilter.txt` file to the server running oVirt Engine. The file must be placed in the following directory on the server:

    `/etc/ovirt-engine/`

4. As the `root` user on the server running oVirt Engine, restart the `ovirt-engine` service.

        # systemctl restart ovirt-engine.service

**Result**

The USB device policy will now be implemented on virtual machines running in the oVirt environment.

### Importing a USB Policy

**Summary**

An existing USB device policy must be downloaded and imported into the USB Filter Editor before you can edit it.

**Importing a USB Policy**

1. Using a Secure Copy client, such as WinSCP, upload the `usbfilter.txt` file to the server running oVirt Engine. The file must be placed in the following directory on the server:

    `/etc/ovirt-engine/`

2. Double-click the USB Filter Editor shortcut icon on your desktop to open the editor.

3. Click **Import** to open the **Open** window.

4. Open the `usbfilter.txt` file that was downloaded from the server.

**Result**

You are able to edit the USB device policy in the USB Filter Editor.

## The Log Collector Tool

A log collection tool is included in the oVirt Engine. This allows you to easily collect relevant logs from across the oVirt environment when requesting support.

The log collection command is `ovirt-log-collector`. You are required to log in as the `root` user and provide the administration credentials for the oVirt environment. The `ovirt-log-collector -h` command displays usage information, including a list of all valid options for the `ovirt-log-collector` command.

### Syntax for the ovirt-log-collector Command

The basic syntax for the log collector command is:

    ovirt-log-collector [options] list [all, clusters, datacenters]
    ovirt-log-collector [options] collect

The two supported modes of operation are `list` and `collect`.

* The `list` parameter lists either the hosts, clusters, or data centers attached to the oVirt Engine. You are able to filter the log collection based on the listed objects.

* The `collect` parameter performs log collection from the oVirt Engine. The collected logs are placed in an archive file under the `/tmp/logcollector` directory. The `ovirt-log-collector` command assigns each log a specific file name.

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

**oVirt Engine Options**

These options filter the log collection and specify authentication details for the oVirt Engine.

These parameters can be combined for specific commands. For example, `ovirt-log-collector --user=admin@internal --cluster ClusterA,ClusterB --hosts "SalesHost"*` specifies the user as `admin@internal` and limits the log collection to only `SalesHost` hosts in clusters `A` and `B`.

`--no-hypervisors`
: Omits virtualization hosts from the log collection.

`-u USER`, `--user=USER`
: Sets the user name for login. The `USER` is specified in the format `user@domain`, where `user` is the user name and `domain` is the directory services domain in use. The user must exist in directory services and be known to the oVirt Engine.

`-r FQDN`, `--rhevm=FQDN`
: Sets the fully qualified domain name of the oVirt Engine server from which to collect logs, where `FQDN` is replaced by the fully qualified domain name of the Manager. It is assumed that the log collector is being run on the same local host as the oVirt Engine; the default value is `localhost`.

`-c CLUSTER`, `--cluster=CLUSTER`
: Collects logs from the virtualization hosts in the nominated `CLUSTER` in addition to logs from the oVirt Engine. The cluster(s) for inclusion must be specified in a comma-separated list of cluster names or match patterns.

`-d DATACENTER`, `--data-center=DATACENTER`
: Collects logs from the virtualization hosts in the nominated `DATACENTER` in addition to logs from the oVirt Engine. The data center(s) for inclusion must be specified in a comma-separated list of data center names or match patterns.

`-H HOSTS_LIST`, `--hosts=HOSTS_LIST`
: Collects logs from the virtualization hosts in the nominated `HOSTS_LIST` in addition to logs from the oVirt Engine. The hosts for inclusion must be specified in a comma-separated list of host names, fully qualified domain names, or IP addresses. Match patterns are also valid.

**SOS Report Options**

The log collector uses the JBoss SOS plugin. Use the following options to activate data collection from the JMX console.

`--jboss-home=JBOSS_HOME`
: JBoss installation directory path. The default is `/var/lib/jbossas`.

`--java-home=JAVA_HOME`
: Java installation directory path. The default is `/usr/lib/jvm/java`.

`--jboss-profile=JBOSS_PROFILE`
: Displays a quoted and space-separated list of server profiles; limits log collection to specified profiles. The default is `'rhevm-slimmed'`.

`--enable-jmx`
: Enables the collection of run-time metrics from oVirt's JBoss JMX interface.

`--jboss-user=JBOSS_USER`
: User with permissions to invoke JBoss JMX. The default is `admin`.

`--jboss-logsize=LOG_SIZE`
: Maximum size in MB for the retrieved log files.

`--jboss-stdjar=STATE`
: Sets collection of JAR statistics for JBoss standard JARs. Replace `STATE` with `on` or `off`. The default is `on`.

`--jboss-servjar=STATE`
: Sets collection of JAR statistics from any server configuration directories. Replace `STATE` with `on` or `off`. The default is `on`.

`--jboss-twiddle=STATE`
: Sets collection of twiddle data on or off. Twiddle is the JBoss tool used to collect data from the JMX invoker. Replace `STATE` with `on` or `off`. The default is `on`.

`--jboss-appxml=XML_LIST`
: Displays a quoted and space-separated list of applications with XML descriptions to be retrieved. Default is `all`.

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

The ISO uploader is a tool for uploading ISO images to the ISO storage domain. It is installed as part of the oVirt Engine.

The ISO uploader command is `engine-iso-uploader`. You must log in as the `root` user and provide the administration credentials for the oVirt environment to use this command. The `engine-iso-uploader -h` command displays usage information, including a list of all valid options for the `engine-iso-uploader` command.

### Syntax for the engine-iso-uploader Command

The basic syntax for the ISO uploader command is:

    engine-iso-uploader [options] list
    engine-iso-uploader [options] upload [file].[file]...[file]

The ISO uploader command supports two actions - `list`, and `upload`.

* The `list` action lists the ISO storage domains to which ISO files can be uploaded. The oVirt Engine creates this list on the machine on which the Manager is installed during the installation process.

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

The example below demonstrates the command to upload the `virtio-win.iso`, `virtio-win_x86.vfd`, `virtio-win_amd64.vfd`, and `rhev-tools-setup.iso` image files to the `ISODomain`.

**Uploading the VirtIO and Guest Tool Image Files**

    # engine-iso-uploader --iso-domain=[ISODomain] upload /usr/share/virtio-win/virtio-win.iso /usr/share/virtio-win/virtio-win_x86.vfd /usr/share/virtio-win/virtio-win_amd64.vfd /usr/share/rhev-guest-tools-iso/rhev-tools-setup.iso

### VirtIO and Guest Tool Image Files

The `virtio-win` ISO and Virtual Floppy Drive (VFD) images, which contain the VirtIO drivers for Windows virtual machines, and the `rhev-tools-setup` ISO, which contains the oVirt Guest Tools for Windows virtual machines, are copied to an ISO storage domain upon installation and configuration of the domain.

These image files provide software that can be installed on virtual machines to improve performance and usability. The most recent `virtio-win` and `rhev-tools-setup` files can be accessed via the following symbolic links on the file system of the oVirt Engine:

* `/usr/share/virtio-win/virtio-win.iso`

* `/usr/share/virtio-win/virtio-win_x86.vfd`

* `/usr/share/virtio-win/virtio-win_amd64.vfd`

* `/usr/share/rhev-guest-tools-iso/rhev-tools-setup.iso`

These image files must be manually uploaded to ISO storage domains that were not created locally by the installation process. Use the `engine-iso-uploader` command to upload these images to your ISO storage domain. Once uploaded, the image files can be attached to and used by virtual machines.

**Prev:** [Chapter 17: Event Notifications](../chap-Event_Notifications)<br>
**Next:** [Chapter 19: Log Files](../chap-Log_Files)

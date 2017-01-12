# Red Hat Virtualization Host

Red Hat Virtualization Host (RHVH) is installed using a special build of Red Hat Enterprise Linux with only the packages required to host virtual machines. It uses an Anaconda installation interface based on the one used by Red Hat Enterprise Linux hosts, and can be updated through the Red Hat Virtualization Manager or via `yum`. However, installing additional packages is not currently supported; any additional packages that are installed must be reinstalled each time RHVH is updated. 

RHVH features a Cockpit user interface for monitoring the host's resources and performing administrative tasks. Direct access to RHVH via SSH or console is not supported, so the Cockpit user interface provides a graphical user interface for tasks that are performed before the host is added to the Red Hat Virtualization Manager, such as deploying a self-hosted engine, and can also be used to run terminal commands via the **Tools** > **Terminal** sub-tab.

Access the Cockpit user interface at https://*HostFQDNorIP*:9090 in your web browser. Cockpit for RHVH includes a custom **Virtualization** dashboard that displays the host's health status, SSH Host Key, self-hosted engine status, virtual machines, and virtual machine statistics.

**Note:** Custom boot kernel arguments can be added to Red Hat Virtualization Host using the `grubby` tool. The `grubby` tool makes persistent changes to the `grub.cfg` file. Navigate to the **Tools** > **Terminal** sub-tab in the host's Cockpit user interface to use `grubby` commands. See the [*Red Hat Enterprise Linux System Administrator's Guide*](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/sec-Making_Persistent_Changes_to_a_GRUB_2_Menu_Using_the_grubby_Tool.html) for more information.

**Warning:** Red Hat strongly recommends not creating untrusted users on RHVH, as this can lead to exploitation of local security vulnerabilities.

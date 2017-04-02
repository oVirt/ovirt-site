---
title: oVirt Nodes
---

# Chapter 6: oVirt Nodes

oVirt 4.0 introduces an upgraded version of the oVirt Node. While the previous oVirt Node was a closed system with a basic text user interface for installation and configuration, oVirt Node can now be updated via `yum` and uses an Anaconda installation interface based on the one used by Enterprise Linux hosts.

# Installing oVirt Node

oVirt Node is a minimal operating system based on CentOS that is designed to provide a simple method for setting up a physical machine to act as a hypervisor in a oVirt environment. The minimal operating system contains only the packages required for the machine to act as a hypervisor, and features a Cockpit user interface for monitoring the host and performing administrative tasks. See [http://cockpit-project.org/running.html](http://cockpit-project.org/running.html) for the minimum browser requirements.

Before you proceed, make sure the machine on which you are installing oVirt Node meets the hardware requirements listed in **Part III: Hypervisor Requirements**.

Installing oVirt Node on a physical machine involves three key steps:

1. Download the oVirt Node disk image from the oVirt web site.

2. Write the oVirt Node disk image to a USB, CD, or DVD.

3. Install the oVirt Node minimal operating system.

**Installing oVirt Node**

1. Download the oVirt Node disk image from the oVirt site:

    a. Visit to the [oVirt Node page](/node/).

    b. Choose the ISO image for oVirt Node 4.0 and click **Installation ISO**.

    c. Create a bootable media device.

2. Start the machine on which to install oVirt Node using the prepared installation media.

3. From the boot menu, select the **Install** option, and press **Enter**.

    **Note:** You can also press the **Tab** key to edit the kernel parameters. Kernel parameters must be separated by a space, and you can boot the system using the specified kernel parameters by pressing the **Enter** key. Press the **Esc** key to clear any changes to the kernel parameters and return to the boot menu.

4. Select a language, and click **Continue**.

5. Select a time zone from the **Date & Time** screen and click **Done**.

6. Select a keyboard layout from the **Keyboard** screen and click **Done**.

7. Select the device on which to install oVirt Node from the **Installation Destination** screen. Optionally, enable encryption. Click **Done**.

    **Important:** The oVirt Project strongly recommends using the **Automatically configure partitioning** option.

8. Select a network from the **Network & Host Name** screen and click **Configure...** to configure the connection details. Enter a host name in the **Host name** field, and click **Done**.

9. Optionally configure **Language Support**, **Security Policy**, and **Kdump**.

10. Click **Begin Installation**.

11. Set a root password and, optionally, create an additional user while oVirt Node installs.

    **Warning:** Red Hat strongly recommends not creating untrusted users on oVirt Node, as this can lead to exploitation of local security vulnerabilities.

12. Click **Reboot** to complete the installation.

    **Note:** When oVirt Node restarts, `imgbase-motd.service` performs a health check on the host and displays the result when you log in on the command line. The message `imgbase status: OK` or `imgbase status: DEGRADED` indicates the health status. Run `imgbase check` to get more information. The service is enabled by default.

13. Once the installation is complete, log in to the Cockpit user interface at https://*HostFQDNorIP*:9090 to subscribe the host to the Content Delivery Network. Click **Tools** > **Subscriptions** > **Register System** and enter your Customer Portal username and password. The system automatically subscribes to the **oVirt Node** entitlement.

You can now add the host to your oVirt environment. See [Chapter 8: Adding a Hypervisor](../chap-Adding_a_Hypervisor).

**Warning:** Configuring networking through NetworkManager (including `nmcli`, `nmtui`, and the Cockpit user interface) is currently not supported. If additional network configuration is required before adding a host to the Manager, you must manually write `ifcfg` files.

## Advanced Installation

### Custom Partitioning

Custom partitioning on oVirt Node is not recommended. Red Hat strongly recommends using the **Automatically configure partitioning** option in the **Installation Destination** window.

If your installation requires custom partitioning, note that the following restrictions apply:

* You must select the **LVM Thin Provisioning** option in the **Manual Partitioning** window.

* The root (`/`) directory must be on a thinly provisioned logical volume.

* The root (`/`) directory must be at least 6 GB.

* The `/var` directory must be on a separate volume or disk.

* Only XFS or Ext4 file systems are supported.

**Prev:** [Chapter 5: Introduction to Hypervisor Hosts](../chap-Introduction_to_Hypervisor_Hosts) <br>
**Next:** [Chapter 7: Enterprise Linux Hosts](../chap-Enterprise_Linux_Hosts)

---
title: oVirt Nodes
---

# Chapter 6: oVirt Nodes

# Installing oVirt Node

oVirt Node is a minimal operating system based on CentOS that is designed to provide a simple method for setting up a physical machine to act as a hypervisor in a oVirt environment.
The minimal operating system contains only the packages required for the machine to act as a hypervisor, and features a Cockpit user interface for monitoring the host and performing administrative tasks.
See [http://cockpit-project.org/running.html](http://cockpit-project.org/running.html) for the minimum browser requirements.

Before you proceed, make sure the machine on which you are installing oVirt Node meets the hardware requirements listed in [Chapter 2: System Requirements](chap-System_Requirements).

Installing oVirt Node on a physical machine involves three key steps:

* Download the oVirt Node disk image from the oVirt web site.

* Write the oVirt Node disk image to a USB, CD, or DVD.

* Install the oVirt Node minimal operating system.

**Installing oVirt Node**

1. Download the oVirt Node 4.3 - Stable Release - Installation ISO disk image from the oVirt site:

    i. Visit to the [oVirt Node Download page](/download/node.html).

    ii. Download [oVirt Node 4.3 - Stable Release - Installation ISO](https://www.ovirt.org/download/node.html#ovirt-node-43---stable-release)

    iii. Write the oVirt Node Installation ISO disk image to a USB, CD, or DVD.

2. Start the machine on which to install oVirt Node using the prepared installation media (i.e. boot from the media).

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

    **Warning:** The oVirt Project strongly recommends not creating untrusted users on oVirt Node, as this can lead to exploitation of local security vulnerabilities.

12. Click **Reboot** to complete the installation.

    **Note:** When oVirt Node restarts, `imgbase-motd.service` performs a health check on the host and displays the result when you log in on the command line. The message `imgbase status: OK` or `imgbase status: DEGRADED` indicates the health status. Run `imgbase check` to get more information. The service is enabled by default.

You can now add the host to your oVirt environment. See [Chapter 8: Adding a Host to the oVirt Engine](chap-Adding_a_Host_to_the_oVirt_Engine).

## Advanced Installation

### Custom Partitioning

Custom partitioning on oVirt Node is not recommended. The oVirt Project strongly recommends using the **Automatically configure partitioning** option in the **Installation Destination** window.

If your installation requires custom partitioning, note that the following restrictions apply:

* Ensure the default **LVM Thin Provisioning** option is selected in the **Manual Partitioning** window.

* The following directories are required and must be on thin provisioned logical volumes:

  * root (/)

  * /home

  * /tmp

  * /var

  * /var/log

  * /var/log/audit

    **Important:** Do not create a separate partition for /usr. Doing so will cause the installation to fail.

    /usr must be on a logical volume that is able to change versions along with oVirt Node, and therefore should be left on root (/).

For information about the required storage sizes for each partition, see [Chapter 2: System Requirements](chap-System_Requirements).

* The /boot directory should be defined as a standard partition.

* The /var directory must be on a separate volume or disk.

* Only XFS or Ext4 file systems are supported.


**Prev:** [Chapter 5: Introduction to Hosts](chap-Introduction_to_Hosts) <br>
**Next:** [Chapter 7: Enterprise Linux Hosts](chap-Enterprise_Linux_Hosts)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/installation_guide/advanced_rhvh_install)

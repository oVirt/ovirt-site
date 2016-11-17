# Installing Red Hat Virtualization Host (RHVH)

RHVH is a minimal operating system based on Red Hat Enterprise Linux that is designed to provide a simple method for setting up a physical machine to act as a hypervisor in a Red Hat Virtualization environment. The minimal operating system contains only the packages required for the machine to act as a hypervisor, and features a Cockpit user interface for monitoring the host and performing administrative tasks. See [http://cockpit-project.org/running.html](http://cockpit-project.org/running.html) for the minimum browser requirements.

Before you proceed, make sure the machine on which you are installing RHVH meets the hardware requirements listed in [Hypervisor Requirements](sect-Hypervisor_Requirements).

Installing RHVH on a physical machine involves three key steps:

1. Download the RHVH disk image from the Customer Portal.

2. Write the RHVH disk image to a USB, CD, or DVD.

3. Install the RHVH minimal operating system.

**Installing Red Hat Virtualization Host**

1. Download the RHVH disk image from the Customer Portal:

    1. Log in to the Customer Portal at [https://access.redhat.com](https://access.redhat.com).

    2. Click **Downloads** in the menu bar.

    3. Click **Red Hat Virtualization**, scroll up, and click **Download Latest** to access the product download page.

    4. Choose the hypervisor image for RHV 4.0 and click **Download Now**.

    5. Create a bootable media device. See the relevant [Red Hat Enterprise Linux Installation Guide](https://access.redhat.com/documentation/en/red-hat-enterprise-linux/) for more information.

2. Start the machine on which to install RHVH using the prepared installation media.

3. From the boot menu, select the **Install** option, and press **Enter**.

    **Note:** You can also press the **Tab** key to edit the kernel parameters. Kernel parameters must be separated by a space, and you can boot the system using the specified kernel parameters by pressing the **Enter** key. Press the **Esc** key to clear any changes to the kernel parameters and return to the boot menu.

4. Select a language, and click **Continue**.

5. Select a time zone from the **Date & Time** screen and click **Done**.

6. Select a keyboard layout from the **Keyboard** screen and click **Done**.

7. Select the device on which to install RHVH from the **Installation Destination** screen. Optionally, enable encryption. Click **Done**.

    **Important:** Red Hat strongly recommends using the **Automatically configure partitioning** option. 

8. Select a network from the **Network & Host Name** screen and click **Configure...** to configure the connection details. Enter a host name in the **Host name** field, and click **Done**.

9. Optionally configure **Language Support**, **Security Policy**, and **Kdump**. See [Installing Using Anaconda](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Installation_Guide/chap-installing-using-anaconda-x86.html) in the *Red Hat Enterprise Linux 7 Installation Guide* for more information on each of the sections in the **Installation Summary** screen.

10. Click **Begin Installation**.

11. Set a root password and, optionally, create an additional user while RHVH installs.

    **Warning:** Red Hat strongly recommends not creating untrusted users on RHVH, as this can lead to exploitation of local security vulnerabilities.

12. Click **Reboot** to complete the installation.

    **Note:** When RHVH restarts, `imgbase-motd.service` performs a health check on the host and displays the result when you log in on the command line. The message `imgbase status: OK` or `imgbase status: DEGRADED` indicates the health status. Run `imgbase check` to get more information. The service is enabled by default.

13. Once the installation is complete, log in to the Cockpit user interface at https://*HostFQDNorIP*:9090 to subscribe the host to the Content Delivery Network. Click **Tools** > **Subscriptions** > **Register System** and enter your Customer Portal username and password. The system automatically subscribes to the **Red Hat Virtualization Host** entitlement.

14. Click **Terminal**, and enable the `Red Hat Virtualization Host 7` repository to allow later updates to the Red Hat Virtualization Host:

        # subscription-manager repos --enable=rhel-7-server-rhvh-4-rpms

You can now add the host to your Red Hat Virtualization environment. See [Adding a Hypervisor](Adding_a_Hypervisor).

**Warning:** Configuring networking through NetworkManager (including `nmcli`, `nmtui`, and the Cockpit user interface) is currently not supported. If additional network configuration is required before adding a host to the Manager, you must manually write `ifcfg` files. See the [*Red Hat Enterprise Linux Networking Guide*](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/index.html) for more information.

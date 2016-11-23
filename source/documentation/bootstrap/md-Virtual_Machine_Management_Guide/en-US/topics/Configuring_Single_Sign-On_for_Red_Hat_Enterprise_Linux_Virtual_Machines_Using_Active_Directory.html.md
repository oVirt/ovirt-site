# Configuring Single Sign-On for Red Hat Enterprise Linux Virtual Machines Using Active Directory

To configure single sign-on for Red Hat Enterprise Linux virtual machines using GNOME and KDE graphical desktop environments and Active Directory, you must install the `rhevm-guest-agent` package on the virtual machine, install the packages associated with your window manager and join the virtual machine to the domain.

**Important:** The following procedure assumes that you have a working Active Directory configuration and that the Active Directory domain is already joined to the Manager. You must also ensure that the clocks on the Manager, the virtual machine and the system on which Active Directory is hosted are synchronized using NTP.

**Configuring Single Sign-On for Red Hat Enterprise Linux Virtual Machines**

1. Log in to the Red Hat Enterprise Linux virtual machine.

2. Enable the Red Hat Virtualization Agent channel: 

    * For Red Hat Enterprise Linux 6

            # subscription-manager repos --enable=rhel-6-server-rhv-4-agent-rpms

    * For Red Hat Enterprise Linux 7

            # subscription-manager repos --enable=rhel-7-server-rh-common-rpms

3. Download and install the guest agent packages:

        # yum install rhevm-guest-agent-common

4. Install the single sign-on packages: 

        # yum install rhev-agent-gdm-plugin-rhevcred

5. Install the Samba client packages: 

        # yum install samba-client samba-winbind samba-winbind-clients

6. On the virtual machine, modify the `/etc/samba/smb.conf` file to contain the following, replacing `DOMAIN` with the short domain name and `REALM.LOCAL` with the Active Directory realm:

        [global]
           workgroup = DOMAIN
           realm = REALM.LOCAL
           log level = 2
           syslog = 0
           server string = Linux File Server
           security = ads
           log file = /var/log/samba/%m
           max log size = 50
           printcap name = cups
           printing = cups
           winbind enum users = Yes
           winbind enum groups = Yes
           winbind use default domain = true
           winbind separator = +
           idmap uid = 1000000-2000000
           idmap gid = 1000000-2000000
           template shell = /bin/bash

7. Join the virtual machine to the domain:

        net ads join -U user_name

8. Start the `winbind` service and ensure it starts on boot: 

    * For Red Hat Enterprise Linux 6 

            # service winbind start
            # chkconfig winbind on

9. For Red Hat Enterprise Linux 7 

        # systemctl start winbind.service
        # systemctl enable winbind.service 

10. Verify that the system can communicate with Active Directory:

    1. Verify that a trust relationship has been created: 

            # wbinfo -t

    2. Verify that you can list users: 

            # wbinfo -u

    3. Verify that you can list groups: 

            # wbinfo -g

11. Configure the NSS and PAM stack:

    1. Open the **Authentication Configuration** window: 

            # authconfig-tui

    2. Select the **Use Winbind** check box, select **Next** and press **Enter**.

    3. Select the **OK** button and press **Enter**.

Log in to the User Portal using the user name and password of a user configured to use single sign-on and connect to the console of the virtual machine. You will be logged in automatically.

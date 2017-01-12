# Red Hat Enterprise Linux Hosts

You can use a Red Hat Enterprise Linux 7 installation on capable hardware as a host. Red Hat Virtualization supports hosts running Red Hat Enterprise Linux 7 Server AMD64/Intel 64 version with Intel VT or AMD-V extensions. To use your Red Hat Enterprise Linux machine as a host, you must also attach the `Red Hat Enterprise Linux Server` entitlement and the `Red Hat Virtualization` entitlement.

Adding a host can take some time, as the following steps are completed by the platform: virtualization checks, installation of packages, creation of bridge, and a reboot of the host. Use the details pane to monitor the process as the host and management system establish a connection.

**Important:** Third-party watchdogs should not be installed on Red Hat Enterprise Linux hosts, as they can interfere with the watchdog daemon provided by VDSM.

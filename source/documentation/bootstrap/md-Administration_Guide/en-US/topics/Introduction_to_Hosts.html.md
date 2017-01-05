# Introduction to Hosts

Hosts, also known as hypervisors, are the physical servers on which virtual machines run. Full virtualization is provided by using a loadable Linux kernel module called Kernel-based Virtual Machine (KVM).

KVM can concurrently host multiple virtual machines running either Windows or Linux operating systems. Virtual machines run as individual Linux processes and threads on the host machine and are managed remotely by the Red Hat Virtualization Manager. A Red Hat Virtualization environment has one or more hosts attached to it.

Red Hat Virtualization supports two methods of installing hosts. You can use the Red Hat Virtualization Host (RHVH) installation media, or install hypervisor packages on a standard Red Hat Enterprise Linux installation.

**Note:** You can identify the host type of an individual host in the Red Hat Virtualization Manager by selecting the host, clicking **Software** under the **General** tab in the details pane, and checking the **OS Description**. 

Hosts use `tuned` profiles, which provide virtualization optimizations. For more information on `tuned`, see the [*Red Hat Enterprise Linux 7 Performance Tuning Guide*](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Performance_Tuning_Guide/sect-Red_Hat_Enterprise_Linux-Performance_Tuning_Guide-Performance_Monitoring_Tools-tuned_and_tuned_adm.html).

The Red Hat Virtualization Host has security features enabled. Security Enhanced Linux (SELinux) and the iptables firewall are fully configured and on by default. The status of SELinux on a selected host is reported under **SELinux mode** in the **General** tab of the details pane. The Manager can open required ports on Red Hat Enterprise Linux hosts when it adds them to the environment.

A host is a physical 64-bit server with the Intel VT or AMD-V extensions running Red Hat Enterprise Linux 7 AMD64/Intel 64 version.

A physical host on the Red Hat Virtualization platform:

* Must belong to only one cluster in the system.

* Must have CPUs that support the AMD-V or Intel VT hardware virtualization extensions.

* Must have CPUs that support all functionality exposed by the virtual CPU type selected upon cluster creation.

* Has a minimum of 2 GB RAM.

* Can have an assigned system administrator with system permissions.

Administrators can receive the latest security advisories from the Red Hat Virtualization watch list. Subscribe to the Red Hat Virtualization watch list to receive new security advisories for Red Hat Virtualization products by email. Subscribe by completing this form:

[http://www.redhat.com/mailman/listinfo/rhev-watch-list/](http://www.redhat.com/mailman/listinfo/rhev-watch-list/)

**Warning:** Configuring networking through NetworkManager (including `nmcli`, `nmtui`, and the Cockpit user interface) is currently not supported. If additional network configuration is required before adding a host to the Manager, you must manually write `ifcfg` files. See the [*Red Hat Enterprise Linux Networking Guide*](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/index.html) for more information.

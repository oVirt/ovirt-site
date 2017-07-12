---
title: Troubleshooting
authors: 8none1, alonbl, dneary, hozn, jbrooks, jumper45, mburns, sgtpepper, tscofield
---

<!-- TODO: Content review -->

# Troubleshooting

*See also other troubleshooting documents in the wiki:*

*   *[Node Troubleshooting](Node Troubleshooting) - issues related to booting oVirt Node*
*   *[Troubleshooting NFS Storage Issues](Troubleshooting NFS Storage Issues) - when your storage isn't working as you wish*
*   *[Building oVirt engine#Troubleshooting](Building oVirt engine#Troubleshooting) - Issues related to compiling and deploying oVirt Engine*
*   *[Vdsm Developers#Troubleshooting Fake KVM Support](Vdsm Developers#Troubleshooting_Fake_KVM_Support) - For VDSM developers having trouble with "fake_kvm_support"*

## Engine

### Installation

When running engine-setup, I get the message "myhost.local did not resolve into an IP address", but setting up bind locally is hard. Is there an easy way to spoof full DNS locally?  
The easiest solution is to use dnsmasq for DNS. You then use the IP address of your engine as your DNS server, and in /etc/dnsmasq.conf you point to your regular DNS servers with "server=8.8.8.8" (for example). You will also need to open port 53 in iptables to enable computers on your home network to use this DNS server. To do this, add the line "-A INPUT -m state --state NEW -m udp -p udp --dport 53 -j ACCEPT" to your iptables configuration, remembering to add it also to any configuration files required to ensure that the option persists across reboots.

It is recommended to use static IP addresses for your server and nodes, but dnsmasq can also spoof reverse DNS for DHCP hosts and serve as a DHCP server for your local network if, for example, you wanted to use devices connecting over Wifi such as laptops as nodes.

<!-- -->

After an apparently successful installation of ovirt-engine, the service fails to start. In the system log, I see the error in /var/log/httpd/error.log:  

      [Fri Sep 21 13:37:03 2012] [error] (111)Connection refused: proxy: AJP: attempt to connect to 127.0.0.1:8009 (localhost) failed
      [Fri Sep 21 13:37:03 2012] [error] ap_proxy_connect_backend disabling worker for (localhost)
      [Fri Sep 21 13:37:03 2012] [error] proxy: AJP: failed to make connection to backend: localhost}}}

JBoss is failing to start up. There are several possible reasons for this. One potential reason is that you are trying to install the engine on a 32 bit server. If you have the following error in /var/log/ovirt-engine/console.log this may be your problem.

      Error: Could not create the Java Virtual Machine.
      Error: A fatal exception has occurred. Program will exit.

If this is the case, you will need to [modify the command line for Java by removing a 64 bit options](https://bugzilla.redhat.com/show_bug.cgi?id=852037).

<!-- -->

I am having trouble connecting to the database. In the system log, I get the following message from Postgres:  

      Sep 21 14:00:59 clare pg_ctl[5298]: FATAL:  could not create shared memory segment: Invalid argument
      Sep 21 14:00:59 clare pg_ctl[5298]: DETAIL:  Failed system call was shmget(key=5432001, size=36519936, 03600).
      Sep 21 14:00:59 clare pg_ctl[5298]: HINT:  This error usually means that PostgreSQL's request for a shared memory segment exceeded your kernel's SHMMAX parameter.  You can either reduce the request size or reconfigure the kernel with larger SHMMAX.  To reduce the request size (currently 36519936 bytes), reduce PostgreSQL's shared memory usage, perhaps by reducing shared_buffers or max_connections.
      Sep 21 14:00:59 clare pg_ctl[5298]: If the request size is already small, it's possible that it is less than your kernel's SHMMIN parameter, in which case raising the request size or reconfiguring SHMMIN is called for.
      Sep 21 14:00:59 clare pg_ctl[5298]: The PostgreSQL documentation contains more information about shared memory configuration.
      Sep 21 14:01:03 clare pg_ctl[5298]: pg_ctl: could not start server 

The system default size for the parameter SHMMAX is too small for the oVirt database. You should increase it to at least 64MB (64\*1024\*1024). To do this, run the command "sysctl -w kernel.shmmax=67108864" to modify the running system, and add "kernel.shmmax=67108864" to the file /etc/sysctl.conf to ensure that it persists through reboots.

<!-- -->

I installed ovirt engine and now DNS does not work any more  
If you let ovirt engine manage the iptables configuration for your server, it will close port 53 UDP which is required for DNS. You should add the line back to the iptables settings as mentioned above.

<!-- -->

I ran engine-setup once but there was a problem. So I ran engine-cleanup and re-ran engine-setup. After asking engine-setup to manage my ISO NFS domain, I get the message "/mnt/iso already exists in /etc/exports" and cannot continue  
The easiest way to get past this step is to open another tab, remove the line mentioned from /etc/exports, and retry this step.

<!-- -->

When building the oVirt-Engine with maven, some tests might fail  
Try running the maven clean install command with: -DskipTests

### Usage

When I add my host its status is unreachable. The logs indicate the the host is missing the 'engine' network.
Solution: you need to add a bridge to the host with the name 'engine'

## Node

### Installation

I am setting up the Engine to also run virtual machines through the management interface, but the engine is no longer working properly  
When you set up a host through ovirt-engine, the iptables configuration can be over-written with one which is appropriate for an ovirt node. Unfortunately, this configuration closes some ports which are required by oVirt Engine. The solution is to merge both config files - save the iptables configuration required by the engine, and add extra rules to open ports required by the node. The [ quick start guide](Quick Start Guide) has a copy of the iptables set-up required by the engine. If you are also using masqdns or bind for DNS on the engine, you should also open the port 53 in the final configuration. If you have opened any other ports (for example VNC) this is the time to add those to the iptables config file also.

<!-- -->

When installing a host via the engine interface, I get an error "rsync.x86_64 is not available"  
You are trying to set up a 32 bit host. oVirt requires 64 bit hosts with virtualisation extensions enabled to run KVM effectively.

<!-- -->

After installing a host through the engine, I get an error "<name> does not comply with the cluster Default networks, the following networks are missing on host: 'ovirtmgmt'"  
It seems that in certain situations (e.g. NetworkManager having been removed before install from engine?) the engine will not configure the bridge network. Instructions for configuring the 'ovirtmgmt' bridge interface can be found at: [Installing_VDSM_from_rpm#Configuring_the_bridge_Interface](Installing_VDSM_from_rpm#Configuring_the_bridge_Interface).

### Usage

## VDSM

### Installation

VDSM won't start and /var/log/messages reports detected unhandled Python exception in '/usr/share/vdsm/vdsm'  
Check the permissions on /var/log/vdsm/vdsm.log. The owner and group should be vdsm:kvm.

### Usage

Additional error details can be found in the VDSM log in **/var/log/vdsm/vdsm.log**

If vdsm logs show problems executing sudo commands, check that the /etc/sudoers file contains the group definitions created by the install process. They end with

      Defaults:vdsm !requiretty
      Defaults:vdsm !syslog

## engine-manage-domains

<span class="label label-warning"><big>ATTENTION: This page is obsoleted for >=ovirt-engine-3.5 by [Features/AAA](Features/AAA)</big></span>

### Adding an IPA domain to ovirt engine

Adding an IPA domain to ovirt engine fails with an error that begins:

      General error has occurednull
      java.lang.NegativeArraySizeException

We have seen a similar issue with OpenLDAP that required to set the minimum security strength factor (SSF) to 1 instead of the default 0. This default triggers a bug in the Java virtual machine Kerberos support.

IPA uses the 389 directory server, and it also has the possibility to configure this, as described here:

<http://directory.fedoraproject.org/wiki/Minimum_SSF_Setting>

To check that you can run a query like this in your IPA installation:

      # kinit admin
      # ldapsearch \
      -H `[`ldap://your_ipa_server`](ldap://your_ipa_server)` \
      -Y GSSAPI \
      -LLL \
      -b 'cn=config' \
      -s base \
      nsslapd-minssf

The output will probably be like this:

      dn: cn=config
      nsslapd-minssf: 0

The important thing there is the value 0. You can try to change it to 1, via LDAP or modifying directly the file /etc/dirsrv/slapd-YOUR-REALM/dse.ldif. Do this with the directory server stopped, and remember how to revert it in case things fail.

From: <http://lists.ovirt.org/pipermail/users/2013-November/017853.html>

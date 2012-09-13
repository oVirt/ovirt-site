---
title: NetworkManager Summit Oct 2012
authors: apuimedo
wiki_title: NetworkManager Summit Oct 2012
wiki_revision_count: 7
wiki_last_updated: 2012-09-19
wiki_warnings: references
---

# NetworkManager Summit Oct 2012

## VDSM current network configuration

The Virtual Desktop and Server Management daemon currently handles the host network configuration by means of manually editing the Red Hat style network configuration scripts. To achieve this purpose, we have a dedicated module that handles:

*   Configuration generation: Addition of vlans, bridges and bonds with the possibility of specifying custom settings, mainly MTU. (please mention STP, bond modes and options, ).

<!-- -->

*   Configuration modification: Bond splitting, network interface removal from bridge, etc.

<!-- -->

*   Configuration rollback: In case of loss of connectivity, we have the ability of rolling back the network configuration to the last known working set of configuration files.

This setup relies on the network scripts setting the variable NM_CONTROLLED to No. The reason behind this setting is that currently NetworkManager lacks a few features that are indispensable for the network configuration use cases that oVirt currently supports, namely:

*   Bridging,

<!-- -->

*   Virtual LANs,

<!-- -->

*   Bonding,

<!-- -->

*   Persistence of temporary connections.

The fact that oVirt currently does not use an external network configuration management layer imposes VDSM a big hurdle towards supporting multiple GNU/Linux distributions that rely on different network configuration systems. To bridge the current network compatibility gap, oVirt wants to leverage the experience and capabilities of NetworkManager in supporting network configuration in multiple distributions

## NetworkManager possible work-flows

NetworkManager currently has four interfaces:

1.  Distribution-independent keyfiles[1] plus nmcli: This is the most similar to VDSM's current approach of ad-hoc writing and managing network configuration scripts and then using command line interface commands for starting and stopping[2] the connections.
2.  D-BUS: Allows to access all the features of NetworkManager: Create, edit, delete connections as well as registering for events.
3.  Glib: Two convenience GObject wrap-around NM's D-BUS libraries exist: libnm-util and libnm-glib.
4.  Nm-applet: Graphical user interface present in all major desktop environments. It is of no consequence to VDSM because of the headless nature of most oVirt deployments.

## VDSM NetworkManager usage

The usage that VDSM would do of NetworkManager is:

1.  Defining temporary networks that can be persisted and made temporary back again[3].
2.  Creating/Adding/removing network interfaces to bridges[4].
3.  Creating/Adding/removing network interfaces to bonds[5].
4.  Setting/unsetting variables such as MTU (already possible)
5.  Adding removing vlans to the above kinds of networks[6].
6.  Register to the connections for detecting changes (already possible).
7.  Backup keyfiles for performing networking rollbacks on cases of connectivity loss (how is this different from your first bullet?).
8.  Retrieving network and network interfaces information.

## Open questions for NM guys

1.  Is the keyfile is a supported way for using NM? (stable API?)
2.  Is there a supported upgrade path from RHEL configuration?
3.  Is the following supported: ipaddr, dhcp, netmask,
4.  Gateway - How does NM going to handle routing? we currently use only gateway and we only on one network.
5.  We use tc for port mirroing and we need the device name, is it available for all device types?
6.  Getting statistics o the various devices (speed, tx/rx/drop rate), we need it per device nics, bonds, vlan etc.
7.  Would it be possible to manipulate a network configuration while it is being used?
8.  How they are managing the dependancies between the devices when starting/stopping a device? (What are the implications of editing a single network while there are number of networks dependant on a single NIC).
9.  Transactional network managment - is it going to be supported?
10. Does NM going to use netcf? because we are working with libvirt and having a common infrastructure is useful.

<references/>

[1] NetworkManager can work with both its own kind of file, named keyfiles and distribution specific files like Red Hat-like and debian-like distributions. A priori, it seems the most reasonable approach is to be as distribution-independent as possible (a counter argument is that adding another type of configuration file instead of using existing standards, causes proliferation of almost-equal files duplicated).

[2] There is a bug/feature proposal at <https://bugzilla.gnome.org/show_bug.cgi?id=682056> that works towards a full NetworkManager control interface through nmcli, that would eliminate the need of ad-hoc edition and management of the keyfiles

[3] There is currently a proposal for supporting this in <http://bugzilla.gnome.org/show_bug.cgi?id=682872>.

[4] There are some branches with work towards proper bridging as told by <https://bugzilla.gnome.org/show_bug.cgi?id=546197>.

[5] According to <https://bugzilla.gnome.org/show_bug.cgi?id=540995> there is bonding support but it may fail to start due to some dependency issues (also affecting the branches with bridge support) as described in <https://bugzilla.gnome.org/show_bug.cgi?id=682618>.

[6] It is supported but according to <https://bugzilla.gnome.org/show_bug.cgi?id=681109> might suffers of the same dependency issues as in the above footnote.

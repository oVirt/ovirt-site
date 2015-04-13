---
title: Vdsm TODO
category: vdsm
authors: aglitke, amuller, apuimedo, danken, ekohl, gvallarelli, ibarkan, phoracek
wiki_category: Vdsm
wiki_title: Vdsm TODO
wiki_revision_count: 122
wiki_last_updated: 2015-05-29
---

# Vdsm TODO

## What Can You Do for Vdsm

### Cleanup

#### infra

*   `` pylint -E `git ls-files | grep '.py$'` `` makes me cry. A lot of it is "only" about bad style, but we should clear it up and add it to our `make check-local`. We should grow up and pass `pychecker` too.

<!-- -->

*   Improve Vdsm portability. We are very much Fedora-centric at best. Do you want to have Vdsm on your pet distribution? Own that port!

<!-- -->

*   remove all usage of `sudo`, and replace with specific calls to `superVdsm`.

<!-- -->

*   Add git submodules for pyflakes and pep8 to vdsm. Control the specific version of each tool to use from within the vdsm build itself. This way we can make sure everyone is using the same version of the tools regardless of where vdsm is being built.
    -   See <https://github.com/jcrocholl/pep8> and <https://github.com/pyflakes/pyflakes/>

#### net

*   setupNetwork: stop passing kwarg to ifcfg files blindly. We should name all supported options and ignore the rest.

<!-- -->

*   drop force from network API

#### virt

*   drop self.destServer.getVmStats() call from migration sequence. It is raceful by design, and gives nothing that a migrationCreate does not.

<!-- -->

*   el7 hosts must not support clusterLevel<3.4

### Testing

*   enable coverage during Jenkins tests.

<!-- -->

*   run developer jobs on patches with +2 and V+1.

<!-- -->

*   Add `` `make distcheck` `` to Jenkins's jobs.

<!-- -->

*   Wrap all tests and fail a test that leaves an open file descriptor behind.

<!-- -->

*   add a unit test for qemuimg.rebase.

<!-- -->

*   make @permutations nestable

<!-- -->

*   test fileSD.scanDomains()

<!-- -->

*   pass test name as a hidden arg (sequence ID, maybe) to be loggeed in vdsm.log

<!-- -->

*   add migration tests

<!-- -->

*   test cannonizeHostPort

#### net

*   test that a dhcp-configured address is changes upon server request

<!-- -->

*   test tc add filter etc.

### Features

*   Support striping for disk images.

<!-- -->

*   let Vdsm install and run on hosts with no iscsid (report that iscsi is missing to Engine?)

<!-- -->

*   start Vdsm only when it receives a request (integrate with systemd)

<!-- -->

*   replace time.time() with monotonic_time() whenever possible.

#### Networking

*   ~~work in conjunction with Network Manager.~~ works in F20.

<!-- -->

*   Modify vdsm-tool restore-nets so that the management network (or the network with the default IPv4 route) is the last to be taken down and the first to be taken up to minimize the connectivity loss (very useful when accessing the machine remotely). Minimize vdsm-restore-net-config downtime for the default route network.

<!-- -->

*   ~~Split off the network restoration from vdsm startup so that it is performed in a different init service. This vdsm-network-restoration service should be oneshot and happen before network.service. <http://gerrit.ovirt.org/#/c/29441/>~~

<!-- -->

*   Fine-grained control on network-specific routes.

<!-- -->

*   Allow multiple setting IPv4 and IPv6 addresses per network device. (API changes is needed; we report multiple ipv6 addresses).

<!-- -->

*   -   models: support multiple IPv4 and/or IPv6 addresses

<!-- -->

*   get a single dump of all libvirt networks (no libvirt API for it yet...)

<!-- -->

*   fix privatevlan hook <http://gerrit.ovirt.org/#/c/24195/>

<!-- -->

*   before_ifcfg_write hook point + ifcfg hook

<!-- -->

*   return more fine grained error messages at the API level

<!-- -->

*   IPv4 routing table Id hash mechanism
    -   change the 'network' argument in routes to 'link scopee route'

<!-- -->

*   move source routing info to route.py (which uses netlink instead of using the default configurator). this will also simplify StaticSourceRoute

<!-- -->

*   support IPv6 in source routing

<!-- -->

*   use ElementTree instead of minidon in libvirt.py

<!-- -->

*   allow adding DNS configuration on static IP

<!-- -->

*   stop reading ifcfg files in netinfo.py. Gateway, ipaddr, bootproto, netmask, bond opts should be reported for <3.6 compatibility.

<!-- -->

*   Move vdsm-store-net-config logic to netconfbackpersistence.py

<!-- -->

*   Sync Layer 3 configuration with the new nl monitor.

<!-- -->

*   Make tests match the new package structure.

<!-- -->

*   Add configureIp to the configurators API so that Layer 3 can be configured in parallel after Layer 2 (and it gives much better modelling). Obviously, this isn't really possible in ifcfg without doing a two step write which is an ugly hack.

<!-- -->

*   extnet hook - pass portgroup <http://www.ovirt.org/VDSM-Hooks/network-nat>

<!-- -->

*   teaming

<!-- -->

*   persist mtu and vlan tag as integers

### refactoring

*   In vm.py, libvirtvm.py, clientIF.py there is a mess of prepare\*Path functions (end their respective teardowns), which is too complex to fathom. We have to convert all drive specifications (PDIV,GUID,path) into Drive object at the API entry.

<!-- -->

*   We store VM configuration/state in 3 different places: vm.conf (and its on-disk persistency), vm object and its vm.devices[], and within libvirt. This creates a hell of inconsistency problems. Think of Vdsm crashing right after hotpluggin a new disk. The added disk would not be monitored by Vdsm post-restart and not even by destination vdsm if the VM is migrated.

<!-- -->

*   lvm.PV.guid is devicemapper-owned piece of information; lvm has nothing to do with it, and jumps through [hoops](http://gerrit.ovirt.org/2940) to produce it. Instead, it should be produced by devicemapper and consumed directly by blockSD.

<!-- -->

*   ~~Define an API.VMState "enumeration" and use API.VMState.UP instead of the string 'Up'.~~

<!-- -->

*   <strike>factor betterPopen and betterThreading out of vdsm. They deserve a pipy review under the names [cPopen](https://pypi.python.org/pypi/cpopen) and [pthreading](http://pypi.python.org/pypi/pthreading) respectively.

<https://bugzilla.redhat.com/show_bug.cgi?id=903246></strike>

*   factor the task framework out of storage. Networking may need it, too.

<!-- -->

*   make storage_mailbox testable; use bytearrays instead of 1MiB strings; use fileUtils.DirectFile instead of forking /bin/dd all the time.

<!-- -->

*   split VM monitoring threads out of core Vdsm. Monitoring process would write to a memory-mapped file the most up to date values, which can be read by Vdsm on demand. This would reduce thread contentions in Vdsm and may simplify the code.

<!-- -->

*   split fenceNode to its own testable module.

### Bugzilla

*   pick one of the [<https://bugzilla.redhat.com/buglist.cgi?action=wrap&bug_file_loc>=&bug_file_loc_type=allwordssubstr&bug_id=&bug_id_type=anyexact&chfieldfrom=&chfieldto=Now&chfieldvalue=&component=vdsm&deadlinefrom=&deadlineto=&email1=&email2=&emailtype1=substring&emailtype2=substring&field0-0-0=flagtypes.name&keywords=&keywords_type=allwords&longdesc=&longdesc_type=allwordssubstr&short_desc=&short_desc_type=allwordssubstr&status_whiteboard=&status_whiteboard_type=allwordssubstr&type0-0-0=notsubstring&value0-0-0=rhel-6.2.0&votes=&=&bug_status=NEW NEW bugs], post a patch to [gerrit](http://gerrit.ovirt.org), and make the bug yours.

<Category:Vdsm>

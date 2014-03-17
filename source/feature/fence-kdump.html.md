---
title: Fence kdump
category: feature
authors: mperina
wiki_category: Feature
wiki_title: Fence kdump
wiki_revision_count: 93
wiki_last_updated: 2015-01-26
---

# Fence kdump

*It's only proposal, not yet finalized*

## About kdump

The kdump crash recovery mechanism provides way how to save kernel core dump to local or remote storage and reboot host afterwards so host will became operational asap. This is done by booting kdump kernel with specially configured initramfs from the context of regular kernel.

The kdump service support is contained in kexec-tools package:

1.  Configuration of kdump behavior is defined in `/etc/kdump.conf`
2.  The initramfs file can be created from `/etc/kdump.conf` file executing `kdumpctl restart` (Fedora 19) or `service kdump restart` (RHEL 6)

**Attention:** To enable kdump these two things are needed:

1.  Main kernel has to be booted with `crashkernel=` parameter
2.  kdump service has to be enabled and started

**Attention:** On RHEL6 you can specify `crashkernel=auto` (kernel calculates needed memory size based on RAM size), but this doesn't work on Fedora (you have to manually set memory size).

Following options can be specified in in `/etc/kdump.conf` file:

1.  Place where to store kernel core dump, currently it can be local, NFS, SSH or iSCSI (by default core dumps are saved to `/var/crash`)
2.  Action that will be executed if core dump collection failed, currently it can be reboot(default), halt, poweroff, shell or dump_to_rootfs
3.  Scripts/commands to be executed before/after core dump collection started/finished
4.  Extra binaries to include into initramfs
5.  And other not so important for oVirt options

## About Fence kdump

Fence kdump is a method how to prevent fencing a host during its kdump process. The tool is packaged in fence-agents-kdump package and it contains two commands:

*   `fence_kdump_send`
    -   It is executed in kdump kernel and it sends message using UDP protocol to specified host each time interval to notify that host is still in kdump process
*   `fence_kdump`
    -   It is executed on a host that tries to detect if some other host is in kdump process by receiving messages from specified host

The tool has following limitations that should be considered when using it in oVirt:

1.  `fence_kdump_send` can send packet only to IPs specified as its command line argument (it cannot send packets to level2 broadcast address)
2.  `fence_kdump` return success exit code only for one host at the time, messages from other hosts are ignored
3.  Package fence-agents-kdump doesn't contain any scripts to integrate them into kdump kernel

## Fencing flow with fence kdump

Fence kdump will be inserted into current fencing flow just before hard fencing, details are in [Automatic Fencing in oVirt 3.5](Automatic_Fencing#Automatic_Fencing_in_oVirt_3.5).

## Host configuration to enable fence_kdump

There's fence_kdump support in package kexec-tools 2.0.4.18, but unfortunately this support is tightly bound to Pacemaker software. Several patches has been proposed to kexec-tools package and you can found discussion about them in those threads:

*   [Adding support for manually configured fence_kdump](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000574.html)
*   [Adding support for manually configured fence_kdump v2](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000583.html)
*   [fence_kdump configuration should be in one directory](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000601.html)
*   [Rename is_fence_kdump to is_pcs_fence_kdump](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000602.html)
*   [Rename check_fence_kdump to check_pcs_cluster_rebuild](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000603.html)
*   [Move fence_kdump nodes filtering into separate function](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000604.html)
*   [Add support for fence_kdump in generic cluster](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000605.html)

If those patches will be accepted, fence_kdump will be configured automatically when executing `kdumpctl restart` if those conditions are satisfied:

*   `/usr/libexec/fence_kdump_send` exists and is executable
*   `/etc/sysconfig/fence_kdump_nodes` exists

File `/etc/sysconfig/fence_kdump_nodes` should contain list of hosts separated by space which fence_kdump notification should be sent to, for example:

      192.168.1.10 10.34.63.155

There's also optional configuration file `/etc/sysconfig/fence_kdump` which contains fence_kdump_send command line arguments stored in `FENCE_KDUMP_OPTS` variable, for example:

      FENCE_KDUMP_OPTS="-p 7410 -f auto -i 5"

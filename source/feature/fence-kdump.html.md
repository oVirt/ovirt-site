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

**Attention:** To enabled kdump these two things are needed:

1.  Main kernel has to be booted with `crashkernel=` parameter
2.  kdump service has to be enabled and started

Following options can be specified in in `/etc/kdump.conf` file:

1.  Place where to store kernel core dump, currently it can be local, NFS, SSH or iSCSI (by default core dumps are saved to `/var/crash`)
2.  Action that will be executed if core dump collection failed, currently it can be reboot(default), halt, poweroff, shell or dump_to_rootfs
3.  Scripts/commands to be executed before/after core dump collection started/finished
4.  Extra binaries to include into initramfs
5.  And other not so important for oVirt options

## About fence kdump

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

## Host configuration

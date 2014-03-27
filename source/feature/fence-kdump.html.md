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

There's fence_kdump support in package kexec-tools 2.0.4.18, but unfortunately this support is tightly bound to Pacemaker software. Bug [1078134](https://bugzilla.redhat.com/show_bug.cgi?id=1078134) was created, several patches has been proposed to kexec-tools package and you can found discussion about them in those threads:

*   [Adding support for manually configured fence_kdump](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000574.html)
*   [Adding support for manually configured fence_kdump v2](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000583.html)
*   [fence_kdump configuration should be in one directory](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000601.html)
*   [Add fence_kdump support for generic cluster v3](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000676.html)
*   [Rename FENCE_KDUMP_CONFIG to FENCE_KDUMP_CONFIG_FILE](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000679.html)
*   [Rename FENCE_KDUMP_NODES to FENCE_KDUMP_NODES_FILE](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000680.html)
*   [Move fence_kdump nodes filtering into separate function](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000681.html)
*   [Rename is_fence_kdump to is_pcs_fence_kdump](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000682.html)
*   [Rename check_fence_kdump to check_pcs_fence_kdump](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000683.html)
*   [Add fence_kdump support for generic clusters](https://lists.fedoraproject.org/pipermail/kexec/2014-March/000684.html)

If those patches from v3 will be accepted, fence_kdump will be configured automatically when executing `kdumpctl restart` if `fence_kdump_nodes` option in `kdump.conf` will contain at least one host to send notification to, for example:

      fence_kdump_nodes 192.168.1.10 10.34.63.155

If required other `fence_kdump_send` arguments can be set using `fence_kdump_args` option in `kdump.conf`, for example:

      fence_kdump_args -p 7410 -f auto -i 5"

## Receiving fence_kdump notifications

There are currently several possible methods how to receive fence_kdump notification and detect that host is in kdump flow:

1.  **Using fencing proxy same way as for hard fencing flow**
    -   On the fencing proxy host (selected host from same cluster/DC as Non Responsive host) we can execute fence_kdump using same API as other fencing agents and by analyzing exit code we will know if Non Responsive host is in kdump flow (exit code `0`) or not
    -   **Problems**
        -   Since fence_kdump_send can send notification only to predefined list of hosts, on each add/remove host from cluster we will need to update fence_kdump_nodes on each host in cluster and recreate initial ramding for kdump by executing `kdumpctl restart`
        -   Sending to notifications to huge list of hosts can be inefficient

2.  **Host, that engine is running on, will be used as fencing proxy**
    -   We can execute fence_kdump using same API as other fencing agents on the same host as engine is running on and by analyzing exit code we will know if Non Responsive host is in kdump flow (exit code `0`) or not
    -   **Problems**
        -   API to execute fencing agents on the same host as engine is running is not currently implemented, but it's requested as RFE [BZ891085](https://bugzilla.redhat.com/show_bug.cgi?id=891085)
        -   UDP connection to port 7410 from all hosts to the host that engine is running on should be allowed
        -   fence_kdump executable can detect only one host in kdump flow at the same time, notifications received from other hosts then requested are ignored. fence_kdump is executed with host name or IP and timeout to wait for notification from the host. So on large clusters when fence_kdump detection will be required for multiple hosts at once and those hosts won't be non responsive due to kdump flow, the timeout before hard fencing is executed will depend on number of hosts to detect kdump on.

3.  **New fence_kdump notification listener will be implemented**
    -   We can easily implement new listener that will be part of engine and which will receive all fence_kdump notification and will store them in some kind of the map, where key can be IP address of host and value the timestamp when last notification was received. Using this listener we can easily detect kdump flow on multiple hosts at the same time
    -   **Problems**
        -   UDP connection to port 7410 from all hosts to the host that engine is running on should be allowed

## Steps required to implement feature

*   Dependency to kexec-tools package should be added to vdsm package
*   VDSM part implementation
    -   Ability to detect status of kdump support for host
    -   Configure fence_kdump during host deploy
*   Engine part implementation
    -   Add default fence_kdump_send configuration to engine-config
    -   Add enable/disable fence_kdump to Add/Edit host dialog
    -   Show error when fence_kdump is enabled for host, but vdsm reports unknown/disabled in kdump status
    -   Implement selected fence_kdump listener mechanism (see [ Receiving fence_kdump notifications](#Receiving_fence_kdump_notifications))
*   oVirt Node
    -   Enable kdump support in kernel

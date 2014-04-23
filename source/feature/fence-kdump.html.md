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

The kdump service support is contained in **kexec-tools** package:

1.  Configuration of kdump behavior is defined in */etc/kdump.conf*
2.  The initramfs file can be created from */etc/kdump.conf* file executing *systemctl restart kdump* (Fedora) or *service kdump restart* (RHEL)

**Attention:** To enable kdump these two things are needed:

1.  Main kernel has to be booted with *crashkernel* parameter
2.  kdump service has to be enabled and started

**Attention:** On RHEL6 you can specify *crashkernel=auto* (kernel calculates needed memory size based on RAM size), but this doesn't work on Fedora (you have to manually set memory size).

Following options can be specified in in */etc/kdump.conf* file:

1.  Place where to store kernel core dump, currently it can be local, NFS, SSH or iSCSI (by default core dumps are saved to */var/crash*)
2.  Action that will be executed if core dump collection failed, currently it can be **reboot**(default), **halt**, **poweroff**, **shell** or **dump_to_rootfs**
3.  Scripts/commands to be executed before/after core dump collection started/finished
4.  Extra binaries to include into initramfs
5.  And other not so important for oVirt options

## About Fence kdump

Fence kdump is a method how to prevent fencing a host during its kdump process. The tool is packaged in **fence-agents-kdump** package and it contains two commands:

*   *fence_kdump_send*
    -   It is executed in kdump kernel and it sends message using UDP protocol to specified host each time interval to notify that host is still in kdump process
*   *fence_kdump*
    -   It is executed on a host that tries to detect if some other host is in kdump process by receiving messages from specified host

The tool has following limitations that should be considered when using it in oVirt:

1.  *fence_kdump_send* can send packet only to IPs specified as its command line argument (it cannot send packets to level2 broadcast address)
2.  *fence_kdump* return success exit code only for one host at the time, messages from other hosts are ignored
3.  Package **fence-agents-kdump** doesn't contain any scripts to integrate them into kdump kernel

## Host configuration to enable fence_kdump

There's fence_kdump support in package kexec-tools 2.0.4.18 (Fedora 20) and 2.0.0-273 (RHEL 6.5), but unfortunately this support is tightly bound to Pacemaker software.

Patches were sent to support fence_kdump configuration directly in */etc/kdump.conf* using these new options:

*   **fence_kdump_args**
    -   Command line arguments for *fence_kdump_send* (it can contain all valid arguments except hosts to send notification to)
*   **fence_kdump_nodes**
    -   List of cluster node(s) separated by space to send fence_kdump notification to (this option is mandatory to enable fence_kdump)

If option **fence_kdump_nodes** will contain at least one host to send notification to, for example:

      fence_kdump_nodes 192.168.1.10 10.34.63.155

fence_kdump will be configured.

If required, other *fence_kdump_send* arguments can be set using **fence_kdump_args** option, for example:

      fence_kdump_args -p 7410 -f auto -i 5"

Patches are managed using those RFEs:

*   Fedora 20: [BZ1078134](https://bugzilla.redhat.com/1078134)
*   RHEL 6.6: [BZ1083938](https://bugzilla.redhat.com/1083938)
*   RHEL 7.1: [BZ1086988](https://bugzilla.redhat.com/1086988)

## Receiving fence_kdump notifications

There are currently several possible methods how to receive fence_kdump notification and detect that host is in kdump flow:

1.  **Using fencing proxy same way as for hard fencing flow**
    -   On the fencing proxy host (selected host from same cluster/DC as Non Responsive host) we can execute fence_kdump using same API as other fencing agents and by analyzing exit code we will know if Non Responsive host is in kdump flow (exit code *0*) or not
    -   **Problems**
        -   Since *fence_kdump_send* can send notification only to predefined list of hosts, on each add/remove host from cluster we will need to update fence_kdump_nodes on each host in cluster and recreate initial ramding for kdump by restarting kdump service.
        -   Sending to notifications to huge list of hosts can be inefficient

2.  **Host, that engine is running on, will be used as fencing proxy**
    -   We can execute *fence_kdump* using same API as other fencing agents on the same host as engine is running on and by analyzing exit code we will know if Non Responsive host is in kdump flow (exit code *0*) or not
    -   **Problems**
        -   API to execute fencing agents on the same host as engine is running is not currently implemented, but it's requested as RFE [BZ891085](https://bugzilla.redhat.com/show_bug.cgi?id=891085)
        -   UDP connection to port 7410 from all hosts to the host that engine is running on should be allowed
        -   *fence_kdump* can detect only one host in kdump flow at the same time, notifications received from other hosts then requested are ignored. *fence_kdump* is executed with host name or IP and timeout to wait for notification from the host. So on large clusters when fence_kdump detection will be required for multiple hosts at once and those hosts won't be non responsive due to kdump flow, the timeout before hard fencing is executed will depend on number of hosts to detect kdump on.

3.  **New fence_kdump notification listener executed inside engine will be implemented**
    -   We can easily implement new listener that will be part of engine and which will receive all fence_kdump notification and will store them in some kind of the map, where key can be IP address of host and value the timestamp when last notification was received. Using this listener we can easily detect kdump flow on multiple hosts at the same time
    -   **Problems**
        -   UDP connection to port 7410 from all hosts to the host that engine is running on should be allowed
        -   May introduce security threat to engine since fence_kdump notification are sent using UDP protocol

4.  **New standalone fence_kdump notification listener will be implemented**
    -   We can easily implement new standalone listener which will receive all fence_kdump notification and will store them in some kind of the map, where key can be IP address of host and value the timestamp when last notification was received. Using this listener we can easily detect kdump flow on multiple hosts at the same time
    -   **Problems**
        -   UDP connection to port 7410 from all hosts to the host that listener is running on should be allowed
        -   We will need to implement API for communication between engine and standalone listener

We decided to implement new standalone listener running on the same host as engine (option 4).

## New standalone fence_kdump listener

The new standalong listener will be implemented with these features:

*   The first listener thread will:
    1.  Receive a message and check if it's valid fence_kdump message (compares magic number and message version (currently only *1*) in the same way as in *fence_kdump* command).
    2.  If message is valid, send IP address, timestamp and empty status (fence_kdump protocol version 1 doesn't provide status of host kdump flow) to queue.
*   In another thread queue will be processed:
    1.  Get message from queue
    2.  If the status is empty
        1.  Get most recent record from **fence_kdump_messages** table in engine database with proper IP
        2.  If no record is returned or *record timestamp + NextKdumpTimeout < message timestamp*, set status to **STARTED**, otherwise set status to **DUMPING**

    3.  Write IP, message timestamp and status to **fence_kdump_messages** table
*   Another thread (it will be scheduled to execute every 30 seconds) will take care of finishing fence_kdump process status:
    1.  Select the most recent records from **fence_kdump_messages** table for all IP
    2.  For each IP if record status is not **FINISHED** and *record_timestamp + KdumpFinishedTimeout < current timestamp*, write new record to **fence_kdump_messages** table with status **FINISHED**
*   Last thread will be scheduler to execute every 5 seconds and it will be used as a heartbeat status for engine, that fence_kdump listener is alive:
    1.  It will store current timestamp into **fence_kdump_messages** table for IP value *fence_kdump_listener*

The listener will use two config values:

*   **NextKdumpTimeout**
    -   Defines minimum timeout allowed between one kdump flow finished and new one started for one host
    -   Default 60 seconds
*   **KdumpFinishedTimeout**
    -   Defines maximum timeout after last received message from kdumping hosts after which the host kdump flow is marked as FINISHED
    -   Default 30 seconds

It's supposed that fence_kdump_send will send messages every 5 seconds.

For oVirt 3.5 we will rely on current fence_kdump capabilities, but for next oVirt version (3.6/4.0) we plan to send more patches to **fence-agents-kdump** and **kexec-tools** which will extend fence_kdump behaviour to be able:

*   To send message sequence number
*   To include unique host identification (host UUID) so we will not have to rely on DNS to pair incoming message with existing hosts
*   To include HMAC signature to message
*   To receive kdump status notification (STARTED, DUMPING, FINISHED, ERROR, ...) and send the status
*   To use TCP protocol

## Fencing flow with fence_kdump

Host kdump flow detection will be inserted into automatic fencing flow just before execution of hard fencing:

1.  On first network failure, host status will change to **Connecting**
2.  If the host doesn't respond during time interval, execute SSH Soft Fencing. If command execution wasn't successful, proceed to hard fencing enabled check immediately (step 4).
3.  If the host doesn't recover during time interval, proceed hard fencing enabled check (step 4).
4.  If hard fencing is not enabled for host, set host status to **Non Responsive** and exit fencing flow
5.  If fence kdump is not enabled for the host, execute hard fencing immediately (step 8)
6.  If standalone fence_kdump listener is not alive, execute hard fencing immediately (step 8)
7.  Execute fence_kdump detection
    1.  Store current timestamp into *kdump_timestamp* variable
    2.  Resolve host IP
    3.  Repeat following:
        1.  Get most recent record from **fence_kdump_messages** table for resolved IP
        2.  If *record timestamp >= kdump_timestamp* and record status is **FINISHED**, set host status to **Reboot** and exit fencing flow
        3.  If *record timestamp >= kdump_timestamp* and record status is **STARTED** or **DUMPING**, wait **FenceKdumpMessageInterval** and continue the loop
        4.  if *record timestamp < kdump_timestamp* and *current timestamp >= kdump_timestamp + KdumpStartedTimeout*, continue with hard fencing (step 8)
        5.  if no record returned, wait **FenceKdumpMessageInterval** and continue the loop

8.  Execute hard fencing for host

Following config values are used:

*   **FenceKdumpMessageInterval**
    -   Defines the interval between messages sent by *fence_kdump_send*
    -   Default 5 seconds
*   **KdumpStartedTimeout**
    -   Defines maximum timeout to wait until 1st message from kdumping host is received
    -   Default 30 seconds

## Open questions/issues

1.  **Does kdump support all network configuration we need (bridge, VLAN, ...)?**
    -   Bridges are supported, I successfully tested fence_kdump with *ovirtmgmt* bridge
    -   According to [BZ752458](https://bugzilla.redhat.com/show_bug.cgi?id=752458) VLANs are supported

2.  **Fence_kdump uses port 7410 by default (can be changed using command line argument) which is reserved for Ionix Network Monitor. Should we used by default another port?**
3.  **Fence_kdump configuration will be updated only on host redeploy. Is it enough?**
4.  **Kdump configuration will need to be refreshed after network configuration is updated because network configuration to reach host for fence_kdump is stored inside kdump initial ramdisk**
    -   Can be achieved by restarting kdump service, but this call should be added to VDSM module which is responsible for network configuration.

5.  **We plan to update only fence_kdump options in kdump configuration, host admin will be responsible to configure other options and restart kdump service manually when done. In order to successfully report kdump status to engine this operation should be done only when host is in Maintenance.**
6.  **Host from which fence_kdump message came is identified by IP address, but inside engine FQDN or IP of host is saved. Is it OK to resolve FQDN during kdump detection or do we need to save IP address of host in engine?**
7.  **We are able only to allow access to fence_kdump port, but we cannot easily identify which IPs can access this port. This is task for administrator to modify firewall rules for enhanced security**

## Implementation status

| Area                                                                                    | Task                                       | Status |
|-----------------------------------------------------------------------------------------|--------------------------------------------|--------|
| kexec-tools                                                                             |
| Patches for Fedora                                                                      | Done, included in kexec-tools >= 2.0.4-27 |
| Patches for RHEL 6.6                                                                    | Accepted, waiting to be merged             |
| Patches for RHEL 7.1                                                                    | Accepted, waiting to be merged             |
|                                                                                         |
| vdsm                                                                                    |
| Detect status of kdump support for host                                                 | Patch on review                            |
| Add dependency to kexec-tools package                                                   | Waiting for RHEL package                   |
| Configure fence_kdump during host deploy                                               |                                            |
|                                                                                         |
| engine                                                                                  |
| Display status of kdump configuration for host                                          | Done                                       |
| Enable/disable kdump detection in Host Power Management configuration                   | Done                                       |
| Add fence_kdump_send configuration to vdc_options                                    | Coding                                     |
| Display warning when host kdump detection is enabled, but kdump not configured for host |                                            |
| Implement standalone fence_kdump listener                                              | Coding                                     |
| Add fence_kdump handling to fencing flow                                               | Coding                                     |
|                                                                                         |
| engine-setup                                                                            |
| Configure fence_kdump listener port during setup                                       |                                            |
| Add firewall rule for fence_kdump listener                                             |                                            |
|                                                                                         |
| ovirt-node                                                                              |
| Enable kdump support in kernel                                                          |                                            |
| Included kexec-tools package with fence_kdump configuration support                    |                                            |

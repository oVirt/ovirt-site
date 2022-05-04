---
title: Fence kdump
category: feature
authors: mperina
---

# Fence kdump

## Summary

Feature prevents fencing of host which is currenlty dumping to preserve crashdump information.

## Owner

*   Name: Martin Peřina
*   Email: mperina@redhat.com

## Current status

Feature completed and included in oVirt 3.5

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

      fence_kdump_nodes 192.168.1.10 10.34.63.155

fence_kdump will be configured.

If required, other *fence_kdump_send* arguments can be set using **fence_kdump_args** option, for example:

      fence_kdump_args -p 7410 -f auto -i 5"

Patches are managed using those RFEs:

*   Fedora 20: [BZ1078134](https://bugzilla.redhat.com/show_bug.cgi?id=1078134)
*   RHEL 6.6: [BZ1083938](https://bugzilla.redhat.com/show_bug.cgi?id=1083938)
*   RHEL 7.1: [BZ1086988](https://bugzilla.redhat.com/show_bug.cgi?id=1086988)

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

The new standalone listener will be implemented with these features:

*   Base flow for received messages
    1.  Receive a message and check if it's valid fence_kdump message (compare magic number and message version (currently only *1*) in the same way as in *fence_kdump* command).
    2.  If message is valid, find host id and determine status of kdump flow (based on messages received in the past it's set to *started* or *dumping*)
    3.  Store host id, sender IP:port and status to database.
*   Finish host's kdump flow
    -   For all hosts with status *dumping* test if last received message in not older than *KDUMP_FINISHED_TIMEOUT* (default 30 sec). If so, save record with status *finished* and current timestamp for the host to the database
*   Listener heartbeat
    -   Periodically every *HEARTBEAT_INTERVAL* (default 10 sec) save current timestamp to database for host *fence_kdump_listener* (this will be checked by engine to know that listener is alive)

The whole flow of fence_kdump listener shows [ fence_kdump listener flow diagram](/images/wiki/Fence-kdump-listener-flow.png).

The listener will use these configuration options:

*   **LISTENER_ADDRESS**
    -   Defines the IP address to receive fence_kdump messages on.
    -   Default: *0.0.0.0*
*   **LISTENER_PORT**
    -   Defines the port to receive fence_kdump messages on.
    -   Default: *7410*
*   **HEARTBEAT_INTERVAL**
    -   Defines the interval in seconds of listener's heartbeat updates.
    -   Default: *30*
*   **SESSION_SYNC_INTERVAL**
    -   Defines the interval in seconds to synchronize listener's host kdumping sessions in memory to database.
    -   Default: *5*
*   **REOPEN_DB_CONNECTION_INTERVAL**
    -   Defines the interval in seconds to reopen database connection which was previously unavailable.
    -   Default: *30*
*   **KDUMP_FINISHED_TIMEOUT**
    -   Defines maximum timeout in seconds after last received message from kdumping hosts after which the host kdump flow is marked as FINISHED.
    -   Default *60*

For oVirt 3.5 we will rely on current fence_kdump capabilities, but for next oVirt version (3.6/4.0) we plan to send more patches to **fence-agents-kdump** and **kexec-tools** which will extend fence_kdump behaviour to be able:

*   To send message sequence number
*   To include unique host identification (host UUID) so we will not have to rely on DNS to pair incoming message with existing hosts
*   To include HMAC signature to message
*   To receive kdump status notification (STARTED, DUMPING, FINISHED, ERROR, ...) and send the status
*   To use TCP protocol

## Fencing flow with fence_kdump

The whole flow is displayed in [ fencing flow with kdump detection](/images/wiki/Fencing-flow-with-kdump-detection.png).

Following config values are used:

*   **FenceKdumpDestinationAddress**
    -   Defines the hostname(s) or IP address(es) to send fence_kdump messages to. If empty, engine FQDN is used.
    -   Default: empty string, so engine FQDN is used.
*   **FenceKdumpDestinationPort**
    -   Defines the port to send fence_kdump messages to.
    -   Default: *7410*
*   **FenceKdumpMessageInterval**
    -   Defines interval in seconds between messages sent by fence_kdump.
    -   Default: *5*
*   **FenceKdumpListenerTimeout**
    -   Defines max timeout in seconds since last heartbeat to consider fence_kdump listener alive.
    -   Default: *90*
*   **KdumpStartedTimeout**
    -   Defines maximum timeout in seconds to wait until 1st message from kdumping host is received (to detect that host kdump flow started).
    -   Default: *30*

## Open questions/issues

1.  **Does kdump support all network configuration we need (bridge, VLAN, ...)?**
    -   Bridges are supported, I successfully tested fence_kdump with *ovirtmgmt* bridge
    -   According to [BZ752458](https://bugzilla.redhat.com/show_bug.cgi?id=752458) VLANs are supported

2.  **Fence_kdump uses port 7410 by default (can be changed using command line argument) which is reserved for Ionix Network Monitor. Should we used by default another port?**
3.  **Fence_kdump configuration will be updated only on host redeploy. Is it enough?**
4.  **Kdump configuration will need to be refreshed after network configuration is updated because network configuration to reach host for fence_kdump is stored inside kdump initial ramdisk**
    -   Can be achieved by restarting kdump service, but this call should be added to VDSM module which is responsible for network configuration.

5.  **We plan to update only fence_kdump options in kdump configuration, host admin will be responsible to configure other options and restart kdump service manually when done. In order to successfully report kdump status to engine this operation should be done only when host is in Maintenance.**
6.  **\1**
7.  **We are able only to allow access to fence_kdump port, but we cannot easily identify which IPs can access this port. This is task for administrator to modify firewall rules for enhanced security**

## Implementation status

| Area                                                                                  | Task                                          | Status |
|---------------------------------------------------------------------------------------|-----------------------------------------------|--------|
| kexec-tools                                                                           |
| Patches for Fedora 20                                                                 | Done, included in kexec-tools >= 2.0.4-27    |
| Patches for RHEL 6.6                                                                  | Done, included in kexec-tools >= 2.0.0-273.1 |
| Patches for RHEL 7.1                                                                  | Done, included in kexec-tools >= 2.0.4-32.1  |
|                                                                                       |
| vdsm                                                                                  |
| Detect status of kdump support for host                                               | Done                                          |
|                                                                                       |
| ovirt-host-deploy                                                                     |
| Create plugin to configure fence_kdump during host deploy                            | Done                                          |
|                                                                                       |
| engine                                                                                |
| Display status of kdump configuration for host                                        | Done                                          |
| Enable/disable kdump detection in Host Power Management configuration                 | Done                                          |
| Add fence_kdump_send configuration to vdc_options                                  | Done                                          |
| Implement standalone fence_kdump listener                                            | Done                                          |
| Add fence_kdump handling to fencing flow                                             | Done                                          |
| Execute fence_kdump configuration during host deploy                                 | Done                                          |
| Display error when host kdump detection is enabled, but kdump not configured for host | Done                                          |
|                                                                                       |
| engine-setup                                                                          |
| Configure fence_kdump listener host and port during setup                            | Done                                          |
| Add firewall rule for fence_kdump listener                                           | Done                                          |
|                                                                                       |
| ovirt-node                                                                            |
| Enable kdump support in kernel                                                        | Done                                          |
| Include kexec-tools package with fence_kdump configuration support                   | Done                                          |

## Testing

### Testing notes

1.  Host should be booted with *crashkernel* command line parameter otherwise kdump service will not start. For more info about this parameter please take a look at [Configuring the Memory Usage](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/s2-kdump-configuration-cli).
2.  If you need to slow down kdump flow for testing purposes (in the case you have a host with small amount of RAM or crashdump destination is on local disk), you can do this:
    -   Create simple shell script `/usr/bin/delay-kdump`:

        ```bash
        #!/bin/sh

        TIMEOUT=90

        echo "Sleeping ..."
        /bin/sleep ${TIMEOUT}s
        ```

    -   Update `/etc/kdump.conf` with those options and restart kdump service:
            kdump_post /usr/bin/delay-kdump
            extra_bins /bin/sleep

3.  Progress of kdump flow on host can be seen on host's console with possible remote access using IPMI.
4.  If you want to simulate kernel crash dump, you have to:
    -   Enable kernel SysRQ mechanism:

        ```bash
        sysctl -w kernel.sysrq=1
        ```

    -   Initiate kernel crashdump:

        ```bash
        echo c > /proc/sysrq-trigger
        ```

### Testing scenarios

1.  Installation tests
    1.  **Adding a host with *Detect kdump flow* set to on and without *crashkernel* command line parameter**
        -   **Result:** host installation is OK, but warning message is displayed in Events tab and Audit log

    2.  **Adding a host with *Detect kdump flow* set to on, with *crashkernel* command line parameter, but without required version of *kexec-tools* package**
        -   **Result:** host installation is OK, but warning message is displayed in Events tab and Audit log

    3.  **Adding a host with *Detect kdump flow* set to on, with *crashkernel* command line parameter and with required version of *kexec-tools* package**
        -   **Result:** host installation is OK, in *General* tab of host detail view you should see *Kdump Status: Enabled*

    4.  **Adding a oVirt node host with *Detect kdump flow* set to on, with *crashkernel* command line parameter and with required version of *kexec-tools* package**
        -   **Result:** host installation is OK, in *General* tab of host detail view you should see *Kdump Status: Enabled*

2.  Kdump detection tests
    1.  **Crashdumping a host with kdump detection disabled**
        -   **Prerequisities:** host was successfully deployed with *Detect kdump flow* set to off, fence_kdump listener is running
        -   **Result:** Host changes its status *Up* -> *Connecting* -> *Non Responsive* -> *Reboot* -> *Non Responsive* -> *Up*, hard fencing is executed

    2.  **Crashdumping a host with kdump detection enabled**
        -   **Prerequisities:** host was successfully deployed with *Detect kdump flow* set to on, fence_kdump listener is running
        -   **Result:** Host changes its status *Up* -> *Connecting* -> *Non Responsive* -> *Kdumping* -> *Non Responsive* -> *Up*, hard fencing is not executed, there are messages in *Events* tab *Kdump flow detected on host* and *Kdump flow finished on host*

    3.  **Crashdumping a host with kdump detection enabled but fence_kdump listener down**
        -   **Prerequisities:** host was successfully deployed with *Detect kdump flow* set to on, fence_kdump listener is not running
        -   **Result:** Host changes its status *Up* -> *Connecting* -> *Non Responsive* -> *Reboot* -> *Non Responsive* -> *Up*, hard fencing is executed, there's message in *Events* tab *Kdump detection for host had started, but fence_kdump listener is not running*

    4.  **Host with kdump detection enabled, fence_kdump listener is running, but network between engine and host is down**
        -   **Prerequisities:** host was successfully deployed with *Detect kdump flow* set to on, fence_kdump listener is running, alter firewall rules on engine to drop everything coming from host's IP address
        -   **Result:** Host changes its status *Up* -> *Connecting* -> *Non Responsive* -> *Reboot* -> *Non Responsive* -> *Up*, hard fencing is executed, there's message in *Events* tab *Kdump flow not detected on host*

    5.  **Crashdumping a host with kdump detection enabled, fence_kdump listener is running, stop fence_kdump listener during kdump**
        -   **Prerequisities:** host was successfully deployed with *Detect kdump flow* set to on, fence_kdump listener is running
        -   **Actions:** When host status is changed to *Kdumping*, stop fence_kdump listener
        -   **Result:** Host changes its status *Up* -> *Connecting* -> *Non Responsive* -> *Kdumping* -> *Reboot* -> *Non Responsive* -> *Up*, hard fencing is executed, there are messages in *Events* tab *Kdump flow detected on host* and *Kdump detection for host had started, but fence_kdump listener is not running*

    6.  **Crashdumping a host with kdump detection enabled, fence_kdump listener is running, restart engine during kdump**
        -   **Prerequisities:** host was successfully deployed with *Detect kdump flow* set to on, fence_kdump listener is running
        -   **Actions:** When host status is changed to *Kdumping*, restart engine
        -   **Result:** Host changes its status *Up* -> *Connecting* -> *Non Responsive* -> *Kdumping*, hard fencing is not executed, there are messages in *Events* tab *Kdump flow detected on host*, after engine restart host stays in *Kdumping* status for the period of *DisableFenceAtStartupInSec* seconds, after that there are messages in *Events* tab *Kdump flow detected on host* and *Kdump flow finished on host* and changes status *Kdumping* -> *Non Responsive* -> *Up*


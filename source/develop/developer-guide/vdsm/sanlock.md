---
title: SANLock
category: vdsm
authors: danken, fsimonce, teigland
---

# SAN Lock

## Introduction

The sanlock daemon manages leases for applications running on a cluster of hosts with shared storage. All lease management and coordination is done through reading and writing blocks on the shared storage. Two types of leases are used, each based on a different algorithm:

*   **delta leases** are slow to acquire and require regular i/o to shared storage. A delta lease exists in a single sector of storage. Acquiring a delta lease involves reads and writes to that sector separated by specific delays. Once acquired, a lease must be renewed by updating a timestamp in the sector regularly. sanlock uses a delta lease internally to hold a lease on a host_id. host_id leases prevent two hosts from using the same host_id and provide basic host liveliness information based on the renewals.

<!-- -->

*   **paxos leases** are generally fast to acquire and sanlock makes them available to applications as general purpose resource leases. A paxos lease exists in 1MB of shared storage (8MB for 4k sectors). Acquiring a paxos lease involves reads and writes to max_hosts (2000) sectors in a specific sequence specified by the Disk Paxos algorithm. paxos leases use host_id’s internally to indicate the owner of the lease, and the algorithm fails if different hosts use the same host_id. So, delta leases provide the unique host_id’s used in paxos leases. paxos leases also refer to delta leases to check if a host_id is alive.

Before sanlock can be used, the user must assign each host a host_id, which is a number between 1 and 2000. Two hosts should not be given the same host_id (even though delta leases attempt to detect this mistake). sanlock views a pool of storage as a "lockspace". Each distinct pool of storage, e.g. from different sources, would typically be defined as a separate lockspace, with a unique lockspace name.

Part of this storage space must be reserved and initialized for sanlock to store delta leases. Each host that wants to use the lockspace must first acquire a delta lease on its host_id number within the lockspace. (See the add_lockspace action/api). The space required for 2000 delta leases in the lockspace (for 2000 possible host_id’s) is 1MB (8MB for 4k sectors). (This is the same size required for a single paxos lease).

For more information, see

*   sanlock(8)
*   wdmd(8)
*   <https://pagure.io/sanlock/blob/master/f/README.rst>

## VDSM And SANLock

VDSM is taking advantage of SANLock since [Storage Domain Version 3](/develop/storage/storage-domain-versions.html#storage-domain-version-3) for the following tasks:

*   Acquiring the SPM resource
*   Acquiring the Volumes resources

**Note:** In all the previous [Storage Domain Versions](/develop/storage/storage-domain-versions.html) SANLock is never activated.

### Lockspaces and Resources In VDSM

VDSM assigns a lockspace to each Storage Domain using the UUID as name. Eg: for the Block Storage Domain '1dfcd18e-b179-4b95-aef6-f0fba1a3db45' the lockspace is

      1dfcd18e-b179-4b95-aef6-f0fba1a3db45:0:/dev/1dfcd18e-b179-4b95-aef6-f0fba1a3db45/ids:0

For each Volume present in the Storage Domain it is created a resource and its lease is allocated:

*   **Block Domains:** in the leases LV with a pre-determined offset (depending on the metadata offset)
*   **File Domains:** in a file with extension ".lease" with the same name and location of the Volume file

The SPM resource is located instead on the "leases" file/LV with offset 0 (temporary, it will be moved to a different offset to allow a seamless domain upgrade).

### Libvirt XML Including SANLock Resources

The XML that VDSM prepares for libvirt to run a VM on a [Storage Domain Version 3](/develop/storage/storage-domain-versions.html#storage-domain-version-3) includes all the information required to acquire the Volumes resources:

<?xml version="1.0" encoding="utf-8"?>
<domain type="kvm">
`  `<name>`vm1`</name>
        ...
`  `<devices>
          ...
`    `<disk device="disk" snapshot="no" type="block">
            

            ...
`    `</disk>
`    `<lease>
`      `<key>`c29ca345-4aab-42f1-97c5-bdf967073d22`</key>
`      `<lockspace>`7b1cff35-9482-4946-9654-adf1db5ecd10`</lockspace>
`      `<target offset="109051904" path="/dev/7b1cff35-9482-4946-9654-adf1db5ecd10/leases"/>
`    `</lease>
          ...
`  `</devices>
</domain>

For more information about how libvirt is handling the leases please refer to its specific documentation [1] [2]

### VDSM SANLock Diagrams

On **connectStoragePool** VDSM is acquiring the lockspace on all the Storage Domains that are part of the Pool. The acquired lockspaces are used later on by libvirt to acquire the volumes for the virtual machines.

![](/images/wiki/SANLockDiagram1.png)

## sanlock log file debugging

    /var/log/messages

includes important warnings or errors from sanlock or wdmd or the /dev/watchdog driver.
Any sanlock or wdmd messages found here should be investigated.

    /var/log/sanlock.log

includes all the sanlock warnings and errors from /var/log/messages,
plus a record of each lockspace and resource that sanlock has managed.

**lockspace** entry in /var/log/sanlock.log:

    TIME sNUM lockspace LNAME:HOSTID:/dev/VG/LV:OFFSET

*   TIME -- local monotonic time

<!-- -->

*   sNUM -- NUM is a short integer abbreviation for this lockspace uuid. sNUM is used in other log messages to refer to this lockspace. NUM is reset to 1 each time the sanlock daemon is started.

<!-- -->

*   LNAME -- the lockspace name, which vdsm sets to the uuid for this lockspace

<!-- -->

*   HOSTID -- the local host id

<!-- -->

*   /dev/VG/LV:OFFSET -- the disk area where this lockspace exists

**resource** entry in /var/log/sanlock.log:

    TIME sNUM:rNUM resource LNAME:RNAME:/dev/VG/LV:OFFSET for X,Y,PID

*   TIME -- local monotonic time

<!-- -->

*   sNUM -- the short lockspace identifier (see above)

<!-- -->

*   rNUM -- NUM is a short integer abbreviation for this resource uuid. rNUM is used in other log messages to refer to this lockspace. NUM is reset to 1 each time the sanlock daemon is started.

<!-- -->

*   LNAME -- the lockspace name (uuid from vdsm)

<!-- -->

*   RNAME -- the resource name, which vdsm sets to the uuid for this resource

<!-- -->

*   /dev/VG/LV:OFFSET -- the disk area where this resource exists

<!-- -->

*   X,Y,PID -- PID is the process which is requesting this lease, X is the internal connection id used by the pid, Y is the fd number used for the connection

**changing logging levels**

The amount of information written to /var/log/messages or /var/log/sanlock.log can be controlled with two sanlock daemon command line options:

`-L pri` write logging at priority level and up to logfile (-1 none)

`-S pri` write logging at priority level and up to syslog (-1 none)

`pri` is an integer corresponding to log priorities defined in `/usr/include/sys/syslog.h`:

    #define LOG_EMERG       0       /* system is unusable */
    #define LOG_ALERT       1       /* action must be taken immediately */
    #define LOG_CRIT        2       /* critical conditions */
    #define LOG_ERR         3       /* error conditions */
    #define LOG_WARNING     4       /* warning conditions */
    #define LOG_NOTICE      5       /* normal but significant condition */
    #define LOG_INFO        6       /* informational */
    #define LOG_DEBUG       7       /* debug-level messages */

Defaults are

*   `-L 4` so log messages from WARNING to EMERG are written to /var/log/sanlock.log
*   `-S 3` so log messages from ERR to EMERG are written to /var/log/messages

So, to write all debug messages to /var/log/sanlock.log, for example, you would use -L 7

## sanlock response to storage problems

The cause of sanlock recovery is loss of storage connection or slow i/o response times from storage. "Storage" refers to the device or file where sanlock leases are written.

The sanlock daemon continually writes to storage at a fixed interval to renew its leases. If sanlock i/o to storage does not complete within a fixed time, the sanlock daemon will enter recovery. Recovery begins with the sanlock daemon attempting to kill(SIGTERM) any pid's using leases on the affected storage. If any pid does not exit after 10 SIGTERM's over 10 seconds, sanlock will then attempt kill(SIGKILL). If pid's still do not exit within a fixed time, the watchdog will fire, resetting the host. If all pid's do exit within the necessary time, the watchdog will be renewed and will not fire.

Before recovery timeouts are reached, sanlock will log errors related to failed renewals and leases getting too old. If these are seen, it may be wise to reduce the i/o load on storage or the host, to avoid crossing the threshold into an actual recovery.

       14:27:54 / 13256 (sanlock successfully renews lease)
       14:27:58 / 13260 (storage connection blocked to begin test)
       14:28:14 / 13276 (sanlock starts next scheduled lease renewal 20 sec after last)

*   background for following messages, not log messages

       14:28:15 sanlock[123]: 13277 LNAME aio collect 0x7f7f7c0008c0:0x7f7f7c0008d0:0x7f7f9dd72000 result -5:0 match res
       14:28:15 sanlock[123]: 13277 s1 delta_renew read rv -5 offset 0 /dev/VG/LV
       14:28:15 sanlock[123]: 13277 s1 renewal error -5 delta_length 0 last_success 13256

*   sanlock reports first i/o error
*   First error could be as late as 14:28:24 / 13286 if i/o times out instead of quickly failing.
*   These messages repeat for each i/o error, with frequency between twice a second and once every 10 seconds.
*   Some or all of these lines may appear, depending on the type of i/o problems.

       14:28:54 sanlock[123]: 13316 s1 check_our_lease warning 60 last_success 13256
       14:28:55 sanlock[123]: 13317 s1 check_our_lease warning 61 last_success 13256
       ...
       14:29:13 sanlock[123]: 13335 s1 check_our_lease warning 79 last_success 13256

*   io_renewal_warn seconds (60) after the last successful renewal, lease age warnings start appearing, once a second.
*   No adverse effects yet; these warnings precede an actual lease expiration.

       14:29:14 sanlock[123]: 13336 s1 check_our_lease failed 80

*   id_renewal_fail seconds (80) after the last successful renewal, the lease expires.
*   recovery begins at this time; sanlock begins killing pid's.

       14:29:14 wdmd[111]: test failed pid 12437 renewal 13256 expire 13336

*   The first warning from wdmd appears, indicating that the watchdog will fire and reset the host unless all pid's exit (or renewals resume) within 10 seconds.

## wdmd response to sanlock problems

If the sanlock daemon is killed or otherwise exits while being used, the wdmd daemon controlling /dev/watchdog will log errors, warning that the watchdog is not being kept alive, and will soon expire. At this point it is too late to do anything, and the host will be reset by the watchdog.

## sanlock timeouts

The sanlock daemon has a large number of different but intricatly related timeouts. All are derived from io_timeout, which is 10 seconds: the time a single i/o can take before sanlock considers it failed.

The i/o timeout can be tuned, but it is critical that all hosts use the same i/o timeout value. sanlock will not detect if hosts use different i/o timeouts, and this misconfiguration could lead to data corruption. When the sanlock daemon starts, it adds an entry to /var/log/messages which includes the basic timeout values:

       sanlock daemon started 2.0 aio 1 10 renew 20 80 ...

*   `aio 1` -- async i/o is enabled
*   `10` -- io_timeout
*   `renew 20 80` -- id_renewal_seconds id_renewal_fail_seconds (time between renewals and time to renew a lease before it expires)

## sanlock live process debugging

Debugging the sanlock daemon process.

      # sanlock client status [-D]

This displays all lockspaces, leases and pid's currently being managed.
-D includes extra internal debugging information.

      # sanlock client host_status -s LOCKSPACE [-D]

This displays the status of all host_id leases being monitored.
LOCKSPACE can simply be the lockspace name/uuid.
-D includes extra internal debugging information.

      # sanlock client log_dump

This dumps the sanlock daemon's internal circular buffer of recent debug messages.

## References

<references/>

[1] <http://libvirt.org/formatdomain.html#elementsLease>

[2] <https://libvirt.org/kbase/locking.html>

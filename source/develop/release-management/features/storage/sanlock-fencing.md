---
title: Sanlock Fencing
category: feature
authors: nsoffer, vered, ybronhei
---

# Sanlock Fencing

## Summary

When a host becomes non-responsive, oVirt engine tries to fence the host; detaching it from the shared storage, and hopefully making it responsive again. This feature adds a new fencing mechanism, fencing via shared storage using sanlock. Using sanlock, we can provide a simple fencing solution when soft or hard fencing are not available or fail, avoiding manual fencing, and increasing VM availability.

## Owner

*   Name: Nir Soffer (Nsoffer)
*   Email: <nsoffer@redhat.com>

## Current status

This feature is in design phase.

*   Last updated on -- by

## Why another fencing mechanism?

oVirt 3.4 supports 2 types of fencing; soft fencing and hard (or real) fencing. Soft fencing is implemented by logging in to the fenced host and restarting the vdsmd service. Hard fencing is implemented by fence agents, connecting to various power management devices, stopping the host, and then starting it. This option is available if the host has a compatible power management hardware, and power management was configured.

In a typical data center, hosts are connected to the network using one nic, and to the storage using other nics or through an HBA. It may occur that the host is inaccessible through networking, but still has access to the shared storage. Current fencing mechanisms will fail and require manual reboot of the unreachable host. Until rebooted, VMs running on the host cannot be started on another host.

While the host is unreachable, we can communicate with it using the shared storage. Since oVirt 3.1, every host is running the sanlock daemon, used to acquire leases on the shared storage. Sanlock fencing is using the available sanlock daemon to send a fence request to the fenced host, and on the fenced host, the sanlock daemon reboots the machine.

## Fencing goals

Fencing has two main goals:

1.  Make host release shared resources
2.  Make the host responsive again

A host may run a critical VM, writing to shared storage, and using shared resources such as network addresses. If the host is inaccessible, we must not start the critical vm on another host, because both VMs will write to the same shared storage, corrupting data.

Using sanlock fencing, we can trigger a reboot of the host, thus stopping vdsm and all running vms. Rebooting the host is typically what's needed to make it responsive again.

## sanlock fencing - theory of operation

Fencing using sanlock includes the following steps:

1.  Engine picks a proxy host
2.  Engine sends sanlock fencing request to the proxy host
3.  Proxy host sends sanlock fencing request to the sanlock daemon
4.  Engine polls sanlock fencing status until host is assumed dead

### Engine picks a proxy host

sanlock fencing will be available only on cluster using 3.5 compatibility version. This version will required vdsm version with sanlock fencing capability, which will required sanlock version that support fencing.

Unlike hard fencing proxy search, a proxy for sanlock fencing must:

*   Fencing host must be operational
*   Both fencing host and fenced host must be from cluster 3.5
*   Both fencing host and fenced host must have access to same storage domain
*   Fencing host must not be busy fencing another host; the current sanlock fencing mechanism allow a host to fence one other host. We hope that sanlock will remove this limit or support more then one host.

If cluster does not support sanlock fencing, or there is no available proxy host, sanlock fencing will fail and we will fall-back to the next fencing method.

### Engine sends sanlock fencing request to the proxy host

We will use the current fencing API, using new fencing type.

Since sanlock fencing is using different parameters than other fencing agents, we will try to fit the sanlock parameters into the standard fencing agents interface. For example, sending the sanlock host id and lockspace name in the address field.

sanlock does not support the "stop" and "start" verbs, used by hard fencing. We need to find how to integrate sanlock with the current fencing code.

### Proxy host sends sanlock fence request sanlock daemon

We hope to have a sanlock fence request API, to send a reset message to the fenced host, and wait until the fenced host receives the message and stops renewing its lease.

When a proxy gets a fencing request, we will start a fencing thread, and run the sanlock fencing command in this thread.

At this point, the proxy host will return a response to the engine, and the engine will move the next step in the fencing sequence. The egine will change the host's state to "Rebooting" upon receiving this response.

### Engine polls sanlock fencing status until host is assumed dead

While vdsm is running the fencing command, engine will poll vdsm fencing status. Until the sanlock fencing command returns, vdsm will return the same status that other fencing agents return today when a host is stopping.

We assume that sanlock request will return when sanlock on the fencing host is sure that the fenced host received the reset message, stopped renewing its host id lease, and enough time has passed, so the watcdog on the fenced host did reset the machine. We also assume that the watchdog on the fenced host cannot fail when resetting the machine.

When sanlock command is finished, the fencing thread will wait for the next update, and return the result of the fence command. Engine will change the host status to "Non-Responsive".

At this point, engine can clear the VMs that were running on the fenced host and start them on another host.

This step should take about 1-2 minutes, depending on sanlock configuration.

## Integration with existing mechanisms

Since soft and hard fencing are fast, it seems a better option than sanlock fencing when a host is reachable. sanlock fencing will be used as a fall-back when soft and hard fencing are not available, or fail.

For the first version, we may need to make sanlock fencing disabled by default and let users enable and disable it. This will require minor user interface changes.

## Limitations

### Host fatal failures

If a fenced host has a hardware failure, looses power, its kernel panics, or it cannot access storage, the host will stop renewing its lease. However, since we have no indication about the host's status, we must assume that the host may write to storage any time. In this case we would not be able to fence the host using sanlock, and manual fencing will be required.

## Dependencies

This feature requires fencing support in sanlock, discussed in the sanlock-devel mailing list:

*   David Teigland patch - <https://lists.fedorahosted.org/pipermail/sanlock-devel/2014-January/000426.html>
*   Thread discussing the patch - <https://lists.fedorahosted.org/pipermail/sanlock-devel/2014-January/000427.html>

## Documentation

*   [RFE] Add support for iscsi/scsi fencing in RHEV - <https://bugzilla.redhat.com/804272>
*   <http://en.wikipedia.org/wiki/Fencing_%28computing%29>
*   Red Hat GFS 6.0: Administrator's Guide: Using the Fencing System - (Documentation used to be at `https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/3/html/GFS_6.0_Administration_Guide/ch-fence.html` but the page doesn't exist anymore)

## Testing

Initial tests (incomplete)

*   Setup soft fencing so it fails and disable hard fencing, and verify falling back to sanlock fencing
*   Setup hard fencing so it fails, and verify falling back to sanlock fencing
*   Regression: test that soft and hard fencing still work
*   Test various failure modes of sanlock fencing (TBD)

## FAQ

### Why not use ISCSI fencing?

SCSI fencing requires a large amount of configuration and coordination as well as hardware support, and is relevant only for SCSI storage types. sanlock fencing can work with all shared storage types (e.g FCP, NFS, glusterfs).

### Why not use fence_sanlockd?

The fence_sanlock package provides a daemon that uses its own storage volume and sanlock to create a fencing solution. However, it requires a rather large (2G) storage volume for managing the fencing leases, that need to be initialized. This would require a new version of storage pool and upgrades from older versions, and these are hard and painful.

In addition, most of the infrastructure required by fence_sanlock is already available and used by vdsm and sanlock. We think that it would be much easier to have a solution based on the existing infrastructure.

### Why not use VM based leases?

If we add VM based leases, sanlock would kill those VMs when fencing a host, or when access to storage is lost. In this case, we can check that the host was stopped by polling vdsm and VMs leases on the shared storage, so we can decrease the downtime of a critical VM, starting the VM on another host as soon as the VM lease is free. Additionally, these leases protect from a split-brain if we have engine an error cause it to start two instances of the same VM.

In the current architecture, VM leases must be stored on the master domain. However, we plan to drop the master domain in the next version, so VM leases do not have an obvious place. Adding VM leases will probably require a new storage domain format, as the current leases volume can only hold 256-2000 leases (depending on sector size), and this may not be enough for some setups.

For this version, we prefer to have a simpler solution.

### Why not use Disk based leases?

Using disk based leases, we can ensure that VMs are killed when sanlock looses the host id lease, even if we don't get a reset message acknowledgement. It also allows fencing in the VM level, without rebooting the machine. We would like to have such disk leases for the live-merge feature, so using disk leases seems the correct long term solution.

Adding disk based leases will probably require a new storage domain format, as the current leases volume can only hold 256-2000 leases (depending on sector size), and this may not be enough for some setups. Another issue, is how to pass leases from one VM to another during migration.

For this version, we prefer to have simpler solution.




---
title: VM failover using VM leases
category: feature
authors: nsoffer
feature_name: VM failover using VM leases
feature_modules: engine
feature_status: Design
---

# VM failover using VM leases


## Overview

This feature adds the ability to start a highly available VM on another
host when the host becomes non-responsive but cannot be fenced.  In the
current system the VM state is unknown and the system cannot start the
VM on one of the available hosts until the host is rebooted manually and
the administrator mark the host as rebooted manually.

## Owner

- Name: [Nir Soffer](https://github.com/nirs)
- Email: <nsoffer@redhat.com>


## Detailed Description


### How it works

To enable this feature, the user must create a storage lease for the VM.
Only VM holding a storage lease can use automatic failover when a host
becomes non-responsive or loses access to storage.

When a VM with a lease is started, libvirt set up the QEMU process so it
takes the VM lease using sanlock. If sanlock fails to acquire the lease,
starting the VM will fail.  The lease ensures that only one instance of
a VM with a lease can run on the DC, preventing split-brain situations.

When sanlock cannot renew host leases in a storage domain, it will
terminate all the processes holding a lease in that storage, so any VM
holding a lease on that storage will be terminated by sanlock.

If sanlock cannot terminate a process holding a lease, it will reboot
the host using the host watchdog. This ensures that non-responsive host
that lost access to storage will always release its leases.

When a host becomes non-responsive, we will perform the normal recovery
procedure.  If fencing failed, was not available, or was disabled, we
will lookup the HA VMs with leases running on this host, and schedule
these VMs for starting on another host.

When restarting a HA VM with a lease on another host, the VM will fail
to start of previous instance of this VM is still running on another
host.  In this case we will retry periodically to restart the VM, until
the VM becomes UP.

If the HA VM did start on another host it means that the previous
instance of this VM is not running on the non-responsive host, or the
non-responsive host was rebooted.

HA VM failover does not depend on fencing, and is always active even if
fencing is disabled.

Failover is expected to take several minutes after the non-responsive
host lost access to storage. The is hard limit based on sanlock
timeouts.


### Supported failure modes

This feature will allow automatic failover when a host becomes
non-responsive and:

- Host lost power
- Host loses access to storage
- VM was terminated because of another reason

In these situations sanlock can detect that HA VM lease is expired and
acquire the lease for another VM instance.


### Unsupported failure modes

This feature will not allow automatic failover when a host becomes
non-responsive but:

- Host can access storage and maintain its leases. HA VMs running on the
host will continue to run, holding their leases.


## User Experience

Once a user created a lease for a VM, the feature is transparent.

The user is responsible for selecting the storage domain for the VM
lease. Since we do not support yet hot-plug/unplug of VM leases, it is
best to select a dedicated storage domain for leases that is unlikely to
need maintenance. If the storage domain used for leases needs
maintenance, VMs having leases on this storage domain must be stopped to
move the lease to another storage domain.


## Installation/Upgrade

This feature does not effect engine or vdsm installation or upgrades

The feature will be available only on DC version 4.1, older DC must be
upgraded to this version.

Exiting highly available VMs not configured with a storage lease will
not be affected by this feature.  To use this feature, a user will have
to add a lease to existing VMs.

We don't support yet hot-plugging a lease to a running VM, so running VM
must be stopped to add a VM lease.


## User work-flows

Previously if a host becomes non-responsive and fencing failed or was
not available, the user had to reboot a host and mark the host as
"rebooted" manually. With this feature, a VM will automatically start on
another host once the host lost access to storage or lost power.


## Dependencies / Related Features

This feature depends on the [vm-leases](../storage/vm-leases/)
feature.


## Event Reporting

- reporting when starting a VM on another host when host becomes
  non-responsive.


## Documentation / External references

This feature is required for resolving
[Bug 1317429](https://bugzilla.redhat.com/1317429)

## Testing

- host non-responsive after loosing power
  - setup system with at least 2 hosts (host1, host2)
  - start HA VM on host1
  - wait until VM status is up
  - disconnect host1 power
  - wait until VM status is UNKNOWN
  - system should start VM on host2 after few minutes

- host non-responsive with inaccessible storage
  - setup system with at least 2 hosts (host1, host2)
  - start HA VM on host1
  - wait until VM status is up
  - block access from engine to host1
  - block access to storage from host1
  - wait until VM status is UNKNOWN
  - system should start VM on host2 after few minutes

- host non-responsive with stopped VM
  - setup system with at least 2 hosts (host1, host2)
  - start HA VM on host1
  - wait until VM status is UP
  - block access from engine to host1
  - wait until VM status is UNKNOWN
  - terminate VM manually on host1
  - system should start VM on host2 after few minutes

- host non-responsive with accessible storage
  - setup system with at least 2 hosts (host1, host2)
  - start HA VM on host1
  - wait until VM status is up
  - block access from engine to host1
  - wait until VM status is UNKNOWN
  - system will fail to start the VM on host2 reporting that VM is still
    running on host1.


## Release Notes

XXX Write me

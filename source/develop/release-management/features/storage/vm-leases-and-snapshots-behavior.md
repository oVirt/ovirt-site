---
title: VM leases and snapshots behavior
category: feature
authors: eshenitz
---

# VM leases and snapshots behavior

## Summary

Aligns the behavior of VM with a lease and VM snapshots operations.

## Owner

*   Name: Eyal Shenitzky

## Description
The VM leases feature was introduced in oVirt engine 4.1 version.
This feature adds the ability to acquire a lease per VM on shared storage in order to avoid split-brain, 
and starting a VM on another host if the original host becomes non-responsive.

Few improvements were made in oVirt 4.2.2.1 version which aligns the behavior of VM with a lease and VM snapshots operations:
-   Preview VM snapshot
-   Undo VM snapshot
-   Commit VM snapshot

* ### Preview VM snapshot:
#### - In case the active snapshot and the previewed snapshot has a lease on the same domain:
The VM will use the existing lease.
#### - In case the active snapshot and the previewed snapshot has a lease on different domains:
The VM will use the active snapshot lease.
#### - In case the active snapshot has a lease but the previewed snapshot doesn't have a lease:
The VM will not use the active snapshot lease, but the lease will not be removed until the snapshot will be committed.
#### - In case the active snapshot doesn't have a lease but the previewed snapshot has a lease:
A new VM lease will create for the VM on the storage domain which held the lease while the snapshot was taken.
If the storage domain doesn't exist anymore, the preview will fail and the user can perform custom preview and choose
whether the preview should contain the lease and on which domain.

* ### Undo VM snapshot:
#### - In case the active snapshot and the previewed snapshot has a lease on the same domain:
The VM will use the existing lease.
#### - In case the active snapshot and the previewed snapshot has a lease on different domains:
The VM will use the active snapshot lease.
#### - In case the active snapshot has a lease but the previewed snapshot doesn't have a lease:
The VM will return to use the active snapshot lease.
#### - In case the active snapshot doesn't have a lease but the previewed snapshot has a lease:
The VM lease that was created for the preview will be removed and the VM will return to use the active snapshot lease.

* ### Commit VM snapshot:
#### - In case the active snapshot and the previewed snapshot has a lease on the same domain:
The VM will use the existing lease.
#### - In case the active snapshot and the previewed snapshot has a lease on different domains:
The VM will use the active snapshot lease.
#### - In case the active snapshot has a lease but the previewed snapshot doesn't have a lease:
The active snapshot lease will be removed from the storage domain and the VM will not use any lease.
#### - In case the active snapshot doesn't have a lease but the previewed snapshot has a lease:
The VM will use the lease that was created for the preview.


* ### Custom preview to a snapshot with a lease:
It is possible to customize the preview of a snapshot and select whether the preview will include 
the VM lease or not.
Moreover, it is possible to select the VM lease from a different snapshot.
When performing a custom preview, the selected VM lease will be created even if the active snapshot 
has a lease.
This behavior is different than the regular preview, the active snapshot VM lease will 
not be removed from the storage domain until the snapshot will be committed, if the user selects to undo the 
snapshot preview the created lease will be removed.

## New engine API

In the REST API and via the UI a user should be able to:

- Preview a snapshot with or without the lease

## Documentation / External references

This feature is required for resolving
[Bug 1484863](https://bugzilla.redhat.com/show_bug.cgi?id=1484863)

## Testing

- Preview VM snapshot which contains a lease while active VM snapshot contains a lease on the same domain
  - snapshot previewed and use the active snapshot lease
- Preview VM snapshot which contains a lease while active VM snapshot contains a lease on the different domain
  - snapshot previewed and use the active snapshot lease
- Preview VM snapshot which doesn't contain a lease while active VM snapshot contains a lease
  - snapshot previewed and doesn't use the active snapshot lease, the active snapshot lease is not removed from the storage domain
- Preview VM snapshot which contains a lease while active VM snapshot doesn't contain a lease
  - snapshot previewed and a new VM lease created
- Custom preview VM snapshot and use the active VM snapshot lease
  - snapshot previewed and use the active VM lease
- Custom preview VM snapshot and use the previewed VM snapshot lease
  - snapshot previewed and use the previewed snapshot VM lease
- Custom preview VM snapshot and use the other snapshot lease
  - snapshot previewed and use the other snapshot VM lease
- Custom preview VM snapshot and doesn't use a lease
  - snapshot previewed and doesn't use any VM lease
- Undo VM snapshot which contains a lease while active VM snapshot contains a lease on the same domain
  - active snapshot restored and use the active snapshot lease
- Undo VM snapshot which contains a lease while active VM snapshot contains a lease on the different domain
  - active snapshot restored and use the active snapshot lease
- Undo VM snapshot which doesn't contain a lease while active VM snapshot contains a lease
  - active snapshot restored and use the active snapshot lease
- Undo VM snapshot which contains a lease while active VM snapshot doesn't contain a lease
  - active snapshot restored and the new VM lease which created for the preview removed
- Commit VM snapshot which contains a lease while active VM snapshot contains a lease on the same domain
  - snapshot committed and use the active snapshot lease
- Commit VM snapshot which contains a lease while active VM snapshot contains a lease on the different domain
  - snapshot committed and use the active snapshot lease
- Commit VM snapshot which doesn't contain a lease while active VM snapshot contains a lease
  - snapshot committed and doesn't use the active snapshot lease, the active snapshot lease removed from the storage domain
- Commit VM snapshot which contains a lease while active VM snapshot doesn't contain a lease
  - snapshot committed and use the created VM lease

### Negative flows
- Preview VM snapshot which contains a lease on storage domain that doesn't exist
  - snapshot preview will fail
- Preview VM snapshot which contains a lease on storage domain that isn't active
  - snapshot preview will fail

## References

[1] <https://gerrit.ovirt.org/#/c/86105/>

[2] <https://gerrit.ovirt.org/#/c/86228/>

[3] <https://gerrit.ovirt.org/#/c/86513/>





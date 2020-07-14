---
authors: msivak
feature_name: Affinity labels
feature_modules: engine
feature_status: Released in oVirt 4.0 RC
---

# Affinity labels

## Owner

*   Name: [Martin Sivak](User:msivak)
*   Email: <msivak@redhat.com>

## Feature requests

- [https://bugzilla.redhat.com/show_bug.cgi?id=1254818](https://bugzilla.redhat.com/show_bug.cgi?id=1254818)
- [https://bugzilla.redhat.com/show_bug.cgi?id=1266041](https://bugzilla.redhat.com/show_bug.cgi?id=1266041)

## User stories

1. Some hosts have specific hardware that is needed for certain VMs and the VMs must be placed on those hosts
1. A company uses software that is license limited to a certain number of physical machines, but does not care about the number of VMs. All VMs with that software must be limited to the same physical hosts to obey that condition.

## Current situation

1. Each VM can be pinned to multiple specific hosts with the given HW. It will start on one of the listed hosts and no migration is enabled.
1. VM to VM affinity is supported and can be used, but it only tries to put all those VMs on the same host. Subcluster is not supported.


## Feature goals

*There already is an existing Tag functionality in the engine, but we can’t reuse the backend code since the user facing functionality won’t be removed on time. We want to deprecate the old behaviour gradually and without disturbing current users. This forces us to create our own parallel implementation that will be almost the same, but will allow us to do changes to behaviour.*

There will be no hierarchy support for labels. Users can simulate hierarchy using naming conventions (eg.: storage::iscsi::fast)

## Benefit to oVirt

Users will be able to create a logical sub-cluster of VMs and Hosts that should help them to accomplish the two described user stories.

## Feature design

### Entity Description

A new entity Label will be added to the database with the basic CRUD storage procedures and a view to allow bulk retrieval of labels by id, name or attached object(s).

### REST API

Basic manipulation of affinity labels:

- /affinitylabels (GET, POST)
- /affinitylabels/:id: (GET, PUT, DELETE)

Assignment operations on labels:

- /affinitylabels/:id:/vms (GET, POST)
- /affinitylabels/:id:/vms/:id: (GET, DELETE)

- /affinitylabels/:id:/hosts (GET, POST)
- /affinitylabels/:id:/hosts/:id: (GET, DELETE)

Assignment operations on entities:

- /vms/:vmid:/affinitylabels (GET, POST)
- /vms/:vmid:/affinitylabels/:id: (GET, DELETE)

- /hosts/:hostid:/affinitylabels (GET, POST)
- /hosts/:vmid:/affinitylabels/:id: (GET, DELETE)

### GUI

A [GUI](/develop/release-management/features/sla/affinity-labels-management-via-admin-portal.html) for affinity labels management was made available as of version 4.1.

### Permissions

Currently only the system admin and users with Tag management permissions (the same the old tagging feature uses) can create or manipulate labels.

### VM scheduling

A new scheduling policy unit LabelFilterPolicyUnit takes care of the label affinity relationship during scheduling and must be enabled for this feature to have any effect.

Default cluster policies will have the unit enabled by default.

### Installation/Upgrade

The feature has no impact on installation or upgrade. It will become immediately available after the proper engine version is installed.

Custom cluster policies might need to have the new policy unit added by the user to enable the label based filtering.

### User work-flows

The user will generaly use REST API to create a new label and then attach entities (VMs and Hosts) to it by POSTing to the relevant subcollections.

## Testing

[Basic sanity test of labels for one VM and one Host](https://bugzilla.redhat.com/attachment.cgi?id=1164031)

This script can be used to do basic sanity testing of the affinity label functionality. It requires a running ovirt-engine (preconfigured values - ip 127.0.0.1:8080, admin@internal:letmein) with one VM (does not have to be running) and one Host.

## Contingency Plan

The feature is ready.

## Release Notes

      == Affinity labels ==
      Affinity label support was added to REST API for hosts and VMs.
      A VM can only be scheduled on a host that is labelled with all
      the affinity labels the VM has. Any extra labels on the host
      make no difference.

## Open Issues

---
title: LiveMigrationSupportForSRIOV
category: feature
authors: mmucha
wiki_category: Feature
wiki_title: Features/LiveMigrationSupportForSRIOV
wiki_revision_count: 12
wiki_last_updated: 2015-10-14
feature_name: Live Migration Support For SRIOV
feature_modules: Networking
feature_status: Design
rfe: https://bugzilla.redhat.com/show_bug.cgi?id=868811

---


# Live Migration Support For SRIOV

### Owner

*   Name: [ Martin Mucha](User:mmucha)
*   Email: mmucha@redhat.com

## Summary
Current support of SR-IOV in engine does not allow migration, which
limits its usability. However current support of SR-IOV does support 
hot-plugging and hot-unplugging. We can employ this to enable currently 
not supported migration. When VM is migrated to another host, its
passthrough nic will be hot-unplugged, and related VF will be released.
Then we can perform VM migration, and after that we'll perform hot-plug.
Therefore, after migrating VM, there will be slight delay before nic 
reappears in VM. 

## Detailed Description

Currently, VMs using SR-IOV nics cannot be migrate. To preserve this 
behavior user can specify, whether each passthrough nic is 'migratable' 
or not. VM will can only be migrated, when all its nics passthrough 
nics are marked as migratable. 

Hot-plug can succeed only if there's available virtual function on 
target host. To avoid possible race, migration will allocate virtual 
function first, proceeding only if there was available one. 
If there's none, VM won't be migrated.

Also migration with SR-IOV is tricky and can fail. If that happens,
VM won't be migrated back. 

### REST

Model will be altered, so that vNicProfile can be set as migratable:
```
@Type
public interface VnicProfile extends Identified {
    …
    VnicPassThrough passThrough();
    boolean migratable();
```

### GUI

In UI, you need to flag passthrough nic as migratable to be able to do
migration when SR-IOV is used.

#### Setting migratable flag
![Vnic profile with migratable flag png](vnicProfileWithMigratableFlag.png "Vnic profile with migratable flag png")


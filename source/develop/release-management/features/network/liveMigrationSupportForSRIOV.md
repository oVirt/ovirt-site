---
title: LiveMigrationSupportForSRIOV
category: feature
authors: mmucha
---


# Live Migration Support For SRIOV

rfe: https://bugzilla.redhat.com/show_bug.cgi?id=868811

### Owner

*   Name: Martin Mucha

## Summary
Current support of SR-IOV (single root I/O virtualization) in engine 
does not allow migration, which
limits its usability. However current support of SR-IOV does support 
hot-plugging and hot-unplugging. We can employ this to enable currently 
not supported migration. When VM is migrated to another host, its
passthrough nic will be hot-unplugged, and related VF (virtual function)
will be released.
Then we can perform VM migration, and after that we'll perform hot-plug.
Therefore, after migrating VM, there will be slight delay before nic 
reappears in VM. 

## Detailed Description

Currently, VMs using SR-IOV nics cannot be migrated. To preserve this 
behavior user can specify, whether each passthrough nic is 'migratable' 
or not. A VM can only be migrated, when all its nics passthrough 
nics are marked as migratable. 

Hot-plug can succeed only if there's available VF on 
target host. To avoid possible race, migration will allocate VF first, 
proceeding only if there is available one. 
If there's none, VM won't be migrated.

Migration with SR-IOV vNICs is a tricky multi-state operation, and can 
fail. If the operation fails after the VM is already running on the 
destination, the VM would not be migrated back.

### REST

Model will be altered, so that vNicProfile can be set as migratable:

```java
@Type
public interface VnicProfile extends Identified {
    
    //...
    
    VnicPassThrough passThrough();
    boolean migratable();
    
    //...
}    
```

### GUI

In UI, you need to flag passthrough nic as migratable to be able to do
migration when SR-IOV is used. Only passthrough nic can be marked as
migratable, or not marked as migratable. Other nics are always 
migratable, thus migratable checkbox will be selected and greyed out
when passthrough checkbox is not selected. 

#### Setting migratable flag
![Vnic profile with migratable flag png](/images/vnicProfileWithMigratableFlag.png "Vnic profile with migratable flag png")

### Guest-side support
   
While migrating, the guest can notice that one of its vNICs has been 
unplugged, and communication is lost. To avoid that, VM admin should 
add two vNICs: an SR-IOV one for performance, and a virtio one for 
backup during migration. The guest should create a bonding (or teaming) 
device on top of these, so that user-space guest application can ignore 
the temporary disappearance of the SR-IOV device.
   
When migration finishes and the SR-IOV device is restored, it should be 
reattached to that bond. In the context of this feature, we would supply
the el7 hooking mechanism to make it happen seamlessly in the future, while
currently migration is possible using the following procedure via NetworkManager:

* Create the bond (with ens3 being the passthrough interface in this example):

        ~]$ nmcli con add type bond con-name bond0 ifname bond0 mode active-backup primary ens3
        Connection 'bond0' (9301ff97-abbc-4432-aad1-246d7faea7fb) successfully added.

* Add the interfaces to the bond:

        ~]$ nmcli con add type bond-slave ifname eth0 master bond0
        Connection 'bond-slave-eth0' (50c59350-1531-45f4-ba04-33431c16e386) successfully added.
        ~]$ nmcli con add type bond-slave ifname ens3 master bond0
        Connection 'bond-slave-ens3' (70c5f150-2643-82f3-fa61-48444d28b182) successfully added.

* Bring up the interfaces:

        ~]$ nmcli con up eth0
        (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/14)
        ~]$ nmcli con up ens3
        (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/15)

* Finally, bring up the bond:

        ~]$ nmcli con up bond0
        (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/16)

The active slave should be the primary slave as configured:

    ~$] cat /sys/class/net/bond0/bonding/active_slave
    ens3

Hot unplugging the primary slave should activate the backup slave:

    ~$] cat /sys/class/net/bond0/bonding/active_slave
    eth0

Hot plugging the primary slave back should return it to active state:

    ~$] cat /sys/class/net/bond0/bonding/active_slave
    ens3

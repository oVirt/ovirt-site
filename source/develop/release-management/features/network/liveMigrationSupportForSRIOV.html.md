---
title: LiveMigrationSupportForSRIOV
category: feature
authors: mmucha
feature_name: Live Migration Support For SRIOV
feature_modules: Networking
feature_status: Design
rfe: https://bugzilla.redhat.com/show_bug.cgi?id=868811

---


# Live Migration Support For SRIOV

### Owner

*   Name: Martin Mucha (mmucha)
*   Email: mmucha@redhat.com

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

&#8226; Edit the virtIo vNIC profile (eth0) with 'No Filter' filter<br>
&#8226; Run VM with 2 nics. virtIo and sr-iov<br>
&#8226; Remove the NM_CONTROLLED=no line from the ifcfg-eth0 file that generated via dracut installation<br>
&#8226; Reload eth0:<br>

    nmcli con reload eth0
&#8226; Add the VF's connection:

    nmcli connection add type ethernet con-name ens3 ifname ens3
&#8226; Create the bond:

    nmcli connection add type bond con-name bond0 ifname bond0 mode active-backup primary ens3
&#8226; Modify the boot protocols of the bond and the future slaves:

    nmcli connection modify id bond0 ipv4.method auto ipv6.method ignore
    nmcli connection modify id ens3 ipv4.method disabled ipv6.method ignore
    nmcli connection modify id eth0 ipv4.method disabled ipv6.method ignore
&#8226; Add the slaves to the bond:

    nmcli connection modify id ens3 connection.slave-type bond connection.master bond0 connection.autoconnect yes
    nmcli connection modify id eth0 connection.slave-type bond connection.master bond0 connection.autoconnect yes
&#8226; Bring up the bond:

    nmcli connection down id ens3; nmcli con up id ens3; nmcli con down id eth0; nmcli con up id eth0; nmcli con up bond0
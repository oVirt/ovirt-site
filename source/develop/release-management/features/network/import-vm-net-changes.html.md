---
title: Change network information in VM import
category: feature
authors: yevgenyz
wiki_category: Feature
wiki_title: Features/Change network information in VM import
wiki_revision_count: 1
wiki_last_updated: 2016-08-29
feature_name: Change network information in VM import
feature_modules: engine/api-model
feature_status: Work in progress for oVirt 4.1
---

# Change network information in VM import

## Summary

Currently importing a VM from an external source might result in the 
non-functional VM from the network perspective:

* vNics that are not connected to any network that is defined in the 
oVirt the VM was imported to or is connected to an undesired vNic 
profile.
* The MAC address that was assigned to the vNic in the external 
system could be problematic in the local oVirt setup.
The reasons for a MAC to be problematic are:

    * The MAC is already in use by an existing VM.
    * The MAC is out of range of the destination cluster.

The feature intends to solve the mentioned problems in the flow of 
importing VMs from a data domain storage.

## Owner

*   Name: [Yevgeny Zaspitsky](User:YevgenyZ)
*   Email: <yzaspits@redhat.com>

## Proposed solution

### Mapping vNic profiles to the target ones.
The mapping of the source vNic profiles to the ones that are defined 
under destination DC/custer would be possible as part of the import 
operation. 

#### REST API 
The user would supply the desired mappings as part of the import VMs 
request. The mapping would look like a collection of entries like the 
following:

* Source network name
* Source network profile
* Target network profile

The mappings data would be passed as an additional optional data of the 
existing VM import request:

```
POST /storagedomains/{storagedomain:id}/vms/{vm:id}/import
```

```html
<action>
    <cluster id=”XXX”/>
    <storage_domain id=”YYY”/>
    ....
    <!-- The new addition start-->
    <network_mappings>
        <network_mapping>
            <source_network_profile>
                <network>
                    <name>red</name>
                </network>
                <name>gold</name>
            <source_network_profile>
            <target_network_profile id=”123”/>
        </network_mapping>
        <network_mapping>
            <source_network_profile>
                <network>
                    <name>blue</name>
                </network>
                <name>silver</name>
            <source_network_profile>
        </network_mapping>
    <network_mappings>
    <!-- The new addition end-->
</action>
```

Since the mappings are optional, any vNic profile that the mapping isn’t
 supplied for it, would be mapped to a profile with the same name, if 
that exists, or an “empty” profile otherwise, like that’s done 
currently.
A missing “target_network_profile” element would mean the target profile
 is an “empty” profile. That is useful for a case that source profile is
known to be used in the target system for somewhat else and an 
alternative profile doesn’t exist yet.

#### GUI
The engine would scan all VMs that are intended to be imported and will 
provide a list of network+profile that are defined on the vNics of those
 VMs. Then mappings could be defined (by the user) in an expandable span
 that would be added to the import VM diallog. 
Each line would represent a single mapping with the following fields:

* Source network name
* Target network name
* Source vNic profile name
* Target vNic profile name

![Network mapping closed](import_vm-network_mapping_close.png)
![Network mapping opened](import_vm-network_mapping_open.png)

Initially all vNic profiles would be mapped to a matching (by name) 
network+profile on the target or would be an “Empty” profile if no match
 exists. Then the user would be able to change that to any desired 
profile. The list of the available networks would be filtered according 
to the chosen cluster and the list of the profiles will be filtered by 
the chosen network.


### Re-assign MAC addresses for the vNics of an imported VM
The user will be able to request to re-assigning a new MAC instead of 
one that is problematic in the context of the target cluster.
The reasons for a MAC to be problematic are:

* Out-of-range
* Collision - the MAC is owned by another vNic

Note that a re-assign request modifies only problematic MACs. If a VM 
has “good” MACs as well, they would remain.

#### REST API
The import VM request will have additional boolean 
parameter “reassign_bad_macs”. In order to keep backward compatibility 
the default value of the new parameter will be False.

```
POST /storagedomains/{storagedomain:id}/vms/{vm:id}/import
```

```html
<action>
    <cluster id=”XXX”/>
    <storage_domain id=”YYY”/>
    ....
    <!-- The new addition start-->
    <reassign_bad_macs>true<reassign_bad_macs>
    <!-- The new addition end-->
</action>
```

#### GUI
VM with a problematic MAC would be marked by a warning triangle with an 
explanatory tooltip. Checking re-assign for that VM may eliminate the 
warning (if the warning is only due to MAC problem).
![](register_vm-reallocate_mac.png)

## Related RFEs
* [BZ#1277675](https://bugzilla.redhat.com/show_bug.cgi?id=1277675)
* [BZ#1317447](https://bugzilla.redhat.com/show_bug.cgi?id=1317447)

## Future plans
Apply the similar changes to import VM from the other sources flows
 (e.g. export domain, V2V).
 
## Open Issues

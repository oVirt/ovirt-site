---
title: Change network information in VM import
category: feature
authors: yevgenyz
---

# Change network information in VM import

## Summary

Currently importing a VM from an external source might result in a 
non-functional VM from the network perspective:

* Mapping the vNic profile by name might lead to one of the following:
    * vNics that are not connected to any network that is defined in the 
oVirt the VM was imported to
    * vNic is connected to an undesired vNic profile that matches by 
    name but not by the meaning.
* The MAC address that was assigned to the vNic in the external 
system could be problematic in the local oVirt setup.

The feature intends to solve the mentioned problems in the flow of 
importing VMs from a data domain storage.

## Owner

*   Name: Yevgeny Zaspitsky (YevgenyZ)
*   Email: <yzaspits@redhat.com>

## Proposed solution

### Mapping vNic profiles to the target ones.
The mapping of the source vNic profiles to the ones that are defined 
under destination DC/custer would be possible as part of the import 
operation. 

#### REST API 
The user would supply the desired mappings as part of the import VMs 
request. The mapping would look like a collection of entries, 
where each of the entries would consist of the following:

* Source network name
* Source network profile name
* Target network profile

The mappings data would be passed as additional optional data of the 
existing VM import request:

```
POST /storagedomains/{storagedomain:id}/vms/{vm:id}/register
```

```xml
<action>
    <cluster id=”XXX”/>
    ....
    <!-- The new addition start -->
    <vnic_profile_mappings>
        <vnic_profile_mapping>
            <source_network_name>red</source_network_name>
            <source_network_profile_name>gold</source_network_profile_name>
            <target_vnic_profile id="738dd914-8ec8-4a8b-8628-34672a5d449b"/>
        </vnic_profile_mapping>
        <vnic_profile_mapping>
            <source_network_name>blue</source_network_name>
            <source_network_profile_name>silver</source_network_profile_name>
        </vnic_profile_mapping>
    </vnic_profile_mappings>
    <!-- The new addition end -->
</action>
```

Since the mappings are optional, any vNic profile that the mapping isn’t
 supplied for, would be mapped to a profile with the same name, if 
that exists, or an “empty” profile otherwise, like that’s done 
currently.
A missing “target_network_profile” element would mean the target profile
 is an “empty” profile. That is useful for the case in which source 
profile is known to be used in a target system for something else and an 
alternative profile isn’t exist yet.

#### GUI
The engine would scan all VMs that are intended to be imported and will 
provide a list of network+profile that are defined on the vNics of those
 VMs. Then mappings could be defined (by the user) in an expandable span
 that would be added to the import VM dialog. 
Each line would represent a single mapping with the following fields:

* Source network name
* Target network name
* Source vNic profile name
* Target vNic profile name

![Network mapping modal](/images/wiki/import_vm-vnic_mapping.jpg)

Initially all vNic profiles would be mapped to a matching (by name) 
network+profile on the target or would be an “Empty” profile if no match
 exists. Then the user would be able to change that to any desired 
profile. The list of the available networks would be filtered according 
to the chosen cluster and the list of the profiles would be filtered by 
the chosen network.


### Re-assign MAC addresses for the vNics of an imported VM
The user will be able to request to re-assign a new MAC instead of the 
one that is problematic in the context of the target cluster.
The reasons for a MAC to be problematic are:

* Collision - the MAC is owned by an existing vNic.
* The MAC is out of range of the destination cluster.

Note that a re-assign request modifies only problematic MACs. If a VM 
has “good” MACs as well, they would remain.

#### REST API
The import VM request will have additional boolean 
parameter “reassign_bad_macs”. In order to keep backward compatibility 
the default value of the new parameter will be False.

```
POST /storagedomains/{storagedomain:id}/vms/{vm:id}/register
```

```xml
<action>
    <cluster id=”XXX”/>
    ....
    <!-- The new addition start -->
    <reassign_bad_macs>true</reassign_bad_macs>
    <!-- The new addition end -->
</action>
```

#### GUI
VM with a problematic MAC would be marked by a warning triangle with an 
explanatory tooltip. Checking re-assign for that VM may eliminate the 
warning (if the warning is only due to MAC problem).
![](/images/wiki/register_vm-mac_in_use.jpg)

## Related RFEs
* [BZ#1277675](https://bugzilla.redhat.com/show_bug.cgi?id=1277675)
* [BZ#1317447](https://bugzilla.redhat.com/show_bug.cgi?id=1317447)

## Testing

* Import a VM with a network profile that does not exist on the 
destination cluster
    * no mapping supplied -> Empty vNic profile 
    * mapping is supplied -> vNic is wired to the profile according to
    the supplied mapping
* Import a VM with the existing vNic profile
(e.g. network="red", profile="gold")
    * no mapping supplied -> VM connected to the vNic profile "red-gold"
    * mapping maps the src profile to "green-silver" -> vNic is 
    connected to "green-silver" profile
* On REST API - mapping is supplied but contains a non-existent 
destination profile -> user should get an error message with HTTP 400 
series error code.
* Verify that re-assigning MACs actually works, and that good MACs are 
given.
* Verify that warning sign appears in the following cases:
    * VM with a colliding MAC
    * VM with a MAC, which is out if the range to the destination
     cluster's MAC-pool. 

## Future plans
Apply the similar changes to flows importing VM from the other sources
 (e.g. export domain, V2V).
 
## Open Issues

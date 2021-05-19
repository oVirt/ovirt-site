---
title: Expand vNic profile mapping options for VM import from Storage Domain via REST API
category: feature
authors: eraviv
---

# Expand vNic profile mapping options for VM import from Storage Domain via REST API

## Summary

Up to oVirt Engine 4.2, importing a VM from a storage domain via the REST API 
assumed full knowledge of the target engine profile IDs and employed a fail-fast 
failure policy:

* Mapping a vNic profile by profile ID (see import-vm-net-changes) requires the
  user to discover the profile IDs on the engine in advance and to keep them 
  updated.
* On any error or mismatch in the mapping of the target or the source of any vNic, 
  the request is aborted.

Requiring a target ID for the import is labor-intensive from the perspective of
the user.
Employing a fail-fast failure policy is desirable when the user would like the 
engine to guard against incomplete or faulty inputs. But when the import is part 
of a Disaster Recovery operation, a permissive behaviour is required in order to 
enable the user to complete the import even if some of the vNics would not be 
fully mapped. 

This feature intends to solve the above issues for importing VMs from a 
data-domain storage via the REST API of the engine.

## Owner

*   Name: Eitan Raviv
*   email: <eraviv@redhat.com>

## Solution

### General behaviour

Additional functionality has been added to the engine:

* Deprecate the old restrictive mode, and add a new permissive mode.
* The permissive mode supports specifying the target profile either using a
  profile id or using a pair of profile name and network name. This pair is
  unique at the data-center level.
* The permissive mode implements an escalating matching algorithm that tries
   to find the best match for the profile on the engine: 
	* try to match by target id specified in the user mapping
	* else, try to match by target profile name + network name
	* else, try to match by source profile name + network name
	  found on the vNic in the OVF
* If none of the above succeeds, the permissive mode applies a 'no profile' 
  target to the vNic and continues with the request.
* Applying 'no profile' means that once the import terminates the vNic will 
  be created without any profile or network assigned to it. Any profile\network 
  may later be assigned to the vNic via the web-admin GUI or any other means.  
* User input for vNic mappings joins all the other inputs of the import under
  the 'registration_configuration' entry in the request body. 



### Profile\Network application rules
* For a target profile ID to be applied the GUID of the profile needs
  to be valid and present on the engine.
* For a profile name + network name pair to be applied the name pair needs to 
  match some profile which exists on the engine.
* For any profile to be applied the network it belongs to needs to be attached 
  to the cluster into which the import operation is being performed.
* A 'no profile' target may be specified by user input in the mappings by using 
  empty strings in the target profile name + profile network.
* If no target or empty target entry is specified in the request, the matching 
  algorithm will start at the step of trying to match and apply the source OVF
  vNic profile.  
* If no mapping at all is specified for a vNic, the matching algorithm will 
  start at the step of trying to match and apply the source OVF vNic profile.


#### REST API request structure

The mapping is comprised of a collection of entries, each of which consists
of the following:

* Source network name
* Source network profile name
* Target network profile (with ID or with profile name + profile network)

The mappings data would be passed as additional optional data of the 
existing VM import request under the 'registration_configuration' entry:

```
POST /storagedomains/{storagedomain:id}/vms/{vm:id}/register
```

```xml
<action>
    <cluster id="XXX"/>
    ....
    <registration_configuration>
	    <vnic_profile_mappings>
	        <registration_vnic_profile_mapping>
	        	<from>
	        		<name>red</name>
	        		<network>
	        			<name>red</name>
					</network>
				</from>
				<to>
	        		<name>blue</name>
	        		<network>
	        			<name>blue</name>
					</network>
				</to>
	        </registration_vnic_profile_mapping>
	        <registration_vnic_profile_mapping>
	        	<from>
	        		<name>orange</name>
	        		<network>
	        			<name>orange</name>
					</network>
				</from>
				<to id="738dd914-8ec8-4a8b-8628-34672a5d449b" />
	        </registration_vnic_profile_mapping>
	        <registration_vnic_profile_mapping>
	        	<from>
	        		<name>yellow</name>
	        		<network>
	        			<name>yellow</name>
					</network>
				</from>
	        </registration_vnic_profile_mapping>
	    </vnic_profile_mappings>
    </registration_configuration>
</action>
```


#### GUI
no change from previous behaviour


### Re-assign MAC addresses for the vNics of an imported VM
no change from previous behaviour


## Related RFEs
* [BZ#1530814](https://bugzilla.redhat.com/show_bug.cgi?id=1530814)

## Testing

* Units tests in the engine and integration tests in OST have been implemented
* Since the behaviour has totally changed, thorough QE testing is recommended.
* Testing for regressions of neighboring flows like import from OVA is recommended.

## Future plans
N/A
 
## Open Issues
N/A

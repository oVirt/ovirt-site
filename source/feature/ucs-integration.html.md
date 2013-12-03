---
title: UCS Integration
category: feature
authors: apuimedo, danken, mburman
wiki_category: Feature
wiki_title: Features/UCS Integration
wiki_revision_count: 10
wiki_last_updated: 2015-05-20
---

# UCS Integration

## Summary

Cisco's Unified Computing System (UCS) is a solution for managing a lot of datacenter aspects, from blade's firmware to network cards number and addresses on the hosts and the VMs. It has a management service (UCS-M) that allows the administrator to easily set up configurations to apply to the hardware of the datacenter.

UCS hosts have network cards that can expose N pseudo physical Network Interface Cards, optionally (and usually) as ethernet cards. Those pseudo ethernet cards receive the name of virtual functions and when they are not configured they are blank devices, i.e., they lack mac address and any connectivity to the network fabric. One particular benefit of the virtual functions is that they can be connected to the guest's operating system offering a superior network performance, since the Host OS is not involved and parts are hardware accelerated.

In terms of networking the configuration for a nic is set in UCS-M in entities called vNic Templates. A vNic template allows you to specify network attributes for the nics created form it such as: - Quality of Service, - VLANs: One can specify the default tag and the tags it should let through, - MTU, - MAC Pool: The network administrator can define several pools of MAC addresses in UCS-M from which a template can draw addresses from.

When a vNic Template applies only to host nics it is called vNic profile. When it also applies to VM vNics an entity is created in UCS-M called \*Port Profile\*.

## Owner

*   Name: [ Antoni Segura Puimedon](User:APuimedo)
*   Email: apuimedo aT redhat.com

## Current oVirt UCS-M networking integration state

Nowadays the virtual functions are reported as regular nics that, unless configured via UCS-M to have a mac address and connectivity would not be able to be used for Host networking.

There is a hook, vdsm-hook-vmfex that runs on VM creation and migration that:

*   Sets up a pool of virtual functions (thanks to the pool, migration is possible. As far as there are unused devices in the pool, we can assign a vnic to a virtual function).
*   Assigns the engine specified MAC address to a virtual function from the pool.
*   Specifies a \*Port Profile\* the virtual function should adopt.
*   Creates a macvtap device connected to the virtual function and replaces the VM nic definition with it.

For the hook to work, one must manually specify the VM custom properties with {'XX:XX:XX:XX:XX:XX': 'port_profile_name1',

      'YY:YY:YY:YY:YY:YY': 'port_profile_name2'}

This implies that the administrator must manually copy the port profile names from UCS-M and the MAC addresses assigned by the engine and write the above dictionary.

## Current status

*   Design.

## Integration levels

Considering the current level of integration (using the current vdsm-hook-vmfex) as level 3. The proposed levels of this feature are:

### Level IV: "A New Hook"

This level of integration consists on reworking the existing vdsm-hook-vmfex so that the oVirt administrator can set up the integration at the guest device level instead of at the VM level. The advantage of this is that only the port profile will need to be specified (since the MAC address is already part of the VM's NIC properties given by the engine).

Things to be done:

*   Filter out virtual functions from being reported as nics.
*   Clone and refactor the current hook to use custom device properties and to run "before_device_create".

### Level V: "The Network provider strikes back"

This level of integration builds on top of the work that was laid out for the Neutron integration, i.e., Network providers, so that we can use the UCS-M API (it exposes all entities via XML HTTP requests) to retrieve the port profiles defined in the system. These port profiles would available for selection in the VM nic creation dialog.

Things to be done:

*   Implement a Network provider that talks to UCS-M via its XML RPC.
*   Make the scheduler aware of virtual function availability for scheduling VMs that use the integration. (This could be retrieved from the hosts vdsm or maybe from UCS-M as part of the vnic-conn-policy, specifically its dynamic eth attribute).

### Level VI: "The return of the Port Profile"

This level of integration would make it possible for the oVirt engine to go from simply retrieving Port Profiles to exporting oVirt networks to UCS-M as Port Profiles.

*   Define a good matching abstraction between oVirt's QoS and UCS's.
*   Extend the network provider for creating profiles in UCS-M.

### Level VII: "Working title: The rise of the Host"

It is left for future planning, but the basic idea would be to be able to use the networks of the UCS Network provider from level V and apply them to host virtual functions from the oVirt API/GUI.

<Category:Feature> <Category:Networking>

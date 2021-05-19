---
title: UCS Integration
category: feature
authors: apuimedo, danken, mburman
---

# UCS Integration

## Summary

Cisco's Unified Computing System (UCS) is a solution for managing a lot of datacenter aspects, from blade's firmware to network cards number and addresses on the hosts and the VMs. It has a management service (UCS-M) that allows the administrator to easily set up configurations to apply to the hardware of the datacenter.

UCS hosts have network cards that can expose N pseudo physical Network Interface Cards, optionally (and usually) as ethernet cards. Those pseudo ethernet cards are called Virtual Functions (VFs) and when they are not configured they are blank devices, i.e., they lack mac address and any connectivity to the network fabric. One particular benefit of the virtual functions is that they can be connected to the guest's operating system offering a superior network performance, since the Host OS is not involved and parts are hardware accelerated.

In terms of networking the configuration for a nic is set in UCS-M in entities called vNic Templates. A vNic template allows you to specify network attributes for the nics created from it such as: - Quality of Service, - VLANs: One can specify the default tag and the tags it should let through, - MTU, - MAC Pool: The network administrator can define several pools of MAC addresses in UCS-M from which a template can draw addresses from.

When a vNic Template applies only to host nics it is called vNic profile. When it also applies to VM vNics an entity is created in UCS-M called \*Port Profile\*.

## Owner

*   Name: Antoni Segura Puimedon (APuimedo)
*   Email: apuimedo aT redhat.com

## oVirt/UCS-M networking integration state prior to this feature

USC virtual functions used to be reported to Engine as regular nics. VFs that have not been configured via UCS-M to have a mac address and connectivity are still reported, despite their uselessness for Host networking.

There was a now-deprecated Vdsm hook, [vdsm-hook-vmfex](http://resources.ovirt.org/releases/3.3/rpm/EL/6/noarch/vdsm-hook-vmfex-4.13.0-11.el6.noarch.rpm) that after being installed on each host, takes action upon VM creation and migration that:

*   Sets up a pool of virtual functions (thanks to the pool, migration is possible. As far as there are unused devices in the pool, we can assign a vnic to a virtual function).
*   Assigns the Engine-specified MAC address to a virtual function from the pool.
*   Specifies a *Port Profile* the virtual function should adopt.
*   Creates a macvtap device connected to the virtual function and replaces the VM nic definition with it.

For the hook to work, one must manually specify the VM custom properties with

      {'XX:XX:XX:XX:XX:XX': 'port_profile_name1',
       'YY:YY:YY:YY:YY:YY': 'port_profile_name2'}

The profile names should first be defined in UCS-M following Cisco's [instructions](http://www.cisco.com/c/en/us/td/docs/unified_computing/ucs/sw/vm_fex/kvm/gui/config_guide/2-1/b_GUI_KVM_VM-FEX_UCSM_Configuration_Guide_2_1/b_GUI_KVM_VM-FEX_UCSM_Configuration_Guide_2_1_chapter_010.html#task_1892A1847A4F45F6A6363B98091AF61A). The administrator must then manually copy the port profile names from UCS-M and the MAC addresses assigned by the engine and write the above dictionary.

This old hook vdsm-hook-vmfex should not be used. It has been deprecated in favor of vdsm-hook-vmfex-dev ("New Hook" below).

## Current status

Level IV completed and released.

## Integration levels

Considering the current level of integration (using the current vdsm-hook-vmfex) as level 3. The proposed levels of this feature are:

### Level IV: "A New Hook"

This level of integration consists of reworking the existing vdsm-hook-vmfex so that the oVirt administrator can set up the integration at the guest device level instead of at the VM level. The advantage of this is that only the port profile will need to be specified (since the MAC address is already part of the VM's NIC properties given by the Engine).

Things done:

*   [Filter out unused virtual functions from being reported as nics](http://gerrit.ovirt.org/#/c/22559/).
*   [Clone and refactor the current hook to use custom device properties and to run "before_device_create" and "before_device_hotplug"](http://gerrit.ovirt.org/#/c/22529/).

You can get the hook resulting from this integration level [here](https://resources.ovirt.org/releases/3.4/rpm/EL/6/noarch/vdsm-hook-vmfex-dev-4.14.6-0.el6.noarch.rpm)

#### Installation

*   Use the engine-config to append the appropriate custom property:

       sudo engine-config -s CustomDeviceProperties=
       '{type=interface;prop={vmfex=^[a-zA-Z0-9_.-]{2,32}$}}'

*   Verify that the vmfex_dev custom device propertes were properly added:

         sudo engine-config -g CustomDeviceProperties

#### Usage

*   Define an oVirt vNIC profile and set one of its custom properites to "vmfex" with the value of the name of UCS port profile. For instance:

            vmfex: myPortProfileId

*   Attach the oVirt vNIC profile to a VM vNIC. When the VM runs, the vNIC with the vmfex custom device, the xml definition of which might originally look like:

<!-- -->

    <interface type='bridge'>
        <mac address='<mac>'/>
        <model type='virtio'/>
        <source bridge='<logical network>'/>
    </interface>

will be transformed into:

    <interface type='network'>
        <mac address='<mac>'/>
        <source network='direct-pool'/>
        <virtualport type='802.1Qbh'>
            <parameters profileid='<Port Profile id>'/>
        </virtualport>
        <model type='virtio'/>
    </interface>

## Current status

Level V completed and released as vdsm-hook-vmfex-dev

### Level V: "The Network provider strikes back"

This level of integration builds on top of the work that was laid out for the Neutron integration, i.e., Network providers, so that we can use the UCS-M API (it exposes all entities via XML HTTP requests) to retrieve the port profiles defined in the system. These port profiles would be available for selection in the VM nic creation dialog.

Things to be done:

*   Implement a Network provider that talks to UCS-M via its XML RPC.
*   Make the scheduler aware of virtual function availability for scheduling VMs that use the integration. (This could be retrieved from the hosts' Vdsm or maybe from UCS-M as part of the vnic-conn-policy, specifically its dynamic eth attribute. The former has the benefit of helping non-UCS sriov setups.).

### Level VI: "The return of the Port Profile"

This level of integration would make it possible for the oVirt Engine to go from simply retrieving Port Profiles to exporting oVirt networks to UCS-M as Port Profiles.

*   Define a good matching abstraction between oVirt's QoS and UCS's.
*   Extend the network provider for creating profiles in UCS-M.

### Level VII: "Working title: The rise of the Host"

It is left for future planning, but the basic idea would be to be able to use the networks of the UCS Network provider from level V and apply them to host virtual functions from the oVirt API/GUI.


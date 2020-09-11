---
title: Hosted engine VM management
category: feature
authors: roy, sandrobonazzola
feature_name: Hosted engine VM management enhancements
feature_modules: api,engine,hosted-engine-setup,vdsm
feature_status: Design & research
---

# Hosted engine VM management enhancements

## Summary

1.  Allow editing the Hosted engine VM, storage domain, disks, networks etc - new feature
2.  Have a shared configuration for the hosted engine VM - new feature
3.  Have a backup for the hosted engine VM configuration - new feature

the 1st feature by-products are the 2nd and 3rd.

## Owner

*   Roy Golan <rgolan@redhat.com>
*   Sandro Bonazzola <sbonazzo@redhat.com>

## Detailed Description

Managing the hosted-engine engine VM is a non trivial taks and mostly manual today. if the engine Vm needs tuning, or some addition(add a device), one must reach all the hosted engine capable hosts and alter the local /etc/ovirt-hosted-engine/vm.conf instances. Although visible in the UI, the engine-VM have most of the provisioning actions blocked, as the VM is a external or foreign VM to the setup, as we don't manage its Storage Domains, Disks, Data-Center and Networks.

## Benefit to oVirt

The engine-VM should be treated as any other VM in the system, from provisioning standpoint. We should be able to edit its configuration using webadmin or API and expect the next time it will run it will take effect. This saves the time consuming, error-prone, non-trivial task of updating the vm.conf under each and every capable host in the system. As a regular VM, the engine VM would automatically gain most of the functionally supported by ovirt. More-over, the engine VM configuration would be backed up in the engine DB and in the OVF_STORE under the preconfigured hosted engine storage domain.

## Dependencies / Related Features

*   vdsmcli API must be changed for allowing to start a VM provided the VM UUID (OVF can be taken from OVF_STORE automatically just giving the VM UUID)
*   host-deploy must be changed in order to allow the deployment / configuration of the ha daemons ([Bug 1200469](https://bugzilla.redhat.com/1200469) - [RFE] add support for hosted-engine deployment on additional hosts)
*   [[Bug 1139793](https://bugzilla.redhat.com/1139793) - [RFE] Keep hosted engine VM configuration in the shared storage
*   ovirt-engine must be changed for allowing hosted-engine storage domain to be visible / handled
*   ovirt-engine must be changed to allow the deployment of hosted-engine nodes from the portal ([Bug 1167262](https://bugzilla.redhat.com/1167262) - [RFE] allow to deploy additional hosts from webadmin portal)
*   ovirt-ha daemons should use vdscli new API instead of using legacy vdsClient ([Bug 1101554](https://bugzilla.redhat.com/1101554) - [RFE] Use vdsm api instead of vdsClient ) in order to start the VM by UUID

## Design

### High level flow

1.  installation creates and upload the OVF {VM guid}.ovf to a pre-created OVF_DISK
2.  HA Agent read’s OVF from OVF_STORE
3.  watchdog send a vdsm “create” verb with the OVF as argument. VM starts.
4.  Installation imports the SD into ovirt-engine
5.  Installation imports the engine VM from the OVF which resides in OVF_STORE
6.  Changes made to the engine VM are persisted back to the OVF_STORE under the OVF file
7.  Regular API usage apply to the engine VM - should we prevent the engine VM deletion or one of its disks? (for sure make it delete protected at first)

### User Experience

#### CRUD

*   Waiting for the RFE for full requirements\*

engine VM is auto added to engine(no change 3.5) Initially, once the Host is doing the first Vm monitoring cycle it will auto add the engine VM to ovirt-engine. the VM then will be an “External VM” - it can’t be edited. import storage domain ***[4]*** Now the storage domain which have the OVF_STORE disks previously created by hosted-engine setup must be imported into the engine. Engine 3.5 already support importing a storage domain.

import the VM from OVF_STORE disks ***[5]*** Once the domain is imported, the OVFs in the OVF_STORE can be read by engine and be imported into the setup. Importing a VM from OVF on OVF_STORE disk is supported in 3.5

**Once the engine VM is imported a user can:**

*   add/edit VM configuration
*   add/edit disks
*   add/edit nics
*   edit certain storage domain attributes //TODO need editing

overall interface has on real change.

could be nice to have - a special icon/markup on the VMs grid to distinguish it from other VMs

**Some operation are blocked altogether using CanDoAction:**

*   remove storage domain
*   remove OVF_STORE disk
*   any other actions should be prevented in order not to chop the branch we sit on

#### Install/Upgrade

##### Fresh install

1.  ovirt-hosted-engine-setup shall create an OVF_STORE disk (using vdsm api)
2.  ovirt hosted-engine-setup shall store the vm config as OVF in the disk (using vdsm api)
3.  post VM install and verification, setup should add the SD which the OVF_STORE
4.  located on the engine-VM (engine api)
5.  engine VM shall be imported from the SD above mentioned (engine api)

##### Upgrade

1.  convert the current vm.conf to OVF(some python util?) or export the OVF from the engine DB (should be there under vm_ovf_generations)
2.  create OVF store disk on the existing hosted engine SD (vdsm api) - or maybe it already exists? need to check that
3.  import SD (engine api)
4.  import VM (engine api)

##### Persistency

Once imported, the VM is considered a regular VM and every changed to its configuration is exported to its underlying OVF on the OVF_STORE. That way changes are persistent and shared across all cluster nodes.

All VM changes are persisted to OVF_STORE once an hour by a task which isn’t good for this case. Changes to Engine VM should be persisted synchronously ***[6]*** user should be able to edit the VM and after short time the changes should already be persisted.

This means that editing an engine-VM must trigger a new upload of tar.gz to the host of the new OVF. ovirt-engine must have a nice separation in CRUD operations on| engine-VM in order not to fill up the code with if-(hosted-engine)-then(do)-else It would be an enhancement if VDSM would be able to get a single ovf updated instead of whole new tar.gz

## Open Issues

There is no easy way to convert an OVF to vm.conf in a standalone way. OVF have engine specific information which VDSM isn’t aware of (cluster-specific details, osinfo details, internal engine enum id’s and so on) - see Documentation / External references

TODO - map what fields rely on engine - some may be not that important for now and some may be extended to be non engine dependant in some way (e.g display protocol as sting “vnc” instead of a number) - see Documentation / External references VDSM maintainers might not accept to handle OVF file as an alternative argument for the “create” verb. so instead of putting the translation of OVF-vmParams in VDSM we might expose that tool differently.

## Documentation / External references

*   Bug: [1160094](https://bugzilla.redhat.com/show_bug.cgi?id=1160094)
*   OVF -> vm.conf compatibility - in effort to understand the gap for of OVF to vm.conf or vmParameters (the vm arguments for starting a VM using VDSM API)

## Testing

//TODO

## Release Notes


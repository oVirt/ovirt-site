---
title: virt-v2v Integration
category: feature
authors: arik
wiki_category: Feature
wiki_title: Features/virt-v2v Integration
wiki_revision_count: 16
wiki_last_updated: 2015-01-28
---

# virt-v2v integration

### Summary

Integrate virt-v2v in oVirt for importing virtual machines from external environments

### Owner

*   Name: [ Arik Hadas](User:Arik)
*   Email: <ahadas@redhat.com>

### Current status

*   Status: Design
*   Targete Release: TBD
*   Last updated: ,

### Detailed Description

virt-v2v is a tool which can be used to convert virtual machines from Xen and VMware hypervisors to run on KVM. If the output mode is set to 'rhev', the output of the conversion is like a VM which was exported by oVirt, i.e virtual machine which is located in the export domain. Such a virtual machine can be imported to oVirt using the regular import-vm operation.

This feature aims to add external providers of virtual machines to oVirt which are based on virt-v2v tool:

*   Ease the usage of virt-v2v by letting the user to configure the relevant parameters from the UI (webadmin) & REST-API (?)
*   Hide technical complexities (such as authentication settings)
*   Show the conversion progress

#### High-level design

The user will be able to create provider per-each external system which contains virtual machines that can be converted to oVirt's export domain using v2v. A typical usage of a provider will be:

*   List all the virtual machines that exist in the external system
*   Select virtual machine from the list
*   Configure the properties of the conversion
*   Start the conversion and start monitoring

While configuring such provider, the user will need to specify which host will serve as a proxy for the interaction with the external system. We require that a particular host will be chosen as a proxy because it is likely that the different systems will reside in different networks, so using a proxy, only the proxy needs to be connected to the external system.

![](V2v_1.png "V2v_1.png")

Only a host which is installed with virt-v2v can be set as a proxy. TBD - installing v2v?

VDSM will bridge the interaction between the engine and virt-v2v. The following diagram demonstrate the interaction between the different components in the process of import virtual machine from external system to oVirt:

![](Seq2.jpg "Seq2.jpg")

At the end of the process, the output will be located on the export domain.

#### Import buttons

As part of this feature we will address an inconsistency which exists in oVirt related to 'import' buttons. Looking at the Networks & Hosts tabs, we see that the import operation of an entity is located in the entity's tab: - In the Networks tab there is a dedicated button for import network from external provider - The operation of import host from Foreman resides in the 'New Host' dialog which is invoked from within the Hosts tab

Currently the button for the 'import VM' operation is located in the export domain sub-tab, i.e not in the Virtual Machines tab but in the storage sub-tab.

To resolve this inconsistency, we will do the following changes:

*   The button for the existing 'import VM' operation, i.e import VM from the export domain into the 'system', will be moved to the Virtual Machines tab, in a similar way to how it is shown for networks (TBD - 'import template' should be moved to the Templates tab as part of this feature as well?).
*   New 'import' operation will be added to the export domain sub-tab instead of the previous 'import' button, which will represent the operation of import virtual machine from external system into the export domain.

### Benefit to oVirt

This feature should make it easier to migrate from different environments to oVirt/RHEV. The import process of virtual machines will be based on the versatile virt-v2v tool, and will be improved by:

*   Making it easier to define - expose the relevant parameters in the UI
*   Making it less error-prone - less configuration to set
*   Making it more managed - the process will be executed and monitored by oVirt

### Dependencies / Related Features

### Design

#### Database

#### Backend

#### VDSM

#### User Interface

---
title: Cluster parameters override
category: feature
authors: eshachar, sandrobonazzola
wiki_category: Feature|Cluster parameters override
wiki_title: Features/Cluster parameters override
wiki_revision_count: 8
wiki_last_updated: 2014-12-12
feature_name: VM emulated machine
feature_modules: engine
feature_status: Design
---

# Cluster parameters override

## VM emulated machine

### Summary

This feature allows to configure a specific 'emulated machine type' for each VM instead of relying solely on the cluster default.

### Owner

*   Name: [ Eldan Shachar](User:eshachar)

<!-- -->

*   Email: <eshachar@redhat.com>

### Current status

*   Status: Design
*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Detailed Description

Currently, every VM inherits its machine-type value('-M' flag in QEMU) from the cluster, this value is constant and based on the cluster compatibility level. This feature will allow to override this setting by manually configuring a machine-type value for every VM separately. The cluster level property will still exist, every new VM will inherit its cluster setting unless specifically stated otherwise.

### Design

The new property will be added to the VM objects (affecting templates as well) and controlled by the user via the different interfaces. When executing a VM, the engine will use the new VM level property and will fallback to the cluster level only if the VM property was not set.

#### Database

*   Add an 'emulated_machine' field to the vm_static table. the field default value will be null (use cluster property).

#### Backend

*   Add property to the various VM objects.
*   Add property to the ovf reader\\writer.
*   Change VDSBroker to use the VM emulated-machine property and fallback to the cluster only if the property was not set.
*   Add support for commands for the following actions: Add VM, Edit VM, Create Template, Edit template, Add Instance, Edit instance. The setting will take effect only at the next run of the VM.

#### VDSM

No need for changes in the VDSM.

#### User Interface

Support the new setting for the following actions: Add VM, Edit VM, Create Template, Edit template, Add Instance, Edit instance.
\*Each host has a limited set of possible machine-types but this information is sometimes unavailable (e.g a cluster without hosts), from this reason machine-type input can't be validated by the engine.

##### WEB - (User and Admin)

*   Add an 'emulated-machine' textbox in the 'System tab' for each of the specified actions. Provide a tooltip with the default cluster machine-type (if information is available).

##### REST

*   Add a REST\\rsdl property for these actions.
*   Display the new property under the 'All-Content' header for the entities VM\\Template\\Instance.

### Benefit to oVirt

This change will allow a more flexible emulation preferences while providing a better support for backward-compatibility. A setup which consists of several machine-types currently needs a different cluster for each machine-type, this change will allow the user to choose a cluster with a high compatibility level and then customize each VM to the required machine-type.
This can be useful for cases in which a higher hardware level is unsupported by the desired OS or simply unneeded and problematic.

### Documentation / External references

*   RFE: <https://bugzilla.redhat.com/show_bug.cgi?id=838487>

### Comments and Discussion

*   Refer to [Talk:VM emulated machine](Talk:VM emulated machine)

<Category:Feature>

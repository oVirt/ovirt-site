---
title: Cluster parameters override
category: feature
authors:
  - eshachar
  - ofrenkel
  - sandrobonazzola
---

# Cluster parameters override

## Summary

This feature allows to configure the 'emulated machine' and 'cpu model' parameters for each VM separately instead of relying on the cluster default.

## Owner

*   Name: Eldan Shachar (eshachar)


## Detailed Description

Currently, every VM inherits its machine-type value('-M' flag in QEMU) and its cpu-model value from the cluster. This feature will allow to override these settings by manually configuring them for each VM. The change will also enable a user to set these properties to values which are unsupported by the cluster compatibility level, in that case the VM will only run on hosts which support its requirements. The cluster level properties will still exist, every new VM will inherit its cluster settings unless specifically stated otherwise.

## Design

The new properties will be added to the VM objects (affecting templates as well) and controlled by the user via the different interfaces. When executing a VM, the engine will use the VM level property and will fallback to the cluster level only if the VM property was not set.

### Database

*   Add the field 'custom_emulated_machine' to the vm_static table. the field default value will be null (use cluster property).
*   Add the field 'custom_cpu_name' to the vm_static table. the field default value will be null (use cluster property).
*   Add the field 'emulated_machine' to the vm_dynamic table.

### Backend

*   Add properties to the various VM objects.
*   Add properties to the ovf reader\\writer.
*   Change VDSBroker to use the new VM properties and fallback to the cluster only if the VM property was not set.
*   Add support for commands for the following actions: Add VM, Edit VM, Create Template, Edit template, Add Instance, Edit instance, Add pool, Edit pool. The setting will take effect only at the next run of the VM.
*   Add a scheduler filter for emulated-machine property, the scheduler will scan the cluster for hosts which supports the specified machine-type, if none is found the execution will be aborted.
*   Fix the cpu-level scheduler filter to ignore cluster compatibility version. (the VM object patch mentioned above will allow the existing filter to use the static cpu_model property in addition to the existing dynamic one)

### VDSM

No need for changes in the VDSM.

### User Interface

Support the new settings for the following actions: Add VM, Edit VM, Create Template, Edit template, Add Instance, Edit instance, Add pool, Edit pool.
\*Each host has a limited set of possible machine-types/cpu-models but this information is sometimes unavailable (e.g a cluster without hosts), from this reason these properties can't be validated by the engine until the VM execution stage.

#### WEB - (User and Admin)

*   Add an editable combo-box labeled 'Emulated machine' in the 'System tab' for each of the specified actions.
*   Add an editable combo-box labeled 'CPU model' in the 'System tab' for each of the specified actions.
*   Add an editable combo-box for the two fields in the 'System tab' under run-once.

#### REST

*   Add REST properties - 'custom_emulated_machine' and 'custom_cpu_model' for the entities VM\\Template\\Instance.
*   Add RSDL properties for each of the actions mentioned above.

## Benefit to oVirt

A more flexible host specific preferences - a setup which consists of VMs running under different host parameters currently needs a cluster for each subset of parameters, this change will allow the user to customize each VM with its own host parameters.
This will allow a user to provide a backward-compatibility for certain VMs and test new emulation settings before changing them for the whole cluster.

## Documentation / External references

*   RFE: <https://bugzilla.redhat.com/show_bug.cgi?id=838487>
*   RFE: <https://bugzilla.redhat.com/show_bug.cgi?id=838490>
*   RFE: <https://bugzilla.redhat.com/show_bug.cgi?id=952238>




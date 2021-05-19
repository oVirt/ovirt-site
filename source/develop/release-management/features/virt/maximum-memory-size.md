---
title: Maximum memory size
category: feature
authors: jniederm
---

# Maximum memory size

## Owner

*   Name: Jakub Niedermertl (jniederm)
*   Email: <jniederm@redhat.com>

## Summary
All VM-like entities (VMs, templates, pools, instance types) have new attribute 'maximum memory' corresponding to
libvirt's `maxMemory` ([libvirt documentation][1]). It sets upper bound up to which memory hot-plug can be performed.

[Related bug](https://bugzilla.redhat.com/show_bug.cgi?id=1388245).

## Engine
Maximum memory value is stored in `VmBase.maxMemorySizeMb` property. It is validated against range 
\[*memory of VM*, **MaxMemorySizeInMB*], where **MaxMemorySizeInMB* is one of `VM32BitMaxMemorySizeInMB`,
`VM64BitMaxMemorySizeInMB` and `VMPpc64BitMaxMemorySizeInMB` configuration options depending on selected operating 
system of the VM. Default value in webadmin UI is 4x size of memory.

During migration of engine 4.0 -\> 4.1 all VM-like entities will get max memory = 4x memory.

If a VM (or template) is imported (from export domain, snapshot, external system) and doesn't have max memory set yet,
the maximum value of max memory is set (`*MaxMemorySizeInMB` config options).

## Database
Maximum memory is stored in column `vm_static.max_memory_size_mb`.

## REST API
Maximum memory is available in tag *VM-like entity*`/memory_policy/max`. E.g.

```xml
GET ovirt-engine/api/vms/{vmId}

<vm id="...">
    ...
    <memory_policy>
        <max>4398046511104</max>
        ...
    </memory_policy>
    ...
</vm>
```

## Note on size of maximum memory

If memory hot-plug is not required, max memory can be set to be the same as VM memory. Suggested value is 4x size of
VM memory. Larger max memory is discouraged because:

* I can make QEMU process to start for longer time.
* If hot plugged memory is also required to be hot unpluggable, it needs to be considered as *movable* by the guest kernel.
  Kernel requires the amount of movable memory to be at most 4x larger that non-movable memory for stable run.
* On PowerPC platform continuous block of non-movable memory of size 1/64 of the max memory needs to be allocated for 
  each VM.
  
[1]: https://libvirt.org/formatdomain.html#elementsMemoryAllocation

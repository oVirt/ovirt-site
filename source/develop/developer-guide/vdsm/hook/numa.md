---
title: numa
authors: dyasny
---

# numa

The numa hook adds numa support to a VM's XML definitions. This can help improve a VM placement on the NUMA nodes of a NUMA-enabled host

The libvirt XML will have the following entry added:

```xml
<numatune>
    <memory mode="strict" nodeset="1-4,^3"/>
</numatune>
```
Syntax:

`numa=<memory policy>:<numaset>`

Where memory policy can be

*   interleave
*   strict
*   preferred

And the numa set will look like this:

*   `numaset="1"` (use one NUMA node)
*   `numaset="1-4"` (use 1-4 NUMA nodes)
*   `numaset="^3"` (don't use NUMA node 3)
*   `numaset="1-4,^3,6"` (or combinations)

Examples:

      numa=strict:1-4
      numa=strict:5
      numa=interleave:1-4,^3,6


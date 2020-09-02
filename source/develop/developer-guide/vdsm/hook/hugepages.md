---
title: hugepages
authors: dyasny
---

# hugepages

The hugepages vdsm hook will receive hugepages=512 and will preserve 512 huge pages for the VM

This is useful for VMs running large memory loads, so that memory page fragmentation is lowered and the VM can access larger memory chunks at a time. The downside is more potential for wasted RAM.

How this works: The hook will add pages: sysctl vm.nr_hugepages=512 and will add add the following xml in domain\\devices:

```xml
   <memoryBacking>
       <hugepages/>
   </memoryBacking>
```

IMPORTANT: hugepages must be mounted prior to libvirt start up, ie:

      # mount -t hugetlbfs hugetlbfs /dev/hugepages
      # initctl restart libvirtd

Syntax:

      hugepages=512


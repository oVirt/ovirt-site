---
title: hugepages
authors: dyasny
wiki_title: VDSM-Hooks/hugepages
wiki_revision_count: 2
wiki_last_updated: 2012-09-14
---

# hugepages

The hugepages vdsm hook will receive hugepages=512 and will preserve 512 huge pages for the VM

This is useful for VMs running large memory loads, so that memory page fragmentation is lowered and the VM can access larger memory chunks at a time. The downside is more potential for wasted RAM.

How this works: The hook will add pages: sysctl vm.nr_hugepages=512 and will add the following xml in domain\\devices:

`   <memoryBacking>  `
`     <hugepages/>   `
`       </memoryBacking> `

IMPORTANT: hugepages must be mounted prior to libvirt start up, ie:

      # mount -t hugetlbfs hugetlbfs /dev/hugepages
      # initctl restart libvirtd

Syntax:

      hugepages=512

Download link: <http://ovirt.org/releases/nightly/rpm/EL/6/hooks/vdsm-hook-hugepages-4.10.0-0.442.git6822c4b.el6.noarch.rpm>

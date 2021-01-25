---
title: vm coredump
category: feature
authors: doron, sfeng
---

# vm coredump

## Coredump support in VDSM

### Summary

This feature adds [1](http://en.wikipedia.org/wiki/Core_dump) support to VDSM. The feature will dump the core of a domain on a given file for analysis. It will be especially useful when used with high availability.

### Owner

*   Name: ShaoHe Feng (Shaohef)
*   Email: <shaohef@linux.vnet.ibm.com>

### Current status

*   Status: the patch was under review. [dump the core of a VM](http://gerrit.ovirt.org/#/c/7329).
*   Last updated: ,

### Detailed Description

### Benefit to oVirt

Users will be able to dump the core of a VM on a given file when their VMs crash. This will be especially important for highly available servers.

### Dependencies / Related Features

This feature depends on the libvirt (already support)

### Documentation / External references

For libvirt support, please see [libvirt's documentation on virDomainCoreDump API](https://libvirt.org/html/libvirt-libvirt-domain.html#virDomainCoreDump).

#### User Interface

```python
def coreDump(self, to, params):

         """  
         dump a VM to a designated file.
         :param to: a string designates the dump file 
         :param params: a dictionary containing:
             *post-action* - The action taken after core dump, which is
                             'crash', 'live', or 'reset'.
                             crash: crash the VM after core dump.
                             live: perform a live core dump.
                             reset: reset the VM after core dump.
             *bypass-cache* - avoid file system cache when saving.
             *memory-only* - dump VM's memory only.
         """  
```



---
title: qemucmdline
authors: dyasny
wiki_title: VDSM-Hooks/qemucmdline
wiki_revision_count: 2
wiki_last_updated: 2012-09-14
---

# qemucmdline

qemu_cmdline hook:

libvirt provides support for passing QEMU cmdline options. With the help of this, one can inject QEMU options bypassing the libvirt's domain XML code. This can help immensely in testing and developing new qemu features, which are not yet in libvirt and/or injecting experimental options.

The os environ 'qemu_cmdline' points to a json list, containing the qemu option followed by value as individual list entries. For qemu option that does not take any value, skip the value entry.

Note that validation of the option and value list entries is NOT done, its passed as-is to qemu and in the same order as present in the list.

Example:

      qemu_cmdline='["-cdrom","`<path/to/iso>`", ...]'

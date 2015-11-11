---
title: kernel cmdline
category: feature
authors: mpolednik
wiki_category: Feature|OVMF
wiki_title: Features/kernel cmdline
wiki_revision_count: 2
wiki_last_updated: 2015-11-12
---

# Kernel Cmdline

### Summary

This feature will add support for limited modifications of kernel cmdline via grub2 defaults. This will allow enabling or disabling functions such as nested virtualization, iommu (and related quirks) or using pci-stub from VDSM API.

### Owner

*   name: [ Martin Polednik](User:Martin Polednik)
*   email: <mpolednik@redhat.com>

### Current Status

*   last updated date: Wed Nov 11 2015

### Requirements

*   Linux system with grub2 bootloader

### API

#### Public

`cmdlineModify -> [(String, String)] -> [(String, String)] -> [String] -> [String]` - the arguments are explained below.

This command will regenerate grub2 boot config - and should therefore be considered quite expensive.

#### Arguments

*   `add_to_stub` - Bind a list of devices identified by 2-tuple (vendor_id, product_id) to pci-stub. The change takes effect after host reboot. Duplicates are only added once (if not already present).
*   `del_from_stub` - Unbind a list of devices identified by 2-tuple (vendor_id, product_id) to pci-stub. The change takes effect after host reboot.
*   `add_to_cmdline` - Add a list of strings to kernel cmdline. These strings are isolated in their own variables, may not contain space and must be valid shell statement.
*   `del_from_cmdline` - Delete previously added list of strings from kernel cmdline. Only values added by \`cmdlineAdd\` may be removed.

### Expected Workflow

1.  `cmdlineModify`
2.  host reboot

After booting up, the changes should be in effect.

### References

<references/>
[OVMF](Category:Feature) [OVMF](Category:oVirt 4.0 Proposed Feature)
